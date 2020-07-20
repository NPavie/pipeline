package org.daisy.pipeline.tts.aws.impl;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.sound.sampled.AudioFormat;

import net.sf.saxon.s9api.XdmNode;

import org.daisy.pipeline.audio.AudioBuffer;
import org.daisy.pipeline.tts.AudioBufferAllocator;
import org.daisy.pipeline.tts.AudioBufferAllocator.MemoryException;
import org.daisy.pipeline.tts.MarklessTTSEngine;
import org.daisy.pipeline.tts.SoundUtil;
import org.daisy.pipeline.tts.TTSRegistry.TTSResource;
import org.daisy.pipeline.tts.TTSService.SynthesisException;
import org.daisy.pipeline.tts.Voice;

public class AWSRestTTSEngine extends MarklessTTSEngine {

	private AudioFormat mAudioFormat;
	private RequestScheduler mRequestScheduler;
	private int mPriority;
	private String mAccessKey;
	private String mSecretKey;
	private String mRegion;
	
	public AWSRestTTSEngine(AWSTTSService awsService, AudioFormat audioFormat, String accessKey, String secretKey, 
			String region, RequestScheduler requestScheduler, int priority) {
		super(awsService);
		mPriority = priority;
		mAudioFormat = audioFormat;
		mRequestScheduler = requestScheduler;
		mAccessKey = "AKIAJUWCEFT47BE2VBEA";
		mSecretKey = "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";
		mRegion = "eu-west-3"; 
	}
	
	@Override
	public int expectedMillisecPerWord() {
		return 64000;
	}

	@Override
	public Collection<AudioBuffer> synthesize(String sentence, XdmNode xmlSentence,
			Voice voice, TTSResource threadResources, AudioBufferAllocator bufferAllocator, boolean retry)
					throws SynthesisException,InterruptedException, MemoryException {
		
		if (sentence.length() > 5000) { // CB pour AWS ??
			throw new SynthesisException("The number of characters in the sentence must not exceed 5000.");
		}

		Collection<AudioBuffer> result = new ArrayList<AudioBuffer>();

		// the sentence must be in an appropriate format to be inserted in the json query
		// it is necessary to wrap the sentence in quotes and add backslash in front of the existing quotes
		
		String adaptedSentence = "";
		
		for (int i = 0; i < sentence.length(); i++) {
			if (sentence.charAt(i) == '"') {
				adaptedSentence = adaptedSentence + '\\' + sentence.charAt(i);
			}
			else {
				adaptedSentence = adaptedSentence + sentence.charAt(i);
			}
		}
		
		adaptedSentence = '"' + adaptedSentence + '"';
		
		String name;

		if (voice != null) {
			name = '"' + voice.name + '"';
		}
		else {
			// by default the voice is set to English
			name = '"' + "Brian" + '"';
		}
		
		HttpURLConnection con = null;
		
		boolean isNotDone = true;
		
		// we loop until the request has not been processed 
		// (google limits to 300 requests per minute or 15000 characters)
		while(isNotDone) {
			
			try {
				
				String method = "POST";
				String service = "polly";
				String host = service + '.' + mRegion + ".amazonaws.com";
				String api = "/v1/speech";
				String endpoint = "https://" + host + api;
				String contentType = "application/json";
				
				String requestParameters = "{";
				requestParameters += "\"OutputFormat\": \"pcm\",";
				//requestParameters += "\"SpeechMarkTypes\": [ \"ssml\" ],";
				requestParameters += "\"Text\":" + adaptedSentence + ",";
				requestParameters += "\"TextType\": \"ssml\",";
				requestParameters += "\"VoiceId\":" + name;
				requestParameters += "}";
				
				TimeZone tz = TimeZone.getTimeZone("UTC");
				DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
				DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
				amzDateFormat.setTimeZone(tz);
				datestampFormat.setTimeZone(tz);
				String amzDate = amzDateFormat.format(new Date());
				String datestamp = datestampFormat.format(new Date());
				
				String canonicalUri = api;
				String canonicalQuerystring = "";
				String canonicalHeaders = "content-type:" + contentType + '\n' + "host:" + host + '\n' + "x-amz-date:" + amzDate + '\n';
				String signedHeaders = "content-type;host;x-amz-date";
				String algorithm = "AWS4-HMAC-SHA256";
				String credentialScope = datestamp + '/' + mRegion + '/' + service + '/' + "aws4_request";
				String payloadHash = hashSHA256(requestParameters);
				
				String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
						+ signedHeaders + '\n' + payloadHash;
				
				String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);
				
				byte[] signingKey = getSignatureKey(mSecretKey, datestamp, mRegion, service);
				
			    byte[] hash = HmacSHA256(stringToSign, signingKey);
			    BigInteger number = new BigInteger(1, hash);
				StringBuilder hexString = new StringBuilder(number.toString(16));
				String signature = hexString.toString();
				
				String requestUrl = endpoint;
				
				String authorizationHeader = algorithm + ' ' + "Credential=" + mAccessKey + '/' + credentialScope + ", " + "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;
				
				URL url = new URL(requestUrl);
				con = (HttpURLConnection) url.openConnection();
				con.setRequestProperty("Accept", "application/json");
				con.setRequestProperty("Content-Type", contentType);
				con.setRequestProperty("X-Amz-Date", amzDate);
				con.setRequestProperty("Authorization", authorizationHeader);
				con.setDoOutput(true);
				
				try(OutputStream os = con.getOutputStream()) {
					byte[] input = requestParameters.getBytes("utf-8");
					os.write(input, 0, input.length);           
				}

				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				StringBuilder response = new StringBuilder();
				String inputLine;
				while ((inputLine = br.readLine()) != null) {
					response.append(inputLine.trim());
				}
				br.close();
				
				AudioBuffer b = bufferAllocator.allocateBuffer(response.length());
				b.data = response.toString().getBytes();
				result.add(b);
				
				isNotDone = false;

			} catch (Throwable e1) {
				
				try {
					if (con.getResponseCode() == 429) {
						// if the error "too many requests is raised
						mRequestScheduler.sleep();
					}
					else {
						SoundUtil.cancelFootPrint(result, bufferAllocator);
						StringWriter sw = new StringWriter();
						e1.printStackTrace(new PrintWriter(sw));
						throw new SynthesisException(e1);
					}
				} catch (Exception e2) {
					SoundUtil.cancelFootPrint(result, bufferAllocator);
					StringWriter sw = new StringWriter();
					e2.printStackTrace(new PrintWriter(sw));
					throw new SynthesisException(e2);
				}
				
			}
			
		}

