package api;

import org.daisy.common.messaging.Message;
import org.daisy.common.messaging.ProgressMessage;

/**
 * MessageQueueItem represents an item in the message queue.
 * It wraps a Message object and keeps track of its used (printed or displayed in UI) status and its depth in the message hierarchy.
 */
public class MessageQueueItem {
    public final Message message;
	private boolean isUsed = false;
	private int level = 0;

	public MessageQueueItem(Message message, int level) {
		this.message = message;
		this.level = level;
	}

	public int getLevel() {
		return level;
	}

	public boolean alreadyUsed() {
		return isUsed;
	}

	public void markAsUsed() {
		this.isUsed = true;
	}

	public synchronized String toString(boolean withIndent) {
		String indent = "";
		if(withIndent) {
			indent = " > ";
			for (int i = 0; i < level; i++) {
				indent += "|   ";
			}
		}
		if(message instanceof ProgressMessage) {
			ProgressMessage jm = (ProgressMessage)message;
			
			//return dateFormat.format(message.getTimeStamp()) +  indent + jm.getText();
			return indent + jm.getText();
		} else {
			//return dateFormat.format(message.getTimeStamp()) +  indent + message.getText();
			return indent + message.getText();
		}
	}
}
