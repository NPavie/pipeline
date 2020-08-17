package org.daisy.pipeline.tts.aws.impl;

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
public enum AWSRestAction {
	
	VOICES("GET","/v1/voices"),
	SPEECH("POST","/v1/speech");
	
	public String method;
	public String domain;

	/**
	 * @param method the HTTP method (usually GET or POST)
	 * @param domain the domain/endpoint of the requested action
	 */
	AWSRestAction(String method, String domain) {
		this.method = method;
		this.domain = domain;
	}
	
}
