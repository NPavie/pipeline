package org.daisy.pipeline.word_to_dtbook.shapes;

import com.sun.star.beans.PropertyValue;
import com.sun.star.beans.XPropertySet;
import com.sun.star.comp.helper.Bootstrap;
import com.sun.star.comp.helper.BootstrapException;
import com.sun.star.document.MacroExecMode;
import com.sun.star.drawing.XDrawPage;
import com.sun.star.drawing.XDrawPageSupplier;
import com.sun.star.drawing.XGraphicExportFilter;
import com.sun.star.frame.XComponentLoader;
import com.sun.star.frame.XDesktop;
import com.sun.star.graphic.XGraphic;
import com.sun.star.graphic.XGraphicProvider;
import com.sun.star.lang.XComponent;
import com.sun.star.lang.XMultiComponentFactory;
import com.sun.star.lang.XServiceInfo;
import com.sun.star.text.XText;
import com.sun.star.text.XTextContent;
import com.sun.star.text.XTextCursor;
import com.sun.star.text.XTextDocument;
import com.sun.star.text.XTextRange;
import com.sun.star.uno.UnoRuntime;
import com.sun.star.uno.XComponentContext;
import com.sun.star.util.XCloseable;
import org.apache.commons.io.FilenameUtils;
import org.daisy.common.shell.BinaryFinder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;

public class OOShapesExporter {

    private static final Logger LOGGER = LoggerFactory.getLogger(OOShapesExporter.class);

    /**
     * Export an openoffice graphic object as a PNG image.
     *
     * @param xGraphicProvider graphic provider used to store the graphic
     * @param xGraphic         the graphic to export
     * @param fileName         destination URL (file:///...) of the PNG file
     * @throws Exception if the graphic cannot be stored
     */
    public static void exportGraphicObject(XGraphicProvider xGraphicProvider, XGraphic xGraphic, String fileName) throws Exception {
        if (xGraphicProvider == null){
            throw new Exception("XGraphicProvider is null.");
        }

        if (xGraphic == null){
            throw new Exception("XGraphic is null.");
        }

        PropertyValue[] properties = new PropertyValue[2];
        properties[0] = new PropertyValue();
        properties[0].Name = "URL";
        properties[0].Value = fileName;
        properties[1] = new PropertyValue();
        properties[1].Name = "MimeType";
        properties[1].Value = "image/png";

        xGraphicProvider.storeGraphic(xGraphic, properties);
    }

    /** A shape of the document together with its position in the text, used to order the shapes. */
    private static class ShapeEntry {
        final Object element;
        final int anchorOffset;
        ShapeEntry(Object element, int anchorOffset) {
            this.element = element;
            this.anchorOffset = anchorOffset;
        }
    }