		return result;
	}

	@Override
	public AudioFormat getAudioOutputFormat() {
		return mAudioFormat;
	}

	@Override
	public Collection<Voice> getAvailableVoices() throws SynthesisException,
	InterruptedException {

		Collection<Voice> result = new ArrayList<Voice>();
		
		HttpURLConnection con = null;

		boolean isNotDone = true;
		
		// we loop until the request has not been processed 
		// (google limits to 300 requests per minute or 15000 characters)
		while(isNotDone) {
			
			try {
				
				String method = "GET";
				String service = "polly";
				String host = service + '.' + mRegion + ".amazonaws.com";
				String api = "/v1/voices";
				String endpoint = "https://" + host + api;
				
				TimeZone tz = TimeZone.getTimeZone("UTC");
				DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
				DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
				amzDateFormat.setTimeZone(tz);
				datestampFormat.setTimeZone(tz);
				String amzDate = amzDateFormat.format(new Date());
				String datestamp = datestampFormat.format(new Date());
				
				String canonicalUri = api;
				String canonicalHeaders = "host:" + host + '\n';
				String signedHeaders = "host";
				String algorithm = "AWS4-HMAC-SHA256";
				String credentialScope = datestamp + '/' + mRegion + '/' + service + '/' + "aws4_request";
				String canonicalQuerystring = "X-Amz-Algorithm=AWS4-HMAC-SHA256";
				canonicalQuerystring += "&X-Amz-Credential=" + URLEncoder.encode(mAccessKey + '/' + credentialScope, StandardCharsets.UTF_8.toString());
				canonicalQuerystring += "&X-Amz-Date=" + amzDate;
				canonicalQuerystring += "&X-Amz-Expires=30"; // temps avant que la requete expire ???
				canonicalQuerystring += "&X-Amz-SignedHeaders=" + signedHeaders;
				
				String payloadHash = hashSHA256("");
				
				String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
						+ signedHeaders + '\n' + payloadHash;
				
				String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);
				
				byte[] signingKey = getSignatureKey(mSecretKey, datestamp, mRegion, service);
				
			    byte[] hash = HmacSHA256(stringToSign, signingKey);
			    BigInteger number = new BigInteger(1, hash);
				StringBuilder hexString = new StringBuilder(number.toString(16));
				String signature = hexString.toString();
				
				canonicalQuerystring += "&X-Amz-Signature=" + signature;
				
				String requestUrl = endpoint + "?" + canonicalQuerystring;

				URL url = new URL(requestUrl);
				con = (HttpURLConnection) url.openConnection();

				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				StringBuilder response = new StringBuilder();
				String inputLine;
				while ((inputLine = br.readLine()) != null) {
					response.append(inputLine.trim());
				}
				br.close();
				
				// we retrieve the names of the voices in the response returned by the API
				Pattern p = Pattern .compile("\"Id\":\"\\p{L}+\"");
				Matcher m = p.matcher(response);
				String s = "";
				String name = "";
				
				while (m.find()) {
					s = response.substring(m.start(), m.end());
					name = s.substring(6,s.length()-1);
					result.add(new Voice(getProvider().getName(),name));
				}

				isNotDone = false;

			} catch (Throwable e1) {
				
				try {
					if (con.getResponseCode() == 429) {
						// if the error "too many requests is raised
						mRequestScheduler.sleep();
					}
					else {
						throw new SynthesisException(e1.getMessage(), e1.getCause());
					}
				} catch (Exception e2) {
					throw new SynthesisException(e2.getMessage(), e2.getCause());
				}
				
			}

		}

		return result;

	}

	@Override
	public int getOverallPriority() {
		return mPriority;
	}

	@Override
	public TTSResource allocateThreadResources() throws SynthesisException,
	InterruptedException {
		return new TTSResource();
	}

	static String getMarksData(String sentence, Voice voice) throws Exception {
		
		// pour les test
		String mAccessKey = "AKIAJUWCEFT47BE2VBEA";
		String mSecretKey = "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";
		String mRegion = "eu-west-3"; 

		String adaptedSentence = "";

		for (int i = 0; i < sentence.length(); i++) {
			if (sentence.charAt(i) == '"') {
				adaptedSentence = adaptedSentence + '\\' + sentence.charAt(i);
			}
			else {
				adaptedSentence = adaptedSentence + sentence.charAt(i);
			}
		}

		adaptedSentence = '"' + adaptedSentence + '"';

		String name;

		if (voice != null) {
			name = '"' + voice.name + '"';
		}
		else {
			// by default the voice is set to English
			name = '"' + "Brian" + '"';
		}

		String method = "POST";
		String service = "polly";
		String region = mRegion;
		String host = service + '.' + region + ".amazonaws.com";
		String api = "/v1/speech";
		String endpoint = "https://" + host + api;
		String contentType = "application/json";

		String requestParameters = "{";
		requestParameters += "\"OutputFormat\": \"json\",";
		requestParameters += "\"SpeechMarkTypes\": [ \"ssml\" ],";
		requestParameters += "\"Text\":" + adaptedSentence + ",";
		requestParameters += "\"TextType\": \"ssml\",";
		requestParameters += "\"VoiceId\":" + name;
		requestParameters += "}";


		TimeZone tz = TimeZone.getTimeZone("UTC");
		DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
		DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
		amzDateFormat.setTimeZone(tz);
		datestampFormat.setTimeZone(tz);
		String amzDate = amzDateFormat.format(new Date());
		String datestamp = datestampFormat.format(new Date());

		String canonicalUri = api;
		String canonicalQuerystring = "";
		String canonicalHeaders = "content-type:" + contentType + '\n' + "host:" + host + '\n' + "x-amz-date:" + amzDate + '\n';
		String signedHeaders = "content-type;host;x-amz-date";
		String algorithm = "AWS4-HMAC-SHA256";
		String credentialScope = datestamp + '/' + region + '/' + service + '/' + "aws4_request";
		String payloadHash = hashSHA256(requestParameters);

		String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
				+ signedHeaders + '\n' + payloadHash;

		String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);

		byte[] signingKey = getSignatureKey(mSecretKey, datestamp, region, service);

		byte[] hash = HmacSHA256(stringToSign, signingKey);
		BigInteger number = new BigInteger(1, hash);
		StringBuilder hexString = new StringBuilder(number.toString(16));
		String signature = hexString.toString();

		String requestUrl = endpoint;

		String authorizationHeader = algorithm + ' ' + "Credential=" + mAccessKey + '/' + credentialScope + ", " + "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;

		URL url = new URL(requestUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestProperty("Accept", "application/json");
		con.setRequestProperty("Content-Type", contentType);
		con.setRequestProperty("X-Amz-Date", amzDate);
		con.setRequestProperty("Authorization", authorizationHeader);
		con.setDoOutput(true);

		try(OutputStream os = con.getOutputStream()) {
			byte[] input = requestParameters.getBytes("utf-8");
			os.write(input, 0, input.length);           
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
		StringBuilder response = new StringBuilder();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
			response.append(inputLine.trim());
		}
		br.close();

		return response.toString();
	}
	
	static byte[] HmacSHA256(String data, byte[] key) throws Exception {
	    String algorithm="HmacSHA256";
	    Mac mac = Mac.getInstance(algorithm);
	    mac.init(new SecretKeySpec(key, algorithm));
	    return mac.doFinal(data.getBytes("UTF-8"));
	}

	static byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception {
	    byte[] kSecret = ("AWS4" + key).getBytes("UTF-8");
	    byte[] kDate = HmacSHA256(dateStamp, kSecret);
	    byte[] kRegion = HmacSHA256(regionName, kDate);
	    byte[] kService = HmacSHA256(serviceName, kRegion);
	    byte[] kSigning = HmacSHA256("aws4_request", kService);
	    return kSigning;
	}

	static String hashSHA256(String data) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");  
		byte[] hash = md.digest(data.getBytes(StandardCharsets.UTF_8));
		BigInteger number = new BigInteger(1, hash);
		StringBuilder hexString = new StringBuilder(number.toString(16));
		return hexString.toString();
	}

	/*public static void main (String[] args) throws Exception {

		for(int i=0; i<10; i++) {

			String accessKey = "AKIAJUWCEFT47BE2VBEA";
			String secretKey = "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";

			String method = "GET";
			String service = "polly";
			String region = "eu-west-3"; // variable globale mRegion
			String host = service + '.' + region + ".amazonaws.com";
			String api = "/v1/voices";
			String endpoint = "https://" + host + api;

			TimeZone tz = TimeZone.getTimeZone("UTC");
			DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
			DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
			amzDateFormat.setTimeZone(tz);
			datestampFormat.setTimeZone(tz);
			String amz_date = amzDateFormat.format(new Date());
			String datestamp = datestampFormat.format(new Date());

			String canonicalUri = api;
			String canonicalHeaders = "host:" + host + '\n';
			String signedHeaders = "host";
			String algorithm = "AWS4-HMAC-SHA256";
			String credentialScope = datestamp + '/' + region + '/' + service + '/' + "aws4_request";
			String canonicalQuerystring = "X-Amz-Algorithm=AWS4-HMAC-SHA256";
			canonicalQuerystring += "&X-Amz-Credential=" + URLEncoder.encode(accessKey + '/' + credentialScope, StandardCharsets.UTF_8.toString());
			canonicalQuerystring += "&X-Amz-Date=" + amz_date;
			canonicalQuerystring += "&X-Amz-Expires=30"; // temps avant que la requete expire ???
			canonicalQuerystring += "&X-Amz-SignedHeaders=" + signedHeaders;

			String payloadHash = hashSHA256("");

			String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
					+ signedHeaders + '\n' + payloadHash;

			String stringToSign = algorithm + '\n' + amz_date + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);

			byte[] signingKey = getSignatureKey(secretKey, datestamp, region, service);

			byte[] hash = HmacSHA256(stringToSign, signingKey);
			BigInteger number = new BigInteger(1, hash);
			StringBuilder hexString = new StringBuilder(number.toString(16));
			String signature = hexString.toString();

			canonicalQuerystring += "&X-Amz-Signature=" + signature;

			String requestUrl = endpoint + "?" + canonicalQuerystring;

			URL url = new URL(requestUrl);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();

			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			StringBuilder response = new StringBuilder();
			String inputLine;
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine.trim());
			}
			br.close();

			Collection<Voice> result = new ArrayList<Voice>();

			Pattern p = Pattern .compile("\"Id\":\"\\p{L}+\"");
			Matcher m = p.matcher(response);
			String s = "";
			String name = "";

			while (m.find()) {
				s = response.substring(m.start(), m.end());
				name = s.substring(6,s.length()-1);
				result.add(new Voice("aws",name));
			}

			//for (Voice voice : result) {
			//	System.out.println("{enginge:" + voice.engine + ", name:" + voice.name + "}");
			//}

			System.out.println("Size : " + result.size());
		}

	}*/

	public static void main (String[] args) throws Exception {

		String accessKey = "AKIAJUWCEFT47BE2VBEA";
		String secretKey = "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";

		String method = "POST";
		String service = "polly";
		String region = "eu-west-3"; // variable globale mRegion
		String host = service + '.' + region + ".amazonaws.com";
		String api = "/v1/speech";
		String endpoint = "https://" + host + api;
		String contentType = "application/json";

		String requestParameters = "{";
		requestParameters += "\"OutputFormat\": \"mp3\",";
		//requestParameters += "\"Text\": \"<speak>He was caught up in the game.<break time=\'1s\'/> In the middle of the 10/3/2014 <sub alias=\'World Wide Web Consortium\'>W3C</sub> meeting, he shouted, \'Nice job!\' quite loudly. When his boss stared at him, he repeated <amazon:effect name=\'whispered\'>\'Nice job,\'</amazon:effect> in a whisper.</speak>\",";
		requestParameters += "\"Text\": \"<speak>Hello</speak>\",";
		requestParameters += "\"TextType\": \"ssml\",";
		requestParameters += "\"VoiceId\": \"Brian\"";
		requestParameters += "}";


		TimeZone tz = TimeZone.getTimeZone("UTC");
		DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
		DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
		amzDateFormat.setTimeZone(tz);
		datestampFormat.setTimeZone(tz);
		String amzDate = amzDateFormat.format(new Date());
		String datestamp = datestampFormat.format(new Date());

		String canonicalUri = api;
		String canonicalQuerystring = "";
		String canonicalHeaders = "content-type:" + contentType + '\n' + "host:" + host + '\n' + "x-amz-date:" + amzDate + '\n';
		String signedHeaders = "content-type;host;x-amz-date";
		String algorithm = "AWS4-HMAC-SHA256";
		String credentialScope = datestamp + '/' + region + '/' + service + '/' + "aws4_request";
		String payloadHash = hashSHA256(requestParameters);

		String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
				+ signedHeaders + '\n' + payloadHash;

		String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);

		byte[] signingKey = getSignatureKey(secretKey, datestamp, region, service);

		byte[] hash = HmacSHA256(stringToSign, signingKey);
		BigInteger number = new BigInteger(1, hash);
		StringBuilder hexString = new StringBuilder(number.toString(16));
		String signature = hexString.toString();

		String requestUrl = endpoint;

		String authorizationHeader = algorithm + ' ' + "Credential=" + accessKey + '/' + credentialScope + ", " + "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;

		URL url = new URL(requestUrl);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestProperty("Accept", "application/json");
		con.setRequestProperty("Content-Type", contentType);
		con.setRequestProperty("X-Amz-Date", amzDate);
		con.setRequestProperty("Authorization", authorizationHeader);
		con.setDoOutput(true);

		try(OutputStream os = con.getOutputStream()) {
			byte[] input = requestParameters.getBytes("utf-8");
			os.write(input, 0, input.length);           
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
		StringBuilder response = new StringBuilder();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
			response.append(inputLine.trim());
		}
		br.close();
		

	}

}