import javax.swing.*;

import api.SimpleAPI;
import api.CommandLineJob;

import java.awt.*;
import java.awt.event.*;
import java.io.FileNotFoundException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;



// TODO Plan on improving this micro app
// - Add a dynamic window for conversion parameters form
//   - If no document is provided, add a file chooser to select a document
//   - if no script is provided, add a dropdown to select a script
//   - When a script is selected, dynamically generate the form for the script parameters
// - Move the


/**
 * Simple Swing UI with progress bar, message display, scrollable text area, and cancel button.
 * Executes an asynchronous task that can be cancelled. After task completion, the window
 * remains open for 5 seconds before closing and terminating the application.
 */
public class SimpleUI {

    private JFrame frame;
    private JProgressBar progressBar;
    private JLabel progressLabel;
    private JTextArea logTextArea;
    private JButton cancelButton;
    private AtomicBoolean cancelled = new AtomicBoolean(false);
    private SwingWorker<Void, String> worker;
    private int exitCode = 0;

    public SimpleUI(String script) {
        initializeUI(script);
    }

    private void initializeUI(String script) {
        
        // Create the main frame
        frame = new JFrame("Running " + script);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(600, 400);
        frame.setLocationRelativeTo(null); // Center on screen

        // Create components
        progressBar = new JProgressBar(0, 100);
        progressBar.setValue(0);
        progressBar.setStringPainted(true);

        progressLabel = new JLabel("Initializing...", SwingConstants.CENTER);

        logTextArea = new JTextArea();
        
        logTextArea.setEditable(false);
        logTextArea.setLineWrap(true);
        logTextArea.setWrapStyleWord(true);
        JScrollPane scrollPane = new JScrollPane(logTextArea);

        cancelButton = new JButton("Annuler");
        cancelButton.addActionListener(e -> cancelTask());

        // Layout
        JPanel topPanel = new JPanel(new BorderLayout(10, 10));
        topPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        topPanel.add(progressLabel, BorderLayout.NORTH);
        topPanel.add(progressBar, BorderLayout.CENTER);

        JPanel bottomPanel = new JPanel(new BorderLayout());
        bottomPanel.add(scrollPane, BorderLayout.CENTER);
        
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        buttonPanel.add(cancelButton);
        bottomPanel.add(buttonPanel, BorderLayout.SOUTH);

        frame.setLayout(new BorderLayout());
        frame.add(topPanel, BorderLayout.NORTH);
        frame.add(bottomPanel, BorderLayout.CENTER);

        // Make the frame visible
        frame.setVisible(true);
    }

    private void cancelTask() {
        if (worker != null && !worker.isDone()) {
            cancelled.set(true);
            worker.cancel(true);
            logMessage("Task cancelled by user");
            cancelButton.setEnabled(false);
            exitCode = 1;
        }
    }

    private void logMessage(String message) {
        SwingUtilities.invokeLater(() -> {
            logTextArea.append(message + "\n");
            // Auto-scroll to the bottom
            logTextArea.setCaretPosition(logTextArea.getDocument().getLength());
        });
    }

    private void updateProgress(int value, String message) {
        SwingUtilities.invokeLater(() -> {
            progressBar.setValue(value);
            progressLabel.setText(message);
        });
    }

