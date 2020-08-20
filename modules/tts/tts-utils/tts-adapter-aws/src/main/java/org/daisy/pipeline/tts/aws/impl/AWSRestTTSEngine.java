package org.daisy.pipeline.tts.aws.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.sound.sampled.AudioFormat;

import net.sf.saxon.s9api.XdmNode;

import org.apache.commons.io.IOUtils;
import org.daisy.pipeline.audio.AudioBuffer;
import org.daisy.pipeline.tts.AudioBufferAllocator;
import org.daisy.pipeline.tts.AudioBufferAllocator.MemoryException;
import org.daisy.pipeline.tts.SoundUtil;
import org.daisy.pipeline.tts.TTSEngine;
import org.daisy.pipeline.tts.TTSRegistry.TTSResource;
import org.daisy.pipeline.tts.TTSService.Mark;
import org.daisy.pipeline.tts.TTSService.SynthesisException;
import org.daisy.pipeline.tts.Voice;
import org.daisy.pipeline.tts.rest.Request;
import org.daisy.pipeline.tts.scheduler.FatalError;
import org.daisy.pipeline.tts.scheduler.RecoverableError;
import org.daisy.pipeline.tts.scheduler.Schedulable;
import org.daisy.pipeline.tts.scheduler.Scheduler;
import org.daisy.pipeline.tts.scheduler.impl.ExponentialBackoffScheduler;

/**
 * Connector class to synthesize audio using the amazon polly engine.
 * This connector is based on their REST Api.
 * 
 * @author Louis Caille @ braillenet.org
 *
 */
public class AWSRestTTSEngine extends TTSEngine {

	private AudioFormat mAudioFormat;
	private Scheduler<Schedulable> mRequestScheduler;
	private int mPriority;
	private AWSRequestBuilder mRequestBuilder;
	
	public AWSRestTTSEngine(AWSTTSService awsService, AudioFormat audioFormat, String accessKey, String secretKey, 
			String region, int priority) {
		super(awsService);
		mPriority = priority;
		mAudioFormat = audioFormat;
		mRequestScheduler = new ExponentialBackoffScheduler<Schedulable>();
		mRequestBuilder = new AWSRequestBuilder(accessKey, secretKey, region, mAudioFormat.getSampleRate(), "ssml");
	}

	@Override
	public Collection<AudioBuffer> synthesize(String sentence, XdmNode xmlSentence, Voice voice,
			TTSResource threadResources, List<Mark> marks, List<String> expectedMarks,
			AudioBufferAllocator bufferAllocator, boolean retry)
					throws SynthesisException, InterruptedException, MemoryException {

		if (sentence.length() > 6000 || nbCharCharged(sentence) > 3000) {
			throw new SynthesisException("The number of characters in the sentence must not exceed 3000. The tags are not taken into account");
		}

		Collection<AudioBuffer> result = new ArrayList<AudioBuffer>();

		// the sentence must be in an appropriate format to be inserted in the json query
		// it is necessary to wrap the sentence in quotes and add backslash in front of the existing quotes

		String adaptedSentence = "";

		for (int i = 0; i < sentence.length(); i++) {
			if (sentence.charAt(i) == '"') {
				adaptedSentence = adaptedSentence + '\\' + sentence.charAt(i);
			}
			else {
				adaptedSentence = adaptedSentence + sentence.charAt(i);
			}
		}

		String name;

		if (voice != null) {
			name = voice.name;
		}
		else {
			// by default the voice is set to en-US
			name = "Joey";
		}
		
		try {
			for (Mark mark : getMarksData(adaptedSentence, name)) {
				marks.add(mark);
			}
		} catch (Exception e) {
			throw new SynthesisException(e.getMessage(), e.getCause());
		}

		try {

			Request speechRequest = mRequestBuilder.newRequest()
					.withAction(AWSRestAction.SPEECH)
					.withOutputFormat("pcm")
					.withSpeechMarksTypes(new ArrayList<>())
					.withText(adaptedSentence)
					.withVoice(name)
					.build();

			mRequestScheduler.launch(()->{
				try {
					byte[] bytes = IOUtils.toByteArray(speechRequest.send());

					AudioBuffer b = bufferAllocator.allocateBuffer(bytes.length);
					b.data = bytes;
					result.add(b);
				} catch (IOException | MemoryException e) {
					try {
						if (speechRequest.getConnection().getResponseCode() == 429) {
							throw new RecoverableError("Exceeded quotas", e);
						} else {
							throw new FatalError(e);
						}
					} catch (IOException responseCodeError) {
						throw new FatalError("could not retrieve response code for request", responseCodeError);
					}
				}
				
			});

		} catch (Exception e) { // include FatalError
			SoundUtil.cancelFootPrint(result, bufferAllocator);
			StringWriter sw = new StringWriter();
			e.printStackTrace(new PrintWriter(sw));
			throw new SynthesisException(e.getMessage(), e.getCause());
		} 

		return result;
	}

