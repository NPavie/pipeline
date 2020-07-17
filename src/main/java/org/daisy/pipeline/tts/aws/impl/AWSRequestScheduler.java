package org.daisy.pipeline.tts.aws.impl;

public class AWSRequestScheduler implements RequestScheduler {
	
	private long waitingTime;
	private long random_number_milliseconds;
	private int n = 0;
	
	// maximum waiting time in millisecond
	private static final int MAXIMUM_BACKOFF = 64000;
	
	// https://cloud.google.com/storage/docs/exponential-backoff
	public synchronized void sleep() throws InterruptedException {
		random_number_milliseconds = (long) (Math.random() * 1000);
		waitingTime = (long) Math.min(Math.pow(2, n) * 100L + random_number_milliseconds, MAXIMUM_BACKOFF);
		Thread.sleep(waitingTime);
		n++;
	}

}
