package org.daisy.pipeline.tts.aws.impl;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * REST request to Amazon Polly / AWS
 * @author Louis Caille @ braillenet.org
 *
 */
public class AWSRestRequest {
	
	/**
	 * Connection objet to Amazon AWS server
	 */
	private HttpURLConnection connection;
	private String contentType;
	private String amzDate;
	private String authorizationHeader;
	private URL requestUrl;
	private String requestParameters;

	/**
	 * Send the request to the requested url and retrieve the server answer as an input stream.
	 * @return the input stream, through which data are send back by the server
	 * @throws IOException if an error occured during the connection or while sending data to the server
	 */
	public InputStream send() throws IOException {

		connection = (HttpURLConnection) requestUrl.openConnection();
		connection.setRequestProperty("Accept", "application/json");
		connection.setRequestProperty("Content-Type", contentType);
		connection.setRequestProperty("X-Amz-Date", amzDate);
		connection.setRequestProperty("Authorization", authorizationHeader);
		

		if (requestParameters != null && requestParameters.length() > 0) {
			connection.setDoOutput(true);
			try(OutputStream os = connection.getOutputStream()) {
				byte[] input = requestParameters.getBytes("utf-8");
				os.write(input, 0, input.length);           
			}
		}

		return connection.getInputStream();
	}

	/**
	 * @return the current connection to the server for the ongoing request, or null if no connection has been opened or tried yet (current request was not send)
	 */
	public HttpURLConnection getConnection() {
		return connection;
	}

	/**
	 * 
	 * @return the "Content-Type" header value
	 */
	public String getContentType() {
		return contentType;
	}

	/**
	 * set the "Content-Type" header (usually "application/json")
	 * @param contentType
	 */
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	/**
	 * 
	 * @return the formatted timestamp of the request (used for the header X-Amz-Date)
	 */
	public String getAmzDate() {
		return amzDate;
	}

	/**
	 * Set the request "X-Amz-Date" header (formatted timestamp of the request).
	 * It must be in the format "yyyyMMdd'T'HHmmss'Z'" 
	 * @param amzDate
	 */
	public void setAmzDate(String amzDate) {
		// TODO : add a format check
		this.amzDate = amzDate;
	}

	/**
	 * @return the request "Authorization" header value
	 */
	public String getAuthorizationHeader() {
		return authorizationHeader;
	}

	/**
	 * Set the request "Authorization" header value 
	 * @param authorizationHeader
	 */
	public void setAuthorizationHeader(String authorizationHeader) {
		this.authorizationHeader = authorizationHeader;
	}

	/**
	 * @return the url used for the request
	 */
	public URL getRequestUrl() {
		return requestUrl;
	}

	/**
	 * Set the request url.
	 * If a previous connection was opened for the current request, close and destroy it. 
	 * @param requestUrl
	 */
	public void setRequestUrl(URL requestUrl) {
		this.requestUrl = requestUrl;
	}

	/**
	 * @return the current request parameters JSON string (to be send through a connection outputstream)
	 */
	public String getRequestParameters() {
		return requestParameters;
	}

	/**
	 * Change the request parameters (to be send through the connection output stream) with a new JSON string.
	 * @param requestParameters JSON string that holds new parameters. 
	 */
	public void setRequestParameters(String requestParameters) {
		this.requestParameters = requestParameters;
	}

	
	/**
	 * Cancel the request, disconnecting it from the server
	 */
	public void cancel() {
		if(this.connection != null) {
			this.connection.disconnect();
			this.connection = null;
		}
	}

}