	@Override
	public AudioFormat getAudioOutputFormat() {
		return mAudioFormat;
	}

	@Override
	public Collection<Voice> getAvailableVoices() throws SynthesisException,
	InterruptedException {

		Collection<Voice> result = new ArrayList<Voice>();
		
		try {

			Request voicesRequest = mRequestBuilder.newRequest()
					.withAction(AWSRestAction.VOICES)
					.build();

			mRequestScheduler.launch(()->{
				try {
					BufferedReader br = new BufferedReader(new InputStreamReader(voicesRequest.send(), "utf-8"));
					StringBuilder response = new StringBuilder();
					String inputLine;
					while ((inputLine = br.readLine()) != null) {
						response.append(inputLine.trim());
					}
					br.close();

					// we retrieve the names of the voices in the response returned by the API
					Pattern p = Pattern .compile("\"Id\":\"\\p{L}+\"");
					Matcher m = p.matcher(response);
					String s = "";
					String name = "";

					while (m.find()) {
						s = response.substring(m.start(), m.end());
						name = s.substring(6,s.length()-1);
						result.add(new Voice(getProvider().getName(),name));
					}
				} catch (IOException e) {
					try {
						if (voicesRequest.getConnection().getResponseCode() == 429) {
							throw new RecoverableError("Exceeded quotas", e);
						} else {
							throw new FatalError(e);
						}
					} catch (IOException responseCodeError) {
						throw new FatalError("could not retrieve response code for request", responseCodeError);
					}
				}
				
			});

		} catch (Throwable e) {
			throw new SynthesisException(e.getMessage(), e.getCause());
		}

		// we loop until the request has not been processed 
		// (aws limits to 80 requests per minute or 15000 characters)
//		while(isNotDone) {
//
//			try {
//				
//				request = mRequestScheduler.poll(requestUuid);
//
//				BufferedReader br = new BufferedReader(new InputStreamReader(request.send(), "utf-8"));
//				StringBuilder response = new StringBuilder();
//				String inputLine;
//				while ((inputLine = br.readLine()) != null) {
//					response.append(inputLine.trim());
//				}
//				br.close();
//
//				// we retrieve the names of the voices in the response returned by the API
//				Pattern p = Pattern .compile("\"Id\":\"\\p{L}+\"");
//				Matcher m = p.matcher(response);
//				String s = "";
//				String name = "";
//
//				while (m.find()) {
//					s = response.substring(m.start(), m.end());
//					name = s.substring(6,s.length()-1);
//					result.add(new Voice(getProvider().getName(),name));
//				}
//
//				isNotDone = false;
//
//			} catch (Throwable e1) {
//
//				try {
//					if (request.getConnection().getResponseCode() == 429) {
//						// if the error "too many requests" is raised
//						requestUuid = mRequestScheduler.add(request);
//						mRequestScheduler.delay(requestUuid);
//					}
//					else {
//						throw new SynthesisException(e1.getMessage(), e1.getCause());
//					}
//				} catch (Exception e2) {
//					throw new SynthesisException(e2.getMessage(), e2.getCause());
//				}
//
//			}
//
//		}

		return result;

	}

	@Override
	public int getOverallPriority() {
		return mPriority;
	}

	@Override
	public TTSResource allocateThreadResources() throws SynthesisException,
	InterruptedException {
		return new TTSResource();
	}
	
	@Override
	public int expectedMillisecPerWord() {
		return 64000;
	}
	
	@Override
	public String endingMark() {
		return "ending-mark";
	}

