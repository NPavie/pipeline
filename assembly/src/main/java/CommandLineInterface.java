import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.daisy.pipeline.job.Job;

import java.util.List;

import api.CommandLineJob;
import api.SimpleAPI;

public class CommandLineInterface {
    private static final DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX");

	/**
	 * Additional commands that can be run from the command line interface, in addition to running scripts
	 */
	public enum Command
    {
        Descriptors("descriptors"),
        Scripts("scripts"),
        ScriptDetails("script"),
        Datatypes("datatypes"),
        DatatypeDetails("datatype"),
        SettableProperties("settable-properties"),
		Help("help");


        private final String name;

        Command(String name) {
            this.name = name;
        }
        public String getName() {
            return name;
        }

		public void run(Map<String,List<String>> options) throws InterruptedException, IOException, Exception {
			// Default to the current working directory if no output directory is specified
			String outputDirectory = new java.io.File(".").getCanonicalPath();
			String outputFile = new java.io.File(outputDirectory, this.getName().toLowerCase() + ".xml").getAbsolutePath();

			if (options.containsKey("output"))
			{
				outputDirectory = options.get("output").get(0);
				outputFile = options.get("output").get(0);
				java.io.File outputFileObj = new java.io.File(outputFile);
				if (outputFileObj.isDirectory())
				{
					// Output selected is a directory, we create a file name based on the command inside it
					outputFile = new java.io.File(outputFile, this.getName().toLowerCase() + ".xml").getAbsolutePath();
				} else
				{
					outputDirectory = outputFileObj.getParent();
				}
			}
			String scriptsDescriptors;
			String datatypesDescriptors;
			String result;
			switch (this)
			{
				case Descriptors:
					System.out.println("Retrieving all descriptors...");
					scriptsDescriptors = SimpleAPI.getInstance().getScripts(true);
					java.nio.file.Files.write(java.nio.file.Paths.get(outputDirectory, "scripts.xml"), scriptsDescriptors.getBytes());
					datatypesDescriptors = SimpleAPI.getInstance().getDatatypes();
					java.nio.file.Files.write(java.nio.file.Paths.get(outputDirectory, "datatypes.xml"), datatypesDescriptors.getBytes());
					break;
				case Scripts:
					System.out.println("Retrieving scripts descriptors...");
					result = SimpleAPI.getInstance().getScripts(true);
					java.nio.file.Files.write(java.nio.file.Paths.get(outputFile), result.getBytes());
					break;
				case ScriptDetails:
					if (!options.containsKey("id"))
					{
						throw new Exception("The 'id' option is required for the ScriptDetails command");
					}
					String scriptId = options.get("id").get(0);
					System.out.println("Retrieving details for script " + scriptId + "...");
					result = SimpleAPI.getInstance().getScriptDetails(scriptId);
					java.nio.file.Files.write(java.nio.file.Paths.get(outputFile), result.getBytes());
					break;
				case Datatypes:
					System.out.println("Retrieving datatypes descriptors...");
					result = SimpleAPI.getInstance().getDatatypes();
					java.nio.file.Files.write(java.nio.file.Paths.get(outputFile), result.getBytes());
					break;
				case DatatypeDetails:
					if (!options.containsKey("id"))
					{
						throw new Exception("The 'id' option is required for the DatatypeDetails command");
					}
					String datatypeId = options.get("id").get(0);
					System.out.println("Retrieving details for datatype " + datatypeId + "...");
					result = SimpleAPI.getInstance().getDatatypeDetails(datatypeId);
					java.nio.file.Files.write(java.nio.file.Paths.get(outputFile), result.getBytes());
					break;
				case SettableProperties:
					System.out.println("Retrieving settable properties descriptors...");
					result = SimpleAPI.getInstance().getSettableProperties();
					java.nio.file.Files.write(java.nio.file.Paths.get(outputFile), result.getBytes());
					break;
				default:
					throw new Exception("Command not implemented: " + this.getName());
			}
		}
    }


    /**
	 * Simple command line interface
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		// Print start date and time with milliseconds precision
		System.out.println(dateFormat.format(new java.util.Date()) + " : DAISY Pipeline embedded command line interface");

		if (args.length < 1) {
			System.err.println("Expected script or command argument");
			System.exit(1);
		}
		String scriptOrCommand = args[0];
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
		// Check if scriptOrCommand is one of the known commands
		try{
            CommandLineInterface.Command command = CommandLineInterface.Command.valueOf(scriptOrCommand);
            try {
				command.run(options);
            } catch (Exception e) {
                System.err.println("Error running the command " + command.getName() + ": " + e.getMessage());
                System.exit(1);
            }
            System.exit(0);
        } catch (IllegalArgumentException e) {
			// Not a command, we continue to treat it as a script name
        }

		CommandLineJob job = null;
		try {
			job = SimpleAPI.getInstance().startJob(scriptOrCommand, options);
		} catch (IllegalArgumentException e) {
			System.err.println(e.getMessage());
			System.exit(1);
		} catch (FileNotFoundException|URISyntaxException e) {
			System.err.println("File does not exist: " + e.getMessage());
			System.exit(1);
		}
		while (true) {
			for (String m : job.getNewMessages()) System.out.println(m);
			//System.out.println("accessor progress : " + accessor.getProgress().doubleValue() * 100 + "%");
			if(job.isProgressUpdated()) {
				System.out.println("Progression: " + job.getUpdatedProgress() * 100 + "%");
			}
			switch (job.getStatus()) {
			case SUCCESS:
			case FAIL:
			case ERROR:
				System.out.println("Job finished with status: " + job.getStatus());
				if(job.getStatus() != Job.Status.SUCCESS) {
					// If the job failed, we save the log file for more details	
					String outputDirectory = new java.io.File(".").getCanonicalPath();
					String outputFile = new java.io.File(outputDirectory, job.getStatus() + ".log.txt").getAbsolutePath();
					if (options.containsKey("output"))
					{
						String outputValue = options.get("output").get(0);
						java.io.File outputFileObj = new java.io.File(outputValue);
						if (outputFileObj.isDirectory())
						{
							// Output selected is a directory, we create a file name based on the status
							outputDirectory = outputFileObj.getAbsolutePath();
							outputFile = new java.io.File(outputDirectory, scriptOrCommand + "-" + job.getStatus() + ".log.txt").getAbsolutePath();
						} else
						{
							// Output was a file, we use its parent directory and create a new file name based on the status
							outputDirectory = outputFileObj.getParent();
							outputFile = new java.io.File(outputDirectory, scriptOrCommand + "-" + job.getStatus() + ".log.txt").getAbsolutePath();
						}
					}
					String logFilePath =  job.getLogFile();
					if(logFilePath.startsWith("file:")) {
						try {
							logFilePath = new File(new URL(logFilePath).toURI()).getAbsolutePath();
						} catch (Exception e) {
							System.err.println("Unable to convert log file URL to path: " + e.getMessage());
						}
					}
					try {
						Files.copy(new File(logFilePath).toPath(), new File(outputFile).toPath(), StandardCopyOption.REPLACE_EXISTING);	
					} catch (IOException e) {
						System.err.println("Unable to copy log file " + logFilePath + ": " + e.getMessage());
					}
					System.out.println("Please consult the log file saved at the following location for more details : " + outputFile);
				}
				System.exit(0);
			case IDLE:
			case RUNNING:
			default:
				Thread.sleep(1000);
			}
		}
	}
}
