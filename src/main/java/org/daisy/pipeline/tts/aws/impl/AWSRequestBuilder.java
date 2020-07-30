package org.daisy.pipeline.tts.aws.impl;

import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class AWSRequestBuilder {
	
	public enum Action {
		VOICES("GET","/v1/voices"),
		SPEECH("POST","/v1/speech");
		
		public String method;
		public String domain;

		Action(String method, String domain) {
			this.method = method;
			this.domain = domain;
		}
	}
	
	private String accessKey;
	private String secretKey;
	private String region;
	private String outputFormat;
	private int sampleRate;
	private String textType;
	private Action action;
	private String requestParameters;
	private String text;
	private String voice;
	private String speechMarksTypes;
	
	public AWSRequestBuilder(String accessKey, String secretKey, 
			String region, float sampleRate, String textType) {
		this.accessKey = accessKey;
		this.secretKey = secretKey;
		this.region = region;
		this.sampleRate = (int) sampleRate;
		this.textType = textType;
	}

	public AWSRequestBuilder withAction(Action action) {
		this.action = action;
		return this;
	}
	
	public AWSRequestBuilder withVoice(String voice) {
		this.voice = voice;
		return this;
	}

	public AWSRequestBuilder withText(String text) {
		this.text = text;
		return this;
	}
	
	public AWSRequestBuilder withOutputFormat(String outputFormat) {
		this.outputFormat = outputFormat;
		return this;
	}
	
	public AWSRequestBuilder withSpeechMarksTypes(List<String> speechMarksTypes) {
		this.speechMarksTypes = "[";
		for (int i=0; i<speechMarksTypes.size(); i++) {
			if (i != speechMarksTypes.size()-1) this.speechMarksTypes += '"' + speechMarksTypes.get(i) + '"' + ',';
			else this.speechMarksTypes +=  '"' + speechMarksTypes.get(i) + '"';
		}
		this.speechMarksTypes += ']';
		return this;
	}
	
	public AWSRequestBuilder newRequest() {
		return new AWSRequestBuilder(accessKey, secretKey, region, sampleRate, textType);
	}
	
	public AWSRestRequest build() throws Exception {
		
		AWSRestRequest restRequest = new AWSRestRequest();
		
		switch(action) {
		case VOICES:
			requestParameters = "";
			restRequest.setDoOutput(false);
			break;
		case SPEECH:
			requestParameters = "{";
			requestParameters += "\"OutputFormat\": " + '"' + outputFormat + '"' + ",";
			requestParameters += "\"SampleRate\": " + '"' + sampleRate +'"' + ",";
			requestParameters += "\"Text\": " + text + ",";
			requestParameters += "\"SpeechMarkTypes\": " + speechMarksTypes + ",";
			requestParameters += "\"TextType\": " + '"' + textType + '"' + ",";
			requestParameters += "\"VoiceId\": " + '"' + voice + '"';
			requestParameters += "}";
			restRequest.setDoOutput(true);
			break;
		}
		restRequest.setRequestParameters(requestParameters);

		// request values
		String service = "polly";
		String host = service + '.' + region + ".amazonaws.com";
		String endpoint = "https://" + host + action.domain;
		String contentType = "application/json";
		restRequest.setContentType(contentType);

		// create a date for headers and the credential string
		TimeZone tz = TimeZone.getTimeZone("UTC");
		DateFormat amzDateFormat = new SimpleDateFormat("yyyyMMdd'T'HHmmss'Z'");
		DateFormat datestampFormat = new SimpleDateFormat("yyyyMMdd");
		amzDateFormat.setTimeZone(tz);
		datestampFormat.setTimeZone(tz);
		String amzDate = amzDateFormat.format(new Date());
		String datestamp = datestampFormat.format(new Date());
		restRequest.setAmzDate(amzDate);

		// ************* TASK 1: CREATE A CANONICAL REQUEST *************
		// http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html

		// create canonical URI--the part of the URI from domain to query
		String canonicalUri = action.domain;

		// create the canonical query string
		String canonicalQuerystring = "";

		// create the canonical headers and signed headers
		String canonicalHeaders = "content-type:" + contentType + '\n' + "host:" + host + '\n' + "x-amz-date:" + amzDate + '\n';

		// create the list of signed headers
		String signedHeaders = "content-type;host;x-amz-date";

		// create payload hash 
		String payloadHash = hashSHA256(requestParameters);

		// combine elements to create create canonical request
		String canonicalRequest = action.method + '\n' + canonicalUri + '\n' + canonicalQuerystring + '\n' + canonicalHeaders + '\n' 
				+ signedHeaders + '\n' + payloadHash;

		// ************* TASK 2: CREATE THE STRING TO SIGN*************

		// match the algorithm to the hashing algorithm SHA-256
		String algorithm = "AWS4-HMAC-SHA256";
		String credentialScope = datestamp + '/' + region + '/' + service + '/' + "aws4_request";	
		String stringToSign = algorithm + '\n' + amzDate + '\n' + credentialScope + '\n' + hashSHA256(canonicalRequest);

		// ************* TASK 3: CALCULATE THE SIGNATURE *************

		// create the signing key
		byte[] signingKey = getSignatureKey(secretKey, datestamp, region, service);


		// sign the stringToSign using the signing_key
		byte[] hash = HmacSHA256(stringToSign, signingKey);
		String signature = byteArrayToHex(hash);

		// ************* TASK 4: ADD SIGNING INFORMATION TO THE REQUEST *************

		String authorizationHeader = algorithm + ' ' + "Credential=" + accessKey + '/' + credentialScope + ", " 
				+ "SignedHeaders=" + signedHeaders + ", " + "Signature=" + signature;
		restRequest.setAuthorizationHeader(authorizationHeader);

		// ************* SEND THE REQUEST *************

		String requestUrl = endpoint + "?" + canonicalQuerystring;	
		restRequest.setRequestUrl(new URL(requestUrl));

		return restRequest;
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