	private List<Mark> getMarksData(String adaptedSentence, String voiceName) throws Exception {

		List<Mark> marks = new ArrayList<>();

		List<String> speechMarksTypes = new ArrayList<>();
		speechMarksTypes.add("ssml");
		

		try {

			Request marksRequest = mRequestBuilder.newRequest()
					.withAction(AWSRestAction.SPEECH)
					.withOutputFormat("json")
					.withSpeechMarksTypes(speechMarksTypes)
					.withText(adaptedSentence)
					.withVoice(voiceName)
					.build();

			mRequestScheduler.launch(()->{
				try {
					BufferedReader br = new BufferedReader(new InputStreamReader(marksRequest.send(), "utf-8"));
					StringBuilder response = new StringBuilder();
					String inputLine;
					while ((inputLine = br.readLine()) != null) {
						response.append(inputLine.trim());
					}
					br.close();
	
					Pattern pSingleMark = Pattern .compile("\\{[^\\}]*\\}");
					Matcher mSingleMark = pSingleMark.matcher(response);
	
					Pattern pTime = Pattern.compile("\"time\":[0-9]*");
					Pattern pValue = Pattern.compile("\"value\":[^\\}]*");
	
					while (mSingleMark.find()) {
						String singleMark = response.substring(mSingleMark.start(), mSingleMark.end());
	
						Matcher mTime = pTime.matcher(singleMark);
						mTime.find();
						// + 7 to start after "time":
						int timeInMilliSeconds = Integer.parseInt(singleMark.substring(mTime.start() + 7, mTime.end()));
						// for amazon raw PCM data, 
						// - default sample rate is 16khz 
						// - default sample size is 2 bytes (16bits)
						// - only 1 channel is used
						int offset = (int) (
								timeInMilliSeconds * 0.001 * 
								mAudioFormat.getSampleRate() * 
								mAudioFormat.getChannels() * 
								mAudioFormat.getSampleSizeInBits() * 0.125
								);
	
						Matcher mValue = pValue.matcher(singleMark);
						mValue.find();
						// + 9 to start after "value":" & - 1 to stop before "
						String value = singleMark.substring(mValue.start() + 9, mValue.end() - 1);
	
						marks.add(new Mark(value, offset));	
					}
				}catch (IOException e) {
					try {
						if (marksRequest.getConnection().getResponseCode() == 429) {
							throw new RecoverableError("Exceeded quotas", e);
						} else {
							throw new FatalError("Not handled error code : " + marksRequest.getConnection().getResponseCode(),e);
						}
					} catch (IOException responseCodeError) {
						throw new FatalError("could not retrieve response code for request", responseCodeError);
					}
				}
			});

		} catch (Throwable e) {
			throw new SynthesisException(e.getMessage(), e.getCause());
		}

		// we loop until the request has not been processed 
		// (aws limits to 80 requests per minute or 15000 characters)
//		while(isNotDone) {
//
//			try {
//				
//				request = mRequestScheduler.poll(requestUuid);
//
//				BufferedReader br = new BufferedReader(new InputStreamReader(request.send(), "utf-8"));
//				StringBuilder response = new StringBuilder();
//				String inputLine;
//				while ((inputLine = br.readLine()) != null) {
//					response.append(inputLine.trim());
//				}
//				br.close();
//
//				Pattern pSingleMark = Pattern .compile("\\{[^\\}]*\\}");
//				Matcher mSingleMark = pSingleMark.matcher(response);
//
//				Pattern pTime = Pattern.compile("\"time\":[0-9]*");
//				Pattern pValue = Pattern.compile("\"value\":[^\\}]*");
//
//				while (mSingleMark.find()) {
//					String singleMark = response.substring(mSingleMark.start(), mSingleMark.end());
//
//					Matcher mTime = pTime.matcher(singleMark);
//					mTime.find();
//					// + 7 to start after "time":
//					int timeInMilliSeconds = Integer.parseInt(singleMark.substring(mTime.start() + 7, mTime.end()));
//					// for amazon raw PCM data, 
//					// - default sample rate is 16khz 
//					// - default sample size is 2 bytes (16bits)
//					// - only 1 channel is used
//					int offset = (int) (
//							timeInMilliSeconds * 0.001 * 
//							mAudioFormat.getSampleRate() * 
//							mAudioFormat.getChannels() * 
//							mAudioFormat.getSampleSizeInBits() * 0.125
//							);
//
//					Matcher mValue = pValue.matcher(singleMark);
//					mValue.find();
//					// + 9 to start after "value":" & - 1 to stop before "
//					String value = singleMark.substring(mValue.start() + 9, mValue.end() - 1);
//
//					marks.add(new Mark(value, offset));	
//				}
//
//				isNotDone = false;
//
//			} catch (Throwable e1) {
//
//				try {
//					if (request.getConnection().getResponseCode() == 429) {
//						requestUuid = mRequestScheduler.add(request);
//						// if the error "too many requests" is raised
//						mRequestScheduler.delay(requestUuid);
//					}
//					else {
//						throw new SynthesisException(e1.getMessage(), e1.getCause());
//					}
//				} catch (Exception e2) {
//					throw new SynthesisException(e2.getMessage(), e2.getCause());
//				}
//
//			}
//		}

		return marks;
	}

	// calculation of the number of characters charged by aws
	private static int nbCharCharged(String sentence) {
		int n = 0;
		int i = 0;
		boolean inTag = false;
		while (i<sentence.length()) {
			// start of a tag
			if (sentence.charAt(i) == '<') {
				inTag = true;
				i++;
			}
			// end of a tag
			else if (sentence.charAt(i) == '>') {
				inTag = false;
				i++;
			}
			// in a tag
			else if (inTag) {
				i++;
			}
			// characters charged
			else {
				n++;
				i++;
			}
		}
		return n;
	}

}