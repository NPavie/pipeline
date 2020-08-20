package org.daisy.pipeline.tts.scheduler;

public class RecoverableError extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	public RecoverableError(String message) {
		super(message);
	}

	public RecoverableError(String message, Throwable cause) {
		super(message, cause);
	}
	
	public RecoverableError(Throwable cause) {
		super(cause);
	}

}
