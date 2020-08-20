package org.daisy.pipeline.tts.scheduler;

/**
 * Schedulable action interface, used by Scheduler implementation
 * A schedulable action must be rescheduled if a RecoverableError is raised
 *
 */
public interface Schedulable {
	/**
	 * Execute the action
	 * @throws RecoverableError if the error is recoverable, so that the action can be rescheduled
	 * @throws FatalError if the action cannot be rescheduled
	 */
	public void launch() throws RecoverableError, FatalError;
}
