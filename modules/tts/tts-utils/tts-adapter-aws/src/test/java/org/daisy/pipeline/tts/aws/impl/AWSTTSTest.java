package org.daisy.pipeline.tts.aws.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.daisy.pipeline.audio.AudioBuffer;
import org.daisy.pipeline.tts.AudioBufferAllocator;
import org.daisy.pipeline.tts.AudioBufferAllocator.MemoryException;
import org.daisy.pipeline.tts.StraightBufferAllocator;
import org.daisy.pipeline.tts.TTSRegistry.TTSResource;
import org.daisy.pipeline.tts.TTSService.Mark;
import org.daisy.pipeline.tts.TTSService.SynthesisException;
import org.daisy.pipeline.tts.Voice;

import org.junit.Assert;
import org.junit.Test;
import org.junit.Before;
import org.junit.Assume;

public class AWSTTSTest {
	
	@Before
	public void checkForRequiredConfiguration() {
		Assume.assumeTrue(System.getProperty("org.daisy.pipeline.tts.aws.accesskey") != null);
		Assume.assumeTrue(System.getProperty("org.daisy.pipeline.tts.aws.secretkey") != null);
		Assume.assumeTrue(System.getProperty("org.daisy.pipeline.tts.aws.region") != null);
		
	}

	static AudioBufferAllocator BufferAllocator = new StraightBufferAllocator();

	private static int getSize(Collection<AudioBuffer> buffers) {
		int res = 0;
		for (AudioBuffer buf : buffers) {
			res += buf.size;
		}
		return res;
	}

	private static AWSRestTTSEngine allocateEngine() throws Throwable {
		AWSTTSService s = new AWSTTSService();
		HashMap<String, String> params = new HashMap<String, String>();
		params.put("org.daisy.pipeline.tts.aws.accesskey", System.getProperty("org.daisy.pipeline.tts.aws.accesskey"));
		params.put("org.daisy.pipeline.tts.aws.secretkey", System.getProperty("org.daisy.pipeline.tts.aws.secretkey"));
		params.put("org.daisy.pipeline.tts.aws.region", System.getProperty("org.daisy.pipeline.tts.aws.region"));
		return (AWSRestTTSEngine) s.newEngine(params);
	}
	
	@Test
	public void convertToIntWithGivenParams() throws Throwable {
		System.out.println("Test - convertToIntWithGivenParams");
		Map<String, String> params = new HashMap<>();
		params.put("org.daisy.pipeline.tts.aws.priority", "20");
		AWSTTSService s = new AWSTTSService();
		s.newEngine(params);
	}
	
	@Test(expected=SynthesisException.class)
	public void convertToIntWithNotValidParams() throws Throwable {
		System.out.println("Test - convertToIntWithNotValidParams");
		Map<String, String> params = new HashMap<>();
		params.put("org.daisy.pipeline.tts.aws.priority", "2T0");
		AWSTTSService s = new AWSTTSService();
		s.newEngine(params);
	}

	@Test
	public void getVoiceInfo() throws Throwable {
		System.out.println("Test - getVoiceInfo");
		Collection<Voice> voices = allocateEngine().getAvailableVoices();
		Assert.assertTrue(voices.size() > 50);
	}

