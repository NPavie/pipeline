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

/**
 * Request Builder class for Amazon Polly
 * @author Louis Caille @ braillenet.org
 *
 */
public class AWSRequestBuilder {
	
	/**
	 * Possible actions to launch using requests
	 * 
	 * to create new actions, 
	 * please see <a href="https://docs.aws.amazon.com/polly/latest/dg/API_Operations.html">The actions list of Amazon Polly</a>
	 * for methods and domain that can be used.
	 * 
	 * @author  Louis Caille @ braillenet.org
	 *
	 */
	public enum Action {
		VOICES("GET","/v1/voices"),
		SPEECH("POST","/v1/speech");
		
		public String method;
		public String domain;

		/**
		 * @param method the HTTP method (usually GET or POST)
		 * @param domain the domain/endpoint of the requested action
		 */
		Action(String method, String domain) {
			this.method = method;
			this.domain = domain;
		}
	}
	/**
	 * User access key
	 */
	private String accessKey;
	
	/**
	 * User secret key 
	 */
	private String secretKey;
	
	/**
	 * Geographic region were the request should be executed
	 */
	private String region;
	
	/**
	 * Wanted format of audio data
	 */
	private String outputFormat;
	
	/**
	 * Sample rate for the encoding (usually 8000 or 16000 for PCM data returned by Amazon)
	 */
	private Integer sampleRate = null;
	
	/**
	 * Type of textual data sent (usually ssml)
	 */
	private String textType;
	
	/**
	 * Action requested
	 */
	private Action action;
	
	/**
	 * Parameters of the request
	 */
	private String requestParameters;
	
	/**
	 * Text to synthesize
	 */
	private String text;
	
	/**
	 * Voice name to use for synthesis
	 */
	private String voice;
	
	/**
	 * Type of marks to retrieve if defined in the speech
	 */
	private String speechMarksTypes;
	
	/**
	 * Create a new Request builder to generate AWS REST Request.
	 * A IAM account is required, with access key and secret key generated for the application.
	 * Check the <a href="https://docs.aws.amazon.com/polly/latest/dg/setting-up.html">setting up documentation</a> 
	 * and <a href="https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html">access keys documentation</a>
	 * for more information.
	 * 
	 * @param accessKey IAM account acces key
	 * @param secretKey IAM Account secret key
	 * @param region Geographic region of the amazon server (see <a href="https://docs.aws.amazon.com/general/latest/gr/pol.html">endpoints and quotas listing</a>)
	 * @param sampleRate sample rate (frequency) of the encoding, usually 8000 or 16000 for Amazon polly PCM output
	 * @param textType "ssml" or "text"
	 */
	public AWSRequestBuilder(String accessKey, String secretKey, String region, float sampleRate, String textType) {
		this.accessKey = accessKey;
		this.secretKey = secretKey;
		this.region = region;
		this.sampleRate = Integer.valueOf((int)sampleRate);
		this.textType = textType;
	}

	/**
	 * Set the action to launch
	 * @param action
	 * @return
	 */
	public AWSRequestBuilder withAction(Action action) {
		this.action = action;
		return this;
	}
	
	/**
	 * Set the voice to use
	 * @param voice
	 * @return
	 */
	public AWSRequestBuilder withVoice(String voice) {
		this.voice = voice;
		return this;
	}

	/**
	 * Set the text to synthesize
	 * @param text
	 * @return
	 */
	public AWSRequestBuilder withText(String text) {
		this.text = text;
		return this;
	}
	
	/**
	 * Set the audio format wanted
	 * @param outputFormat
	 * @return
	 */
	public AWSRequestBuilder withOutputFormat(String outputFormat) {
		this.outputFormat = outputFormat;
		return this;
	}
	
