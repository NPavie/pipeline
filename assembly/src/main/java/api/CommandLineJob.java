package api;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UncheckedIOException;
import java.net.URI;
import java.net.URLDecoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.daisy.common.messaging.Message;
import org.daisy.common.messaging.ProgressMessage;
import org.daisy.common.messaging.MessageAccessor;
import org.daisy.pipeline.job.Job;
import org.daisy.pipeline.job.JobMonitor;
import org.daisy.pipeline.job.JobResult;


/**
 * Job with a simplified API that stores results after completion.
 */
public class CommandLineJob implements Runnable, AutoCloseable {

    private final Job job;
    private final Map<String,URI> resultLocations;
    private final AtomicBoolean completed = new AtomicBoolean(false);

    public CommandLineJob(Job job, Map<String,URI> resultLocations) {
        this.job = job;
        this.resultLocations = resultLocations;
        // Simplify monitoring of messages
        MessageAccessor accessor = job.getMonitor().getMessageAccessor();
        accessor.listen(
            num -> {
                consumeMessage(accessor, num);
            }
        );
    }

    /**
     * Run the job and store the results
     */
    public void run() {
        job.run();
        try {
            Job.Status status = job.getStatus();
            switch (status) {
            case SUCCESS:
            case FAIL:
                List<File> existingFiles = new ArrayList<>();
                for (String port : job.getResults().getPorts()) {
                    if (resultLocations.containsKey(port)) {
                        URI u = resultLocations.get(port);
                        File f = new File(u);
                        if (u.toString().endsWith("/"))
                            for (JobResult r : job.getResults().getResults(port)) {
                                File dest = new File(f, URLDecoder.decode(r.strip().getPath().toString(), "utf-8"));
                                if (dest.exists())
                                    existingFiles.add(dest);
                                else
                                    writeResult(r, dest);
                            }
                        else
                            for (JobResult r : job.getResults().getResults(port))
                                if (f.exists())
                                    existingFiles.add(f);
                                else
                                    writeResult(r, f);
                    }
                }
                if(status == Job.Status.FAIL && resultLocations.containsKey("result")){
                    File logFile = new File(job.getLogFile());
                    File destFolder = new File(resultLocations.get("result"));
                    if(!destFolder.exists()){
                        destFolder.mkdirs();
                    }
                    File dest = new File(destFolder, "failed.log.txt");
                    java.nio.file.Files.move(logFile.toPath(), dest.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    movedLogFile = dest.getAbsolutePath();
                }
                if (!existingFiles.isEmpty())
                    throw new IOException("Some results could not be written: " + existingFiles);
                break;
            case ERROR:
                if(resultLocations.containsKey("result")){
                    File logFile = new File(job.getLogFile());
                    File destFolder = new File(resultLocations.get("result"));
                    if(!destFolder.exists()){
                        destFolder.mkdirs();
                    }
                    File dest = new File(destFolder, "error.log.txt");
                    java.nio.file.Files.move(logFile.toPath(), dest.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    movedLogFile = dest.getAbsolutePath();
                }
                break;
            default:
            }
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
        completed.set(true);
    }

    /**
     * Get the current status
     */
    public Job.Status getStatus() {
        Job.Status s = job.getStatus();
        switch (s) {
        case SUCCESS:
        case FAIL:
        case ERROR:
            return completed.get() ? s : Job.Status.RUNNING;
        case IDLE:
        case RUNNING:
        default:
            return s;
        }
    }

    private String movedLogFile = null;
    public String getLogFile() {
        if(movedLogFile != null) {
            return movedLogFile;
        }
        return new File(job.getLogFile()).getAbsolutePath();
    }



    private final HashMap<Integer, MessageQueueItem> messagesMap = new HashMap<>();
    
    private double jobStepProgress = 0;
    //private int jobStepTotal = 0;
    private boolean progressIsUpdated = false;
    // public synchronized void updateProgress(double progress) {
    // 	this.jobStepProgress = progress;
    // 	this.progressIsUpdated = true;
    // }

    public synchronized boolean isProgressUpdated() {
        double newProgress = job.getMonitor().getMessageAccessor().getProgress().doubleValue();
        if(newProgress != jobStepProgress) {
            this.jobStepProgress = newProgress;
            this.progressIsUpdated = true;
        }
        return progressIsUpdated;
    }


    public synchronized double getUpdatedProgress() {
        progressIsUpdated = false;
        return jobStepProgress;
    }

    // Note : fallback solution while i cannot get the deep progress.
    // - Added a progress message starting with "progress:" in the xsl i want to monitor
    // - When consuming messages, if a message starts with "progress:", parse the progress value materialized by regex \d+\\\d+.

    /**
     * Fill the message buffer queue for logging. The queue is returned and emptied on each
     * {@link #getNewMessages()} call.
     *
     * @param accessor the job's {@link MessageAccessor}
     * @param seqNum see {@link MessageAccessor#listen()}
     */
    private synchronized void consumeMessage(MessageAccessor accessor, int seqNum) {
        // Note : accessor getters seems to only retrieve top level messages
        // - Flattening the messages to get all progress messages and their portion/progress values,
        // - store them in a map with their sequence number as key to avoid duplicates and to keep track of already retrieved messages.
        List<MessageQueueItem> temp = new ArrayList<>();
        for (Message m : accessor.getAll()
        ) {
            temp.addAll(parseMessages(m));
        }
        for (MessageQueueItem mqi : temp) {
            if(!messagesMap.containsKey(mqi.message.getSequence()))
            {
                messagesMap.put(mqi.message.getSequence(), mqi);
            }
        }

    }

    public synchronized HashMap<Integer, MessageQueueItem> getMessagesMap() {
        return messagesMap;
    }

    private synchronized List<MessageQueueItem> parseMessages(Message m){
        return parseMessages(m, 0);
    }

    private synchronized List<MessageQueueItem> parseMessages(Message m, int level) {
        List<MessageQueueItem> result = new ArrayList<>();
        if (m instanceof ProgressMessage) {
            ProgressMessage jm = (ProgressMessage)m;
            result.add(new MessageQueueItem(jm, level));
            for (Message m2 : jm) {
                result.addAll(parseMessages(m2, level + 1));
            }
        } else {
            result.add(new MessageQueueItem(m, level));
        }
        
        return result;
    }

    /**
     * Get the list of new top-level messages (messages that have not been returned yet by a
     * previous call to {@link #getNewMessages()}).
     */
    public synchronized List<String> getNewMessages() {

        List<String> result = new ArrayList<>();
        for (MessageQueueItem mqi : messagesMap.values()) {
            if (!mqi.alreadyUsed()) {
                mqi.markAsUsed();
                result.add(mqi.toString(true));
            }
        }
        return result;
    }

    /**
     * Get the list of new top-level messages (messages that have not been returned yet by a
     * previous call to {@link #getNewMessagesQueueItem()}).
     */
    public synchronized List<MessageQueueItem> getNewMessagesQueueItem() {
        List<MessageQueueItem> result = new ArrayList<>();
        for (MessageQueueItem mqi : messagesMap.values()) {
            if (!mqi.alreadyUsed()) {
                mqi.markAsUsed();
                result.add(mqi);
            }
        }
        return result;
    }


    /**
     * Get the list of all error messages reported during the job execution.
     */
    public List<Message> getErrors() {
        return job.getMonitor().getMessageAccessor().getErrors();
    }

    /**
     * For advanced job monitoring, get the job's {@link JobMonitor}. From this object, you can
     * access all messages reported for the job through {@link JobMonitor#getMessageAccessor()},
     * or register your own status notifications callback through {@link
     * JobMonitor#getStatusUpdates()}.
     */
    public JobMonitor getMonitor() {
        return job.getMonitor();
    }

    public void close() {
        job.close();
    }

    private void writeResult(JobResult result, File dest) throws IOException {
        dest.getParentFile().mkdirs();
        try (InputStream is = result.read();
                OutputStream os = new FileOutputStream(dest)) {
            byte buff[] = new byte[1024];
            int read = 0;
            while ((read = is.read(buff)) > 0) {
                os.write(buff, 0, read);
            }
        }
    }
}
