package org.daisy.pipeline.tts.aws.impl;

import java.util.UUID;

public interface RequestScheduler<RequestType> {

	/**
	 * Sleep the thread based on exponential backoff.
	 */
	void sleep() throws InterruptedException;
	
	/**
	 * Add a new request to the scheduler queue
	 * @param request request to handle
	 * @return an unique id to poll and/or delay the request from the scheduler
	 */
	public UUID add(RequestType request);
	
	/**
	 * Ask the scheduler to delay the request associated with the requestId
	 * when the request is polled.
	 * @param requestId id of the request in the scheduler (as returned by the method add)
	 */
	public void delay(UUID requestUuid);
	
	/**
	 * Retrieve a request and remove it from the scheduler.
	 * This function should wait if a delay has been set for the request.
	 * @param requestId id of the request in the scheduler (as returned by the method add) 
	 * @return
	 */
	public RequestType poll(UUID requestUuid);

}