    /**
     * Export all the shapes (inline or anchored) of a text document as PNG images,
     * in their order of appearance in the document.
     * <p>
     * Exported files are named {@code <outputPrefix><n>.png} (n starting at 1), mirroring
     * the naming scheme expected by the conversion stylesheets
     * ({@code <document name>-Shape<n>.png}). Embedded OLE objects and text boxes are not
     * exported but still count in the numbering.
     *
     * @param xGraphicProvider     graphic provider used to store the graphics
     * @param xGraphicExportFilter export filter used to render the drawing shapes
     * @param xTextDocument        the document to extract the shapes from
     * @param outDir               destination folder URL
     * @param outputPrefix         prefix of the exported files, usually {@code <document name>-Shape}
     * @throws Exception if the shapes cannot be enumerated
     */
    public static void exportAllEmbeddedGraphics(
            XGraphicProvider xGraphicProvider,
            XGraphicExportFilter xGraphicExportFilter,
            XTextDocument xTextDocument,
            String outDir,
            String outputPrefix
    ) throws Exception {
        if (xGraphicProvider == null){
            throw new Exception("XGraphicProvider is null.");
        }

        if (xGraphicExportFilter == null){
            throw new Exception("XGraphicExportFilter is null.");
        }

        if (xTextDocument == null){
            throw new Exception("XTextDocument is null.");
        }

        XDrawPageSupplier xDrawPageSupplier = UnoRuntime.queryInterface(XDrawPageSupplier.class, xTextDocument);
        if (xDrawPageSupplier == null){
            return;
        }
        XDrawPage xDrawPage = xDrawPageSupplier.getDrawPage();
        if (xDrawPage == null){
            return;
        }
        XText xText = xTextDocument.getText();

        // collect the shapes of the document: inline graphics, embedded objects and drawing shapes
        List<ShapeEntry> shapes = new ArrayList<>();
        int count = xDrawPage.getCount();
        for (int i = 0; i < count; i++){
            Object elem = xDrawPage.getByIndex(i);
            XServiceInfo xServiceInfo = UnoRuntime.queryInterface(XServiceInfo.class, elem);
            if (xServiceInfo == null){
                continue;
            }
            if (!xServiceInfo.supportsService("com.sun.star.text.TextGraphicObject")
                    && !xServiceInfo.supportsService("com.sun.star.text.TextEmbeddedObject")
                    && !xServiceInfo.supportsService("com.sun.star.drawing.Shape")){
                continue;
            }
            XTextContent xTextContent = UnoRuntime.queryInterface(XTextContent.class, elem);
            XTextRange anchor = xTextContent != null ? xTextContent.getAnchor() : null;
            shapes.add(new ShapeEntry(elem, anchorOffset(xText, anchor)));
        }

        // order the shapes by their position in the document (the sort is stable, so shapes
        // anchored at the same position keep their draw page order)
        Collections.sort(shapes, new Comparator<ShapeEntry>() {
            @Override
            public int compare(ShapeEntry a, ShapeEntry b) {
                return Integer.compare(a.anchorOffset, b.anchorOffset);
            }
        });

        String dir = outDir.endsWith("/") ? outDir : outDir + "/";
        int id = 0;
        for (ShapeEntry shape : shapes){
            id++;
            String fileUrl = toFileUrl(dir, outputPrefix + id + ".png");
            exportShape(xGraphicProvider, xGraphicExportFilter, shape.element, fileUrl, id);
        }
    }

    /**
     * Export a single shape as a PNG image. Embedded OLE objects and text boxes are skipped.
     *
     * @param fileUrl destination URL of the PNG file
     * @param id      1-based index of the shape in the document, used for logging
     * @return true if a non-empty image file was written
     */
    private static boolean exportShape(
            XGraphicProvider xGraphicProvider,
            XGraphicExportFilter xGraphicExportFilter,
            Object shape,
            String fileUrl,
            int id
    ) {
        XServiceInfo xServiceInfo = UnoRuntime.queryInterface(XServiceInfo.class, shape);
        if (xServiceInfo == null){
            return false;
        }
        try {
            if (xServiceInfo.supportsService("com.sun.star.text.TextEmbeddedObject")){
                LOGGER.info("Shape {} is an embedded OLE object, it will not be exported", id);
                return false;
            }
            if (xServiceInfo.supportsService("com.sun.star.text.TextGraphicObject")){
                // inline or anchored picture: export the graphic itself
                XPropertySet xPropertySet = UnoRuntime.queryInterface(XPropertySet.class, shape);
                XGraphic xGraphic = UnoRuntime.queryInterface(
                        XGraphic.class, xPropertySet.getPropertyValue("Graphic")
                );
                if (xGraphic == null){
                    Object graphicURL = xPropertySet.getPropertyValue("GraphicURL");
                    if (graphicURL != null && !graphicURL.toString().isEmpty()){
                        PropertyValue[] query = new PropertyValue[1];
                        query[0] = new PropertyValue();
                        query[0].Name = "URL";
                        query[0].Value = graphicURL.toString();
                        xGraphic = xGraphicProvider.queryGraphic(query);
                    }
                }
                if (xGraphic != null){
                    exportGraphicObject(xGraphicProvider, xGraphic, fileUrl);
                    return checkExported(fileUrl, id);
                }
                LOGGER.warn("Shape {} has no graphic, it will not be exported", id);
                return false;
            }
            if (xServiceInfo.supportsService("com.sun.star.drawing.TextShape")){
                LOGGER.info("Shape {} is a text box and will not be saved as an image", id);
                return false;
            }
            if (xServiceInfo.supportsService("com.sun.star.drawing.Shape")){
                // drawing shape (autoshape, group, line, chart, ...): render it
                XComponent xComponent = UnoRuntime.queryInterface(XComponent.class, shape);
                xGraphicExportFilter.setSourceDocument(xComponent);
                PropertyValue[] properties = new PropertyValue[2];
                properties[0] = new PropertyValue();
                properties[0].Name = "URL";
                properties[0].Value = fileUrl;
                properties[1] = new PropertyValue();
                properties[1].Name = "MimeType";
                properties[1].Value = "image/png";
                xGraphicExportFilter.filter(properties);
                return checkExported(fileUrl, id);
            }
        } catch (Exception e){
            LOGGER.warn("Shape {} could not be extracted: {}", id, e.getMessage());
        }
        return false;
    }