    private void startAsyncTask(String script, Map<String, List<String>> options) {
        worker = new SwingWorker<Void, String>() {
            @Override
            protected Void doInBackground() throws Exception {
                // Redirect stdout and stderr to logMessage
                System.setOut(new java.io.PrintStream(new java.io.OutputStream() {
                    private StringBuilder sb = new StringBuilder();
                    @Override
                    public void write(int b) {
                        sb.append((char) b);
                        if ((char) b == '\n') {
                            logMessage(sb.toString().trim());
                            sb = new StringBuilder();
                        }
                    }
                }));
                System.setErr(new java.io.PrintStream(new java.io.OutputStream() {
                    private StringBuilder sb = new StringBuilder();
                    @Override
                    public void write(int b) {
                        sb.append((char) b);
                        if ((char) b == '\n') {
                            logMessage("[ERROR] " + sb.toString().trim());
                            sb = new StringBuilder();
                        }
                    }
                }));
                
                logMessage("Starting conversion ... ");
                CommandLineJob job = null;
                try {
                    job = SimpleAPI.getInstance().startJob(script, options);
                } catch (IllegalArgumentException e) {
                    System.err.println(e.getMessage());
                    System.exit(1);
                } catch (FileNotFoundException|URISyntaxException e) {
                    System.err.println("File does not exist: " + e.getMessage());
                    System.exit(1);
                }
                boolean finished = false;
                while (!finished && !cancelled.get()) {
                    String lastMessage = "";
                    for (String m : job.getNewMessages()) {
                        logMessage(m);
                        lastMessage = m;
                    }
                    if(job.isProgressUpdated()) {
                        int i = (int) (job.getUpdatedProgress() * 100);
                        String cleanedMessage = lastMessage.replaceAll("^[^a-zA-Z0-9]+", "");
                        updateProgress(i, cleanedMessage + " (" + i + " %)");
                    }
                    switch (job.getStatus()) {
                    case SUCCESS:
                        logMessage("Job finished with status: " + job.getStatus());
                        finished = true;
                        break;
                    case FAIL:
                    case ERROR:
                        logMessage("Job finished with status: " + job.getStatus());
                        finished = true;
                        throw new RuntimeException("Job failed with status: " + job.getStatus());
                    case IDLE:
                    case RUNNING:
                    default:
                        Thread.sleep(1000);
                    }
                }
                
                if (cancelled.get()) {
                    logMessage("Task was cancelled");
                    return null;
                }
                
                logMessage("Task completed successfully!");
                updateProgress(100, "Done!");
                return null;
            }

            @Override
            protected void process(java.util.List<String> chunks) {
                for (String message : chunks) {
                    logMessage(message);
                }
            }

            @Override
            protected void done() {
                cancelButton.setEnabled(false);
                
                // Determine exit code based on task result
                if (cancelled.get()) {
                    exitCode = 2; // Task was cancelled by user
                } else if (isCancelled()) {
                    exitCode = 2; // Task was cancelled
                } else {
                    try {
                        get(); // Check if there was an exception
                        exitCode = 0; // Success
                    } catch (Exception e) {
                        exitCode = 1; // Error occurred
                        logMessage("Task failed: " + e.getMessage());
                    }
                }
                
                // Schedule window to close after 3 seconds with appropriate exit code
                Timer timer = new Timer(3000, e -> {
                    frame.dispose();
                    System.exit(exitCode);
                });
                timer.setRepeats(false);
                timer.start();
            }
        };
        
        worker.execute();
    }

    /**
     * Main method to launch the SimpleUI application.
     */
    public static void main(String[] args) {
        
        // Disable logging of Java and sun AWT components
        java.util.logging.Logger.getLogger("java.awt").setLevel(java.util.logging.Level.OFF);
        java.util.logging.Logger.getLogger("javax.swing").setLevel(java.util.logging.Level.OFF);
        java.util.logging.Logger.getLogger("sun.awt").setLevel(java.util.logging.Level.OFF);
        if (args.length < 1) {
			System.err.println("Expected script argument");
			System.exit(1);
		}
        String script = args[0];
        Map<String,List<String>> options = new HashMap<>();
		for (int i = 1; i < args.length; i += 2) {
			if (!args[i].startsWith("--")) {
				System.err.println("Expected option name argument, got " + args[i]);
				System.exit(1);
			}
			String option = args[i].substring(2);
			if (i + 1 >= args.length) {
				System.err.println("Expected option value argument");
				System.exit(1);
			}
			List<String> list = options.get(option);
			if (list == null) {
				list = new ArrayList<>();
				options.put(option, list);
			}
			list.add(args[i + 1]);
		}
        // Set look and feel to system default
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Create and show the UI on the Event Dispatch Thread
        SwingUtilities.invokeLater(() -> {
            SimpleUI ui = new SimpleUI(script);
            ui.startAsyncTask(script, options);
        });
    }
}
