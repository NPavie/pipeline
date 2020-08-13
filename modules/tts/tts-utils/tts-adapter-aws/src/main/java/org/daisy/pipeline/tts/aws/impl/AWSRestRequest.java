package org.daisy.pipeline.tts.aws.impl;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class AWSRestRequest {
	
	private HttpURLConnection connection;
	private String contentType;
	private String amzDate;
	private String authorizationHeader;
	private URL requestUrl;
	private String requestParameters;
	private boolean doOutput;

	public InputStream send() throws IOException {

		connection = (HttpURLConnection) requestUrl.openConnection();
		connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("Content-Type", contentType);
		connection.setRequestProperty("X-Amz-Date", amzDate);
		connection.setRequestProperty("Authorization", authorizationHeader);
		connection.setDoOutput(doOutput);

		if (doOutput) {
			try(OutputStream os = connection.getOutputStream()) {
				byte[] input = requestParameters.getBytes("utf-8");
				os.write(input, 0, input.length);           
			}
		}

		return connection.getInputStream();
	}

	public HttpURLConnection getConnection() {
		return connection;
	}

	public void setConnection(HttpURLConnection connection) {
		this.connection = connection;
	}

	public String getContentType() {
		return contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getAmzDate() {
		return amzDate;
	}

	public void setAmzDate(String amzDate) {
		this.amzDate = amzDate;
	}

	public String getAuthorizationHeader() {
		return authorizationHeader;
	}

	public void setAuthorizationHeader(String authorizationHeader) {
		this.authorizationHeader = authorizationHeader;
	}

	public URL getRequestUrl() {
		return requestUrl;
	}

	public void setRequestUrl(URL requestUrl) {
		this.requestUrl = requestUrl;
	}

	public String getRequestParameters() {
		return requestParameters;
	}

	public void setRequestParameters(String requestParameters) {
		this.requestParameters = requestParameters;
	}

	public boolean isDoOutput() {
		return doOutput;
	}

	public void setDoOutput(boolean doOutput) {
		this.doOutput = doOutput;
	}

}
