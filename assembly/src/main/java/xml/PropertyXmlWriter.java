package xml;

import java.io.IOException;

import org.daisy.common.properties.Properties.SettableProperty;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import org.xml.sax.SAXException;

public class PropertyXmlWriter {

	private static Logger logger = LoggerFactory.getLogger(PropertyXmlWriter.class);

	private final String baseUrl;
	private final SettableProperty property;
	private final boolean scrub;

	/**
	 * @param scrub Whether to scrub sensitive data
	 */
	public PropertyXmlWriter(SettableProperty property, String baseUrl, boolean scrub) {
		this.property = property;
		this.baseUrl = baseUrl;
		this.scrub = scrub;
	}

	public Document getXmlDocument() {
		Document doc = getXmlDocument(scrub);
		return doc;
	}

	private Document getXmlDocument(boolean scrub) {
		Document doc = XmlUtils.createDom("property");
		addElementData(doc.getDocumentElement());
		return doc;
	}

	// instead of creating a standalone XML document, add an element to an existing document
	void addAsElementChild(Element parent) {
		Document doc = parent.getOwnerDocument();
		Element propertyElm = doc.createElementNS(XmlUtils.NS_PIPELINE_DATA, "property");
		addElementData(propertyElm);
		parent.appendChild(propertyElm);
	}

	private void addElementData(Element element) {
		element.setAttribute("href", baseUrl + "/properties/" + property.getName());
		element.setAttribute("name", property.getName());
		String val = property.getValue();
		String description = property.getDescription();
		if (description != null)
			element.setAttribute("desc", description);
		if (val != null) {
			try {
				Element xmlContent = XmlUtils.parseXml(val, element.getOwnerDocument());
				element.appendChild(xmlContent);
			} catch (IOException|SAXException e) {
				element.setAttribute("value", scrub && property.isSensitive() ? "***" : val);
			}
		}
	}
}