	@Test
	public void speakEasy() throws Throwable {
		System.out.println("Test - speakEasy");
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize("<s>small sentence<break time=\"250ms\"></break></s>", null, null,
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
	}
	
	@Test
	public void speakEasyWithVoiceNotNull() throws Throwable {
		System.out.println("Test - speakEasyWithVoiceNotNull");
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize("<s>small sentence<break time=\"250ms\"></break></s>", null, new Voice("aws", "Lotte"),
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
	}

	@Test
	public void speakWithVoices() throws Throwable {
		System.out.println("Test - speakWithVoices");
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();

		Set<Integer> sizes = new HashSet<Integer>();
		int totalVoices = 0;
		Iterator<Voice> ite = engine.getAvailableVoices().iterator();
		while (ite.hasNext()) {
			Voice v = ite.next();
			Collection<AudioBuffer> li = engine.synthesize("<s>small sentence</s>", null, v, resource,
					null, null, BufferAllocator, false);
			sizes.add(getSize(li) / 4); //div 4 helps being more robust to tiny differences
			totalVoices++;
		}
		engine.releaseThreadResources(resource);

		//this number will be very low if the voice names are not properly retrieved
		float diversity = Float.valueOf(sizes.size()) / totalVoices;

		Assert.assertTrue(diversity > 0.4);
	}

	@Test
	public void speakUnicode() throws Throwable {
		System.out.println("Test - speakUnicode");
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize(
		        "<s>𝄞𝄞𝄞𝄞 水水水水水 𝄞水𝄞水𝄞水𝄞水 test 国Ø家Ť标准 ĜæŘ ß ŒÞ ๕</s>", null, null,
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
	}

	@Test
	public void multiSpeak() throws Throwable {
		System.out.println("Test - multiSpeak");
		final AWSRestTTSEngine engine = allocateEngine();

		// there is some limitation on the number of thread that can be used with amazon
		// (the server returns a 400 error when more than 4 threads are used) 
		final int[] sizes = new int[4];
		Thread[] threads = new Thread[sizes.length];
		for (int i = 0; i < threads.length; ++i) {
			final int j = i;
			threads[i] = new Thread() {
				public void run() {
					TTSResource resource = null;
					try {
						resource = engine.allocateThreadResources();
					} catch (SynthesisException | InterruptedException e) {
						return;
					}

					Collection<AudioBuffer> li = null;
					for (int k = 0; k < 16; ++k) {
						try {
							li = engine.synthesize("<s>small test</s>", null, null, resource, null, null, BufferAllocator, false);

						} catch (SynthesisException | InterruptedException | MemoryException e) {
							e.printStackTrace();
							break;
						}
						sizes[j] += getSize(li);
					}
					try {
						engine.releaseThreadResources(resource);
					} catch (SynthesisException | InterruptedException e) {
					}
				}
			};
		}

		for (Thread th : threads)
			th.start();

		for (Thread th : threads)
			th.join();

		for (int size : sizes) {
			Assert.assertEquals(sizes[0], size);
		}
	}
	
	@Test(expected=SynthesisException.class)
	public void tooBigSentence() throws Throwable {
		System.out.println("Test - tooBigSentence");
		String sentence = "<s>";
		for (int i = 0 ; i < 3001; i++) {
			sentence += 'a';
		}
		sentence += "</s>";
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize(sentence, null, null,resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
	
	@Test(expected=SynthesisException.class)
	public void tooBigSentenceBecauseOfTags() throws Throwable {
		System.out.println("Test - tooBigSentenceBecauseOfTags");
		String sentence = "<s>";
		for (int i = 0 ; i < 2000; i++) {
			sentence += "<s>a</s>";
		}
		sentence += "</s>";
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize(sentence, null, null,resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
	
	@Test
	public void adaptedSentence() throws Throwable {
		System.out.println("Test - adaptedSentence");
		String sentence = "<s>I can pause <break time=\"3s\"/>.</s>";
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize(sentence, null, null,resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
	
	@Test
	public void speakWithMark() throws Throwable {
		System.out.println("Test - speakWithMark");
		AWSRestTTSEngine engine = allocateEngine();
		List<Mark> marks = new ArrayList<>();

		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize("<s>small sentence<mark name=\"test\"/></s>", null, null,
		        resource, marks, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
		Assert.assertTrue(marks.size() == 1);
		Assert.assertTrue(marks.get(0).name.equals("test"));
	}
	
	@Test(expected=SynthesisException.class)
	public void speakWithEmptyListMarks() throws Throwable {
		System.out.println("Test - speakWithEmptyListMarks");
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize("<s>small sentence<mark name=\"test\"/></s>", null, null,
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
		
}
