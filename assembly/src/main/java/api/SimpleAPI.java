package api;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.InputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.UncheckedIOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import java.lang.Thread;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.daisy.common.messaging.Message;
import org.daisy.common.messaging.ProgressMessage;
import org.daisy.common.messaging.Message.Level;
import org.daisy.common.messaging.MessageAccessor;
import org.daisy.common.spi.CreateOnStart;
import org.daisy.common.spi.ServiceLoader;
import org.daisy.pipeline.datatypes.DatatypeRegistry;
import org.daisy.pipeline.datatypes.DatatypeService;
import org.daisy.pipeline.job.Job;
import org.daisy.pipeline.job.JobFactory;
import org.daisy.pipeline.job.JobMonitor;
import org.daisy.pipeline.job.JobResult;
import org.daisy.pipeline.script.BoundScript;
import org.daisy.pipeline.script.Script;
import org.daisy.pipeline.script.ScriptOption;
import org.daisy.pipeline.script.ScriptPort;
import org.daisy.pipeline.script.ScriptRegistry;
import org.daisy.pipeline.script.ScriptService;

import org.daisy.common.properties.Properties;
import org.daisy.common.properties.Properties.SettableProperty;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.osgi.service.component.annotations.ReferenceCardinality;
import org.osgi.service.component.annotations.ReferencePolicy;

import xml.DatatypesXmlWriter;
import xml.PropertiesXmlWriter;
import xml.ScriptXmlWriter;
import xml.ScriptsXmlWriter;
import org.w3c.dom.Document;
import com.google.common.base.Optional;

import java.math.BigDecimal;

/**
 * A simplified Java API consisting of a {@link #startJob()} method that starts a job based on a
 * script name and a list of options and returns a {@link CommandLineJob}. This object provices
 * convenience methods for monitoring the status and messages. This class is used to build a simple
 * Java CLI (see the {@link #main()} method). The simplified API also makes it easier to bridge with
 * other programming languages using JNI.
 */
@Component(
	name = "SimpleAPI",
	immediate = true
)
public class SimpleAPI {

	private ScriptRegistry scriptRegistry;
	private DatatypeRegistry datatypeRegistry;
	private JobFactory jobFactory;

	@Reference(
		name = "script-registry",
		unbind = "-",
		service = ScriptRegistry.class,
		cardinality = ReferenceCardinality.MANDATORY,
		policy = ReferencePolicy.STATIC
	)
	public void setScriptRegistry(ScriptRegistry scriptRegistry) {
		System.out.println(dateFormat.format(new java.util.Date()) + " : setting script registry ");
		this.scriptRegistry = scriptRegistry;
	}

	@Reference(
		name = "datatype-registry",
		unbind = "-",
		service = DatatypeRegistry.class,
		cardinality = ReferenceCardinality.MANDATORY,
		policy = ReferencePolicy.STATIC
	)
	public void setDatatypeRegistry(DatatypeRegistry datatypeRegistry) {
		System.out.println(dateFormat.format(new java.util.Date()) + " : setting datatype registry ");
		this.datatypeRegistry = datatypeRegistry;
	}

	@Reference(
		name = "job-factory",
		unbind = "-",
		service = JobFactory.class,
		cardinality = ReferenceCardinality.MANDATORY,
		policy = ReferencePolicy.STATIC
	)
	public void setJobFactory(JobFactory jobFactory) {
		System.out.println(dateFormat.format(new java.util.Date()) + " : setting job factory ");
		this.jobFactory = jobFactory;
	}

	public CommandLineJob startJob(String scriptName, Map<String,? extends Iterable<String>> options)
			throws IllegalArgumentException, FileNotFoundException, URISyntaxException {
		System.out.println(dateFormat.format(new java.util.Date()) + " : Start searching for script in the registry");
		ScriptService<?> scriptService = scriptRegistry.getScript(scriptName);
		if (scriptService == null)
			throw new IllegalArgumentException(scriptName + " script not found");
		System.out.println(dateFormat.format(new java.util.Date()) + " : found script in the registry, loading ... ");
		Script script = scriptService.load();
		System.out.println(dateFormat.format(new java.util.Date()) + " : Loaded the script, creating job ... ");

		File fileBase = new File(System.getProperty("org.daisy.pipeline.cli.cwd", "."));
		CommandLineJobParser parser = new CommandLineJobParser(script, fileBase);
		for (Map.Entry<String,? extends Iterable<String>> e : options.entrySet())
			for (String value : e.getValue())
				parser.withArgument(e.getKey(), value);
		CommandLineJob job = parser.createJob(jobFactory);
		System.out.println(dateFormat.format(new java.util.Date()) + " : Job created, starting ... ");
		new Thread(job).start();
		System.out.println(dateFormat.format(new java.util.Date()) + " : Job started");
		return job;
	}

	/**
	 * Start a new job
	 *
	 * @param scriptName the name of the script
	 * @param options the command line arguments, providing the inputs and option values for the
	 *                job, and file locations where results must be stored.
	 * @return The job, wrapped in a {@link CommandLineJob} object for easy monitoring.
	 */
	// public static CommandLineJob startJob(String scriptName, Map<String,? extends Iterable<String>> options)
	// 		throws IllegalArgumentException, FileNotFoundException, URISyntaxException {
	// 	return getInstance()._startJob(scriptName, options);
	// }

