package org.daisy.dotify.engine.impl;

import java.io.IOException;

import org.daisy.dotify.api.engine.LayoutEngineException;
import org.daisy.dotify.api.writer.PagedMediaWriterConfigurationException;
import org.junit.Test;
public class PaddingTest extends AbstractFormatterEngineTest {
	
	@Test
	public void testPadding_01() throws LayoutEngineException, IOException, PagedMediaWriterConfigurationException {
		testPEF("resource-files/padding-input.obfl", "resource-files/padding-expected.pef", false);
	}
	
	@Test
	public void testPadding_02() throws LayoutEngineException, IOException, PagedMediaWriterConfigurationException {
		testPEF("resource-files/padding-sides-only-input.obfl", "resource-files/padding-sides-only-expected.pef", false);
	}
	
	@Test
	public void testPadding_03() throws LayoutEngineException, IOException, PagedMediaWriterConfigurationException {
		testPEF("resource-files/padding-nested-input.obfl", "resource-files/padding-nested-expected.pef", false);
	}

}