	/**
	 * Set the types of marks to retrieve data from (for ssml text)
	 * @param speechMarksTypes
	 * @return
	 */
	public AWSRequestBuilder withSpeechMarksTypes(List<String> speechMarksTypes) {
		this.speechMarksTypes = "[";
		for (int i=0; i<speechMarksTypes.size(); i++) {
			if (i != speechMarksTypes.size()-1) this.speechMarksTypes += '"' + speechMarksTypes.get(i) + '"' + ',';
			else this.speechMarksTypes +=  '"' + speechMarksTypes.get(i) + '"';
		}
		this.speechMarksTypes += ']';
		return this;
	}
	
	/**
	 * Prepare a new request with a new request builder from the current one.
	 * (acces key, secret key, region, sample rate and text type are preserved, while other values are reseted)
	 * @return
	 */
	public AWSRequestBuilder newRequest() {
		return new AWSRequestBuilder(accessKey, secretKey, region, sampleRate, textType);
	}
	
	/**
	 * Build the request from current builder settings
	 * @return the new request
	 * @throws Exception
	 */
	public AWSRestRequest build() throws Exception {
		
		AWSRestRequest restRequest = new AWSRestRequest();
		
		switch(action) {
		case VOICES:
			requestParameters = "";
			break;
		case SPEECH:
			// Mandatory values tests
			if(!(text != null && text.length() > 0)) {
				throw new Exception("No text provided for a speech request");
			}
			if(!(voice != null && voice.length() > 0)) {
				throw new Exception("No voice provided for a speech request (text : " + text + ")");
			}
			if(!(outputFormat != null && outputFormat.length() > 0)) {
				throw new Exception("No audio format provided for a speech request (text : " + text + ")");
			}
			
			requestParameters = "{";
			requestParameters += "\"OutputFormat\": " + '"' + outputFormat + '"' + ",";
			if(sampleRate != null) requestParameters += "\"SampleRate\": " + '"' + sampleRate +'"' + ",";
			requestParameters += "\"Text\": " + '"' + text + '"' + ",";
			if(speechMarksTypes != null && speechMarksTypes.length() > 0) requestParameters += "\"SpeechMarkTypes\": " + speechMarksTypes + ",";
			if(textType != null && textType.length() > 0) requestParameters += "\"TextType\": " + '"' + textType + '"' + ",";
			requestParameters += "\"VoiceId\": " + '"' + voice + '"';
			requestParameters += "}";
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
	
	// 
	/**
	 * Key derivation function, provided by Amazon
	 * @param data
	 * @param key
	 * @return
	 * @throws Exception
	 */
	private static byte[] HmacSHA256(String data, byte[] key) throws Exception {
		String algorithm="HmacSHA256";
		Mac mac = Mac.getInstance(algorithm);
		mac.init(new SecretKeySpec(key, algorithm));
		return mac.doFinal(data.getBytes("UTF-8"));
	}

	/**
	 * Signature key function, provided by Amazon
	 * @param key
	 * @param dateStamp
	 * @param regionName
	 * @param serviceName
	 * @return
	 * @throws Exception
	 */
	private static byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception {
		byte[] kSecret = ("AWS4" + key).getBytes("UTF-8");
		byte[] kDate = HmacSHA256(dateStamp, kSecret);
		byte[] kRegion = HmacSHA256(regionName, kDate);
		byte[] kService = HmacSHA256(serviceName, kRegion);
		byte[] kSigning = HmacSHA256("aws4_request", kService);
		return kSigning;
	}

	/**
	 * Sha 256 function that convert a string to a hexadecimal hash string of 256 bits
	 * @param data
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	private static String hashSHA256(String data) throws NoSuchAlgorithmException {
		MessageDigest md = MessageDigest.getInstance("SHA-256");  
		byte[] hash = md.digest(data.getBytes(StandardCharsets.UTF_8));
		return byteArrayToHex(hash);
	}

	/**
	 * Convert a byte array to a string of hexadecimal character
	 * @param a
	 * @return
	 */
	private static String byteArrayToHex(byte[] a) {
		StringBuilder sb = new StringBuilder(a.length * 2);
		for(byte b: a)
			sb.append(String.format("%02x", b));
		return sb.toString();
	}

}
