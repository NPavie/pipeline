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

public class AWSTTSTest {

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
		return (AWSRestTTSEngine) s.newEngine(new HashMap<String, String>());
	}
	
	@Test
	public void convertToIntWithGivenParams() throws Throwable {
		Map<String, String> params = new HashMap<>();
		params.put("org.daisy.pipeline.tts.aws.priority", "20");
		AWSTTSService s = new AWSTTSService();
		s.newEngine(params);
	}
	
	@Test(expected=SynthesisException.class)
	public void convertToIntWithNotValidParams() throws Throwable {
		Map<String, String> params = new HashMap<>();
		params.put("org.daisy.pipeline.tts.aws.priority", "2T0");
		AWSTTSService s = new AWSTTSService();
		s.newEngine(params);
	}

	@Test
	public void getVoiceInfo() throws Throwable {
		Collection<Voice> voices = allocateEngine().getAvailableVoices();
		Assert.assertTrue(voices.size() > 50);
	}

	@Test
	public void speakEasy() throws Throwable {
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize("<s>small sentence<break time=\"250ms\"></break></s>", null, null,
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
	}
	
	@Test
	public void speakEasyWithVoiceNotNull() throws Throwable {
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		Collection<AudioBuffer> li = engine.synthesize("<s>small sentence<break time=\"250ms\"></break></s>", null, new Voice("aws", "Lotte"),
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);

		Assert.assertTrue(getSize(li) > 2000);
	}

	@Test
	public void speakWithVoices() throws Throwable {
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
		final AWSRestTTSEngine engine = allocateEngine();

		final int[] sizes = new int[16];
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
		String sentence = "<s>I can pause <break time=\"3s\"/>.</s>";
		AWSRestTTSEngine engine = allocateEngine();
		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize(sentence, null, null,resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
	
	@Test
	public void speakWithMark() throws Throwable {
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
		AWSRestTTSEngine engine = allocateEngine();

		TTSResource resource = engine.allocateThreadResources();
		engine.synthesize("<s>small sentence<mark name=\"test\"/></s>", null, null,
		        resource, null, null, BufferAllocator, false);
		engine.releaseThreadResources(resource);
	}
		
}
