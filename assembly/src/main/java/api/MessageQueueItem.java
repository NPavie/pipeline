package api;

import org.daisy.common.messaging.Message;
import org.daisy.common.messaging.ProgressMessage;

public class MessageQueueItem {
    public final Message message;
			public boolean isPrinted = false;
			private int level = 0;

			public MessageQueueItem(Message message, int level) {
				this.message = message;
				this.level = level;
			}
			public synchronized String print() {
				String indent = " > ";
				for (int i = 0; i < level; i++) {
					indent += "|   ";
				}
				//System.out.println(dateFormat.format(message.getTimeStamp()) +  indent + message.getText());
				this.isPrinted = true;
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
