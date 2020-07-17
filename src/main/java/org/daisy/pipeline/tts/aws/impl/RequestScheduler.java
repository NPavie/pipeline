package org.daisy.pipeline.tts.aws.impl;

public interface RequestScheduler {

	/**
	 * 
	 * sleep the thread based on exponential backoff.
	 * 
	 */
	void sleep() throws InterruptedException;

}