    /** Check that the export produced a non-empty file, delete it and log otherwise. */
    private static boolean checkExported(String fileUrl, int id) {
        try {
            File file = new File(URI.create(fileUrl));
            if (file.exists() && file.length() > 0){
                LOGGER.info("Shape {} saved as {}", id, fileUrl);
                return true;
            }
            if (file.exists()){
                file.delete();
            }
        } catch (Exception ignored) {
        }
        LOGGER.warn("Shape {} could not be saved as an image", id);
        return false;
    }

    /**
     * Character offset of the end of an anchor range in the text, used to order the shapes
     * by their position in the document.
     */
    private static int anchorOffset(XText xText, XTextRange anchor) {
        if (xText == null || anchor == null){
            return Integer.MAX_VALUE;
        }
        try {
            XTextCursor xTextCursor = xText.createTextCursor();
            xTextCursor.gotoStart(false);
            xTextCursor.gotoRange(anchor, true);
            return xTextCursor.getString().length();
        } catch (Exception e){
            return Integer.MAX_VALUE;
        }
    }

    private static String toFileUrl(String dirUrl, String fileName) throws URISyntaxException {
        File dir = new File(URI.create(dirUrl));
        return new File(dir, fileName).toURI().toString();
    }

    private static File toFile(String pathOrUri) throws URISyntaxException {
        if (pathOrUri.startsWith("file:")){
            return new File(URI.create(pathOrUri));
        }
        return new File(pathOrUri);
    }