	/**
	 * Get the XML descriptors for all available scripts.
	 *
	 * @param withDetails whether to include detailed information about the scripts in the XML descriptors
	 * @return A string containing the XML descriptors for all scripts.
	 * @throws Exception If an error occurs while generating the XML descriptors.
	 */
	public String getScripts(boolean withDetails) throws Exception {
		List<Script> scripts = new ArrayList<>();
		for (ScriptService<?> s : this.scriptRegistry.getScripts()) {
			ScriptService<?> _s = this.scriptRegistry.getScript(s.getId());
			scripts.add(_s.load());
		}
		TransformerFactory t = TransformerFactory.newInstance();
		try {
			Transformer transformer = t.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");

			Document scriptsXml = new ScriptsXmlWriter(scripts,"file:///.", withDetails).getXmlDocument();
			DOMSource source = new DOMSource(scriptsXml);
			StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(writer);
			transformer.transform(source, result);
			writer.close();
			return writer.toString();
		} catch (TransformerException e) {
			throw new Exception("Could not export scripts xml descriptors", e);
		}
	}

	public String getScriptDetails(String scriptName) throws Exception {
		ScriptService<?> scriptService = this.scriptRegistry.getScript(scriptName);
		if (scriptService == null)
			throw new IllegalArgumentException(scriptName + " script not found");
		Script script = scriptService.load();
		TransformerFactory t = TransformerFactory.newInstance();
		try {
			Transformer transformer = t.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			ScriptXmlWriter scriptwriter = new ScriptXmlWriter(script,"file:///.").withDetails();
			Document scriptXml = scriptwriter.getXmlDocument();
			DOMSource source = new DOMSource(scriptXml);
			StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(writer);
			transformer.transform(source, result);
			writer.close();
			return writer.toString();
		} catch (TransformerException e) {
			throw new Exception("Could not export script xml descriptor", e);
		}
	}

	/**
	 * Get the XML descriptors for all available datatypes.
	 *
	 * @return A string containing the XML descriptors for all datatypes.
	 * @throws Exception If an error occurs while generating the XML descriptors.
	 */
	public String getDatatypes() throws Exception {
		TransformerFactory t = TransformerFactory.newInstance();
		try {
			Transformer transformer = t.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			Document datatypesXml = new DatatypesXmlWriter(this.datatypeRegistry.getDatatypes(),"file:///.").getXmlDocument();
			DOMSource source = new DOMSource(datatypesXml);
			StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(writer);
			transformer.transform(source, result);
			writer.close();
			return writer.toString();
		} catch (TransformerException e) {
			throw new Exception("Could not export datatypes xml descriptors", e);
		}
	}

	/**
	 * Get the XML descriptors for all available datatypes.
	 *
	 * @return A string containing the XML descriptors for all datatypes.
	 * @throws Exception If an error occurs while generating the XML descriptors.
	 */
	public String getDatatypeDetails(String id) throws Exception {
		Optional<DatatypeService> datatypeService = this.datatypeRegistry.getDatatype(id);
		if (!datatypeService.isPresent())
			throw new IllegalArgumentException(id + " datatype not found");
		
		TransformerFactory t = TransformerFactory.newInstance();
		try {
			Transformer transformer = t.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");
			Document datatypesXml = datatypeService.get().asDocument();
			DOMSource source = new DOMSource(datatypesXml);
			StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(writer);
			transformer.transform(source, result);
			writer.close();
			return writer.toString();
		} catch (TransformerException e) {
			throw new Exception("Could not export datatypes xml descriptors", e);
		}
	}

	/**
	 * Get the XML descriptors for all settable properties.
	 *
	 * @return A string containing the XML descriptors for all settable properties.
	 * @throws Exception If an error occurs while generating the XML descriptors.
	 */
	public String getSettableProperties() throws Exception {
		TransformerFactory t = TransformerFactory.newInstance();
		try {
			Transformer transformer = t.newTransformer();
			transformer.setOutputProperty(OutputKeys.INDENT, "yes");

			List<SettableProperty> properties = new ArrayList<>(Properties.getSettableProperties());
			Collections.sort(properties, (o1, o2) -> (o1.getName().compareTo(o2.getName())));

			Document propertiesXml = new PropertiesXmlWriter(properties,"file:///.",true).getXmlDocument();
			DOMSource source = new DOMSource(propertiesXml);
			StringWriter writer = new StringWriter();
			StreamResult result = new StreamResult(writer);
			transformer.transform(source, result);
			writer.close();
			return writer.toString();
		} catch (TransformerException e) {
			throw new Exception("Could not export settable properties xml descriptors", e);
		}
	}

	public void setProperty(String name, String value) throws IllegalArgumentException {
		Set<Properties.SettableProperty> properties = Properties.getSettableProperties();
		for (Properties.SettableProperty p : properties) {
			if (p.getName().equals(name)) {
				p.setValue(value);
				return;
			}
		}
		throw new IllegalArgumentException("Unknown or unsettable property: " + name);
	}

	/**
	 * Singleton thread safe instance of SimpleAPI.
	 */
	private static SimpleAPI INSTANCE;

	private static final DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSX");

	protected SimpleAPI() {
		// private constructor to prevent instantiation
		System.out.println(dateFormat.format(new java.util.Date()) + " : SimpleAPI constructor called ");
	}

	/**
	 * Get the singleton {@link SimpleAPI} instance.
	 */
	public static SimpleAPI getInstance() {
		if (INSTANCE == null) {
			for (CreateOnStart o : ServiceLoader.load(CreateOnStart.class))
				if (INSTANCE == null && o instanceof SimpleAPI)
					INSTANCE = (SimpleAPI)o;
			if (INSTANCE == null)
				throw new IllegalStateException();
			System.out.println(dateFormat.format(new java.util.Date()) + " : SimpleAPI instance created");
		}
		return INSTANCE;
	}


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
