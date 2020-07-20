package org.daisy.pipeline.tts.aws.impl;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.nio.file.StandardCopyOption;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.TimeZone;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import javax.sound.sampled.AudioFormat;

import net.sf.saxon.s9api.XdmNode;

import org.apache.commons.io.IOUtils;
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
				
				String requestParameters = "{";
				requestParameters += "\"OutputFormat\": \"pcm\",";
				requestParameters += "\"Text\":" + adaptedSentence + ",";
				requestParameters += "\"TextType\": \"ssml\",";
				requestParameters += "\"VoiceId\":" + name;
				requestParameters += "}";
				
				Map<String, String> requestData = createRequest("POST", "/v1/speech", requestParameters);
				
				URL url = new URL(requestData.get("requestUrl"));
				con = (HttpURLConnection) url.openConnection();
				con.setRequestProperty("Accept", "application/json");
				con.setRequestProperty("Content-Type", requestData.get("contentType"));
				con.setRequestProperty("X-Amz-Date", requestData.get("amzDate"));
				con.setRequestProperty("Authorization", requestData.get("authorizationHeader"));
				con.setDoOutput(true);
				
				try(OutputStream os = con.getOutputStream()) {
					byte[] input = requestParameters.getBytes("utf-8");
					os.write(input, 0, input.length);           
				}
				
				byte[] bytes = IOUtils.toByteArray(con.getInputStream());
				
				AudioBuffer b = bufferAllocator.allocateBuffer(bytes.length);
				b.data = bytes;
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
				
				Map<String, String> requestData = createRequest("GET", "/v1/voices", "");

				URL url = new URL(requestData.get("requestUrl"));
				con = (HttpURLConnection) url.openConnection();
				con.setRequestProperty("Content-Type", requestData.get("contentType"));
				con.setRequestProperty("X-Amz-Date", requestData.get("amzDate"));
				con.setRequestProperty("Authorization", requestData.get("authorizationHeader"));

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
	
	private Map<String, String> createRequest(String method, String api, String requestParameters) throws Exception {
		
		Map<String, String> requestData = new HashMap<>();
		
		// request values
		String service = "polly";
		String host = service + '.' + mRegion + ".amazonaws.com";
		String endpoint = "https://" + host + api;
		String contentType = "application/json";
		requestData.put("contentType", contentType);
		
		// create a date for headers and the credential string
		TimeZone tz = TimeZone.getTimeZone("UTC");
		DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
		DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
		amzDateFormat.setTimeZone(tz);
		datestampFormat.setTimeZone(tz);
		String amzDate = amzDateFormat.format(new Date());
		String datestamp = datestampFormat.format(new Date());
		requestData.put("amzDate",amzDate);
		
		// ************* TASK 1: CREATE A CANONICAL REQUEST *************
		// http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
		
		// create canonical URI--the part of the URI from domain to query
		String canonicalUri = api;
		
		// create the canonical query string
		String canonicalQuerystring = "";
		
		// create the canonical headers and signed headers
		String canonicalHeaders = "content-type:" + contentType + '\n' + "host:" + host + '\n' + "x-amz-date:" + amzDate + '\n';
		
		// create the list of signed headers
		String signedHeaders = "content-type;host;x-amz-date";
		
		// create payload hash 
		String payloadHash = hashSHA256(requestParameters);
		
		// combine elements to create create canonical request
		String canonicalRequest = method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
				+ signedHeaders + '\n' + payloadHash;
		
		// ************* TASK 2: CREATE THE STRING TO SIGN*************
		
		// match the algorithm to the hashing algorithm SHA-256
		String algorithm = "AWS4-HMAC-SHA256";
		String credentialScope = datestamp + '/' + mRegion + '/' + service + '/' + "aws4_request";	
		String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);
		
		// ************* TASK 3: CALCULATE THE SIGNATURE *************
		
		// create the signing key
		byte[] signingKey = getSignatureKey(mSecretKey, datestamp, mRegion, service);
		
		
		// sign the stringToSign using the signing_key
	    byte[] hash = HmacSHA256(stringToSign, signingKey);
	    BigInteger number = new BigInteger(1, hash);
		StringBuilder hexString = new StringBuilder(number.toString(16));
		String signature = hexString.toString();
		
		// ************* TASK 4: ADD SIGNING INFORMATION TO THE REQUEST *************
		
		String authorizationHeader = algorithm + ' ' + "Credential=" + mAccessKey + '/' + credentialScope + ", " 
		+ "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;
		requestData.put("authorizationHeader", authorizationHeader);
		
		// ************* SEND THE REQUEST *************
		
		String requestUrl = endpoint + "?" + canonicalQuerystring;	
		requestData.put("requestUrl", requestUrl);
		
		return requestData;
	}

	private String getMarksData(String sentence, Voice voice) throws Exception {

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

		String requestParameters = "{";
		requestParameters += "\"OutputFormat\": \"json\",";
		requestParameters += "\"SpeechMarkTypes\": [ \"ssml\" ],";
		requestParameters += "\"Text\":" + adaptedSentence + ",";
		requestParameters += "\"TextType\": \"ssml\",";
		requestParameters += "\"VoiceId\":" + name;
		requestParameters += "}";


		Map<String, String> requestData = createRequest("POST", "/v1/speech", requestParameters);
		
		URL url = new URL(requestData.get("requestUrl"));
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestProperty("Accept", "application/json");
		con.setRequestProperty("Content-Type", requestData.get("contentType"));
		con.setRequestProperty("X-Amz-Date", requestData.get("amzDate"));
		con.setRequestProperty("Authorization", requestData.get("authorizationHeader"));
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
		requestParameters += "\"Text\": \"<speak>Hello, how are you ?</speak>\",";
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

		InputStream initialStream = con.getInputStream();
		File targetFile = new File("targetFile.mp3");

		java.nio.file.Files.copy(
				initialStream, 
				targetFile.toPath(), 
				StandardCopyOption.REPLACE_EXISTING);

		IOUtils.closeQuietly(initialStream);


	}

}