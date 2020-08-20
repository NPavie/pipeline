package org.daisy.pipeline.tts.scheduler;

public class FatalError extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public FatalError(String message) {
		super(message);
	}

	public FatalError(String message, Throwable cause) {
		super(message, cause);
	}
	
	public FatalError(Throwable cause) {
		super(cause);
	}
	
}
