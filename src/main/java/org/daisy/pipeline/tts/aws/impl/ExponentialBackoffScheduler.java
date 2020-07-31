package org.daisy.pipeline.tts.aws.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class ExponentialBackoffScheduler implements RequestScheduler<AWSRestRequest> {
	
	private long waitingTime;
	private long random_number_milliseconds;
	private int n = 0;
	
	private Map<UUID, AWSRestRequest> requests = new HashMap<>();
	
	// maximum waiting time in millisecond
	private static final int MAXIMUM_BACKOFF = 64000;
	
	// https://cloud.google.com/storage/docs/exponential-backoff
	// https://docs.aws.amazon.com/general/latest/gr/api-retries.html
	public synchronized void sleep() throws InterruptedException {
		random_number_milliseconds = (long) (Math.random() * 1000);
		waitingTime = (long) Math.min(Math.pow(2, n) * 100L + random_number_milliseconds, MAXIMUM_BACKOFF);
		Thread.sleep(waitingTime);
		n++;
	}

	@Override
	public synchronized UUID add(AWSRestRequest request) {
		UUID requestUuid = UUID.randomUUID();
		while (requests.containsKey(requestUuid)) {
			requestUuid = UUID.randomUUID();
		}
		requests.put(requestUuid, request);
		return requestUuid;
	}

	@Override
	public synchronized void delay(UUID requestUuid) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public synchronized AWSRestRequest poll(UUID requestUuid) {
		// TODO Auto-generated method stub
		delay(requestUuid);
		return requests.remove(requestUuid);
	}

}
