package api;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.Map;

import org.daisy.pipeline.job.JobFactory;
import org.daisy.pipeline.script.BoundScript;
import org.daisy.pipeline.script.Script;
import org.daisy.pipeline.script.ScriptOption;
import org.daisy.pipeline.script.ScriptPort;


/**
 * Builder class to create a {@link CommandLineJob} object by parsing command line arguments.
 */
public class CommandLineJobParser {

    private final Script script;
    private final File fileBase;
    private final BoundScript.Builder builder;
    private final Map<String,URI> resultLocations;

    public CommandLineJobParser(Script script, File fileBase) {
        this.script = script;
        this.fileBase = fileBase;
        builder = new BoundScript.Builder(script);
        resultLocations = new HashMap<>();
    }

    /**
     * Parse command line argument
     */
    public CommandLineJobParser withArgument(String key, String value)
            throws IllegalArgumentException, FileNotFoundException, URISyntaxException {
        if (value == null)
            throw new IllegalArgumentException();
        if (script.getInputPort(key) != null)
            return withInput(key, value);
        else if (script.getOption(key) != null)
            return withOption(key, value);
        else if (script.getOutputPort(key) != null)
            return withOutput(key, value);
        else
            throw new IllegalArgumentException("Unknown argument: " + key);
    }

    /**
     * Parse command line argument as script input.
     *
     * @throws IllegalArgumentException if the script does not have the specified port, or the
     *         port does not accept a sequence of documents and multiple documents are supplied.
     * @throws FileNotFoundException if <code>source</code> does not exist.
     */
    private CommandLineJobParser withInput(String port, String source) throws IllegalArgumentException, FileNotFoundException {
        File file = new File(source);
        if (!file.isAbsolute()) {
            if (fileBase == null)
                throw new FileNotFoundException("File must be an absolute path, but got " + file);
            file = new File(fileBase, file.getPath());
        }
        try {
            file = file.getCanonicalFile();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
        builder.withInput(port, file);
        return this;
    }

    /**
     * Parse and validate command line argument as script option.
     *
     * @throws IllegalArgumentException if the script does not have the specified option, the
     *         option does not accept a sequence of values and multiple values are supplied, or
     *         the value is not valid according to the option type.
     * @throws FileNotFoundException if the option type is "anyFileURI" and the value can not be
     *         resolved to a document.
     * @throws URISyntaxException if the option type is "anyFileURI" or "anyDirURI" and the
     *         value starts with "file:/" but is an invalid URI
     */
    private CommandLineJobParser withOption(String name, String value)
            throws IllegalArgumentException, FileNotFoundException, URISyntaxException {
        ScriptOption o = script.getOption(name);
        if (o != null) {
            String type = o.getType().getId();
            if ("anyFileURI".equals(type)) {
                File file; {
                    if (value.startsWith("file:/")) {
                        file = new File(new URI(value));
                    } else {
                        file = new File(value);
                    }
                }
                if (!file.isAbsolute()) {
                    if (fileBase == null)
                        throw new FileNotFoundException("File must be an absolute path, but got " + file);
                    file = new File(fileBase, file.getPath());
                }
                try {
                    value = file.getCanonicalFile().toURI().toString();
                } catch (IOException e) {
                    throw new UncheckedIOException(e);
                }
            } else if ("anyDirURI".equals(type)) {
                File dir; {
                    if (value.startsWith("file:/")) {
                        dir = new File(new URI(value));
                    } else {
                        dir = new File(value);
                    }
                }
                if (!dir.isAbsolute()) {
                    if (fileBase == null)
                        throw new FileNotFoundException("File must be an absolute path, but got " + dir);
                    dir = new File(fileBase, dir.getPath());
                }
                // these checks are not done by BoundScript.Builder
                if (!dir.exists())
                    throw new FileNotFoundException(dir.getPath());
                if (!dir.isDirectory())
                    throw new IllegalArgumentException("Not a directory: " + dir);
                try {
                    value = dir.getCanonicalFile().toURI().toString() + "/";
                } catch (IOException e) {
                    throw new UncheckedIOException(e);
                }
            }
        }
        builder.withOption(name, value);
        return this;
    }

    /**
     * Parse command line argument as script output.
     *
     * @throws IllegalArgumentException if the script does not have the specified port,
     *         <code>result</code> is a non-empty directory, or exists and is not a directory.
     */
    private CommandLineJobParser withOutput(String port, String result) throws IllegalArgumentException, FileNotFoundException {
        ScriptPort p = script.getOutputPort(port);
        if (p == null)
            throw new IllegalArgumentException(
                String.format("Output '%s' is not recognized by script '%s'", port, script.getId()));
        if (resultLocations.containsKey(port))
            throw new IllegalArgumentException(
                String.format("Output '%s' already specified", port));
        File file = new File(result);
        if (!file.isAbsolute()) {
            if (fileBase == null)
                throw new FileNotFoundException("File must be an absolute path, but got " + file);
            file = new File(fileBase, file.getPath());
        }
        try {
            file = file.getCanonicalFile();
        } catch (IOException e) {
            throw new UncheckedIOException(e);
        }
        if (result.endsWith("/")) {
            if (file.exists()) {
                if (!file.isDirectory())
                    throw new IllegalArgumentException("Not a directory: " + file);
                else if (file.list().length > 0)
                    throw new IllegalArgumentException("Directory is not empty: " + file);
            }
            resultLocations.put(port, URI.create(file.toURI() + "/"));
        } else {
            if (file.exists()) {
                if (file.isDirectory()) {
                    if (file.list().length > 0)
                        throw new IllegalArgumentException("Directory is not empty: " + file);
                    resultLocations.put(port, file.toURI());
                } else {
                    if (p.isSequence())
                        throw new IllegalArgumentException("Not a directory: " + file);
                    else
                        throw new IllegalArgumentException("File exists: " + file);
                }
            } else {
                if (p.isSequence())
                    resultLocations.put(port, URI.create(file.toURI() + "/"));
                else
                    resultLocations.put(port, file.toURI());
            }
        }
        return this;
    }

    public CommandLineJob createJob(JobFactory factory) {
        return new CommandLineJob(factory.newJob(builder.build()).build().get(), resultLocations);
    }
}
