package org.daisy.pipeline.tts.aws.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
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
import org.daisy.pipeline.tts.SoundUtil;
import org.daisy.pipeline.tts.TTSEngine;
import org.daisy.pipeline.tts.TTSRegistry.TTSResource;
import org.daisy.pipeline.tts.TTSService.Mark;
import org.daisy.pipeline.tts.TTSService.SynthesisException;
import org.daisy.pipeline.tts.Voice;

public class AWSRestTTSEngine extends TTSEngine {

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
	public Collection<AudioBuffer> synthesize(String sentence, XdmNode xmlSentence, Voice voice,
			TTSResource threadResources, List<Mark> marks, List<String> expectedMarks,
			AudioBufferAllocator bufferAllocator, boolean retry)
					throws SynthesisException, InterruptedException, MemoryException {

		if (sentence.length() > 6000 || nbCharCharged(sentence) > 3000) {
			throw new SynthesisException("The number of characters in the sentence must not exceed 3000. The tags are not taken into account");
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
			// by default the voice is set to en-US
			name = '"' + "Joey" + '"';
		}
		
		try {
			for (Mark mark : getMarksData(adaptedSentence, name)) {
				marks.add(mark);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		

		HttpURLConnection con = null;

		boolean isNotDone = true;

		// we loop until the request has not been processed 
		// (aws limits to 80 requests per minute for standard voice and 8 for neural voice or 15000 characters)
		while(isNotDone) {

			try {

				String requestParameters = "{";
				requestParameters += "\"OutputFormat\": \"pcm\",";
				requestParameters += "\"Text\": " + adaptedSentence +",";
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
		// (aws limits to 80 requests per minute or 15000 characters)
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
	
	@Override
	public int expectedMillisecPerWord() {
		return 64000;
	}
	
	@Override
	public String endingMark() {
		return "ending-mark";
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
		String signature = byteArrayToHex(hash);

		// ************* TASK 4: ADD SIGNING INFORMATION TO THE REQUEST *************

		String authorizationHeader = algorithm + ' ' + "Credential=" + mAccessKey + '/' + credentialScope + ", " 
				+ "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;
		requestData.put("authorizationHeader", authorizationHeader);

		// ************* SEND THE REQUEST *************

		String requestUrl = endpoint + "?" + canonicalQuerystring;	
		requestData.put("requestUrl", requestUrl);

		return requestData;
	}

	private List<Mark> getMarksData(String adaptedSentence, String voiceName) throws Exception {
		
		List<Mark> marks = new ArrayList<>();

		String requestParameters = "{";
		requestParameters += "\"OutputFormat\": \"json\",";
		requestParameters += "\"SpeechMarkTypes\": [ \"ssml\" ],";
		requestParameters += "\"Text\":" + adaptedSentence + ",";
		requestParameters += "\"TextType\": \"ssml\",";
		requestParameters += "\"VoiceId\":" + voiceName;
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
		
		Pattern pSingleMark = Pattern .compile("\\{[^\\}]*\\}");
		Matcher mSingleMark = pSingleMark.matcher(response);
		
		Pattern pTime = Pattern.compile("\"time\":[0-9]*");
		Pattern pValue = Pattern.compile("\"value\":[^\\}]*");

		while (mSingleMark.find()) {
			String singleMark = response.substring(mSingleMark.start(), mSingleMark.end());

			Matcher mTime = pTime.matcher(singleMark);
			mTime.find();
			// + 7 to start after "time":
			int time = Integer.parseInt(singleMark.substring(mTime.start() + 7, mTime.end()));
			// TODO
			int offset = time * 16000 * 2 + 44;

			Matcher mValue = pValue.matcher(singleMark);
			mValue.find();
			// + 9 to start after "value":" & - 1 to stop before "
			String value = singleMark.substring(mValue.start() + 9, mValue.end() - 1);
			
			marks.add(new Mark(value, offset));	
		}

		return marks;
	}

	// calculation of the number of characters charged by aws
	private static int nbCharCharged(String sentence) {
		int n = 0;
		int i = 0;
		boolean inTag = false;
		while (i<sentence.length()) {
			// start of a tag
			if (sentence.charAt(i) == '<') {
				inTag = true;
				i++;
			}
			// end of a tag
			else if (sentence.charAt(i) == '>') {
				inTag = false;
				i++;
			}
			// in a tag
			else if (inTag) {
				i++;
			}
			// characters charged
			else {
				n++;
				i++;
			}
		}
		return n;
	}

	// key derivation functions
	private static byte[] HmacSHA256(String data, byte[] key) throws Exception {
		String algorithm="HmacSHA256";
		Mac mac = Mac.getInstance(algorithm);
		mac.init(new SecretKeySpec(key, algorithm));
		return mac.doFinal(data.getBytes("UTF-8"));
	}

	private static byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception {
		byte[] kSecret = ("AWS4" + key).getBytes("UTF-8");
		byte[] kDate = HmacSHA256(dateStamp, kSecret);
		byte[] kRegion = HmacSHA256(regionName, kDate);
		byte[] kService = HmacSHA256(serviceName, kRegion);
		byte[] kSigning = HmacSHA256("aws4_request", kService);
		return kSigning;
	}

	private static String hashSHA256(String data) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");  
		byte[] hash = md.digest(data.getBytes(StandardCharsets.UTF_8));
		return byteArrayToHex(hash);
	}

	private static String byteArrayToHex(byte[] a) {
		StringBuilder sb = new StringBuilder(a.length * 2);
		for(byte b: a)
			sb.append(String.format("%02x", b));
		return sb.toString();
	}

}