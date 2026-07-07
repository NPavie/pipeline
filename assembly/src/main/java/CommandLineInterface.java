import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

import api.CommandLineJob;
import api.SimpleAPI;

public class CommandLineInterface {
    private static final DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX");

    /**
	 * Simple command line interface
	 */
	public static void main(String[] args) throws InterruptedException, IOException {
		// Print start date and time with milliseconds precision
		System.out.println(dateFormat.format(new java.util.Date()) + " : Starting SimpleAPI command line interface");

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
				System.exit(0);
			case IDLE:
			case RUNNING:
			default:
				Thread.sleep(1000);
			}
		}
	}
}
