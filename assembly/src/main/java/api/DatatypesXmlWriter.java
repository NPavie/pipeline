package api;

import org.daisy.pipeline.datatypes.DatatypeService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

public class DatatypesXmlWriter {
        private final String baseUrl;
        private Iterable<DatatypeService> datatypes;
        private static final Logger logger = LoggerFactory.getLogger(DatatypesXmlWriter.class);

        /**
         * @param baseUrl Prefix to be included at the beginning of <code>href</code>
         *                attributes (the resource paths). Set this to {@link Request#getRootRef()}
         *                to get fully qualified URLs. Set this to {@link Routes#getPath()} to get
         *                absolute paths relative to the domain name.
         */
        public DatatypesXmlWriter(Iterable<DatatypeService> datatypes, String baseUrl) {
                this.datatypes = datatypes;
                this.baseUrl = baseUrl;
        }
        
        public Document getXmlDocument(){
                if (this.datatypes== null) {
                        logger.warn("Null datatypes, couldn't create xml");
                        return null;
                }
                return this.buildXml();
        }
        private Document buildXml(){

		Document doc = XmlUtils.createDom("datatypes");
		Element datatypesElem= doc.getDocumentElement();
		datatypesElem.setAttribute("href", baseUrl + "/datatypes");
                for (DatatypeService ds : this.datatypes) {
                        Element dsElem=doc.createElementNS(XmlUtils.NS_PIPELINE_DATA,"datatype");
                        dsElem.setAttribute("id",ds.getId());
                        dsElem.setAttribute("href",String.format("%s%s/%s", baseUrl, "/datatypes/",ds.getId()));
                        datatypesElem.appendChild(dsElem);
                        try {
                                Document dsDoc = ds.asDocument();
                                Element imported = (Element) doc.importNode(dsDoc.getDocumentElement(), true);
                                dsElem.appendChild(imported);
                        } catch (Exception e) {
                                logger.warn("getting datatype as document",e);
                        }
                        
                }

		// for debugging only
		// if (!XmlValidator.validate(doc, XmlValidator.DATATYPES_SCHEMA_URL)) {
		// 	logger.error("INVALID XML:\n" + XmlUtils.nodeToString(doc));
		// }
                return doc;
        }
}