    public static void ProcessShapes(String inputPath, String outputPath) throws IOException, Exception {
        Optional<String> sofficePath = BinaryFinder.find("soffice");
        if(!sofficePath.isPresent()){
            throw new IOException("No openoffice compatible runtime found in system");
        }
        File oooExecFolder = new File(sofficePath.get()).getParentFile();
        XComponentContext xContext = null;
        XMultiComponentFactory xMultiComponentFactory = null;
        Object oDesktop = null;
        XComponentLoader xComponentLoader = null;
        // Images export
        XGraphicProvider xGraphicProvider = null;
        // Shapes export
        XGraphicExportFilter xGraphicExportFilter = null;

        try {
            Method method = URLClassLoader.class.getDeclaredMethod("addURL", new Class[]{URL.class});
            method.setAccessible(true);
            method.invoke(Bootstrap.class.getClassLoader(), new Object[] {oooExecFolder.toURI().toURL()});
            List<String> temp = new ArrayList<>(Arrays.asList(Bootstrap.getDefaultOptions()));
            temp.add("--invisible");
            temp.add("--headless");
            xContext = Bootstrap.bootstrap(temp.toArray(new String[temp.size()]));
        } catch (BootstrapException e) {
            throw new IOException("Boostrap failed! Failed to start OpenOffice.", e);
        } catch (MalformedURLException | NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
            throw new RuntimeException(e);
        }
        XComponent document = null;
        try{
            xMultiComponentFactory  = (XMultiComponentFactory) xContext.getServiceManager();
            oDesktop = xMultiComponentFactory.createInstanceWithContext(
                    "com.sun.star.frame.Desktop", xContext);
            xComponentLoader = (XComponentLoader)UnoRuntime.queryInterface(
                    com.sun.star.frame.XComponentLoader.class, oDesktop);
            if (xComponentLoader == null) {
                throw new IOException("Failed to create openoffice XComponentLoader");
            }

            try {
                Object oGraphicProvider = xMultiComponentFactory.createInstanceWithContext(
                        "com.sun.star.graphic.GraphicProvider", xContext);
                xGraphicProvider = (XGraphicProvider) UnoRuntime.queryInterface(
                        XGraphicProvider.class, oGraphicProvider);

                Object oGraphicExportFilter = xMultiComponentFactory.createInstanceWithContext(
                        "com.sun.star.drawing.GraphicExportFilter", xContext);
                xGraphicExportFilter = UnoRuntime.queryInterface(
                        XGraphicExportFilter.class, oGraphicExportFilter);
            } catch (Exception e) {
                throw new IOException("Failed to create openoffice XGraphicProvider or xGraphicExportFilter", e);
            }
            if (xGraphicProvider == null || xGraphicExportFilter == null) {
                throw new IOException("Failed to create openoffice XGraphicProvider or xGraphicExportFilter");
            }

            PropertyValue[] properties = new PropertyValue[3];
            properties[0] = new PropertyValue();
            properties[0].Name = "Hidden";
            properties[0].Value = true;
            properties[1] = new PropertyValue();
            properties[1].Name = "ReadOnly";
            properties[1].Value = true;
            properties[2] = new PropertyValue();
            properties[2].Name = "MacroExecutionMode";
            properties[2].Value = MacroExecMode.NEVER_EXECUTE;

            File inputFile = toFile(inputPath);
            File outputDir = toFile(outputPath);
            String inputUrl = inputFile.toURI().toString();

            document = xComponentLoader.loadComponentFromURL(inputUrl, "_blank", 0, properties);

            XTextDocument xTextDocument = (XTextDocument) UnoRuntime.queryInterface(
                    XTextDocument.class, document);
            if (xTextDocument == null) {
                throw new IOException("Loaded component is not a text document: " + inputPath);
            }

            // same naming scheme as the Word exporter: <file name without extension, spaces
            // replaced by underscores>-Shape<n>.png in the output folder
            String baseName = FilenameUtils.removeExtension(inputFile.getName()).replace(" ", "_");
            String outDirUrl = outputDir.toURI().toString();

            // Exporting shapes
            exportAllEmbeddedGraphics(xGraphicProvider, xGraphicExportFilter, xTextDocument, outDirUrl, baseName + "-Shape");

        } finally {
            if (document != null){
                try {
                    XCloseable xCloseable = (XCloseable) UnoRuntime.queryInterface(
                            XCloseable.class, document);
                    if (xCloseable != null){
                        xCloseable.close(true);
                    } else {
                        document.dispose();
                    }
                } catch (Exception e){
                    LOGGER.warn("Could not close the document: {}", e.getMessage());
                    try {
                        document.dispose();
                    } catch (Exception ignored) {
                    }
                }
            }
            if (oDesktop != null){
                try {
                    XDesktop xDesktop = (XDesktop) UnoRuntime.queryInterface(
                            XDesktop.class, oDesktop);
                    if (xDesktop != null){
                        xDesktop.terminate();
                    }
                } catch (Exception e){
                    LOGGER.warn("Could not terminate the office: {}", e.getMessage());
                }
            }
        }
    }

    public static int Main(String[] args) {
        if(args.length < 2) {
            System.out.println("Usage: OOShapesExporter <inputPath> <outputPath>");
            return 1;
        }
        try {
            ProcessShapes(args[0], args[1]);
        } catch (java.io.IOException ioe) {
            ioe.printStackTrace();
            return 2;
        } catch (Exception e) {
            e.printStackTrace();
            return 2;
        }
        return 0;
    }

}
