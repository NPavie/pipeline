package org.daisy.pipeline.tts.aws.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collection;

import javax.sound.sampled.AudioFormat;

import net.sf.saxon.s9api.XdmNode;

//import org.apache.log4j.PropertyConfigurator;
import org.daisy.pipeline.audio.AudioBuffer;
import org.daisy.pipeline.tts.AudioBufferAllocator;
import org.daisy.pipeline.tts.AudioBufferAllocator.MemoryException;
import org.daisy.pipeline.tts.MarklessTTSEngine;
import org.daisy.pipeline.tts.TTSRegistry.TTSResource;
import org.daisy.pipeline.tts.TTSService.SynthesisException;
import org.daisy.pipeline.tts.Voice;

/*import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.services.polly.AmazonPolly;
import com.amazonaws.services.polly.AmazonPollyClientBuilder;
import com.amazonaws.services.polly.model.DescribeVoicesRequest;
import com.amazonaws.services.polly.model.DescribeVoicesResult;
import com.amazonaws.services.polly.model.OutputFormat;
import com.amazonaws.services.polly.model.SynthesizeSpeechRequest;
import com.amazonaws.services.polly.model.SynthesizeSpeechResult;
import com.amazonaws.services.polly.model.TextType;
import com.amazonaws.services.polly.model.VoiceId;*/

public class AWSTTSEngine extends MarklessTTSEngine {

	private AudioFormat mAudioFormat;
	private RequestScheduler mRequestScheduler;
	private int mPriority;
	private String mAccessKey;
	private String mSecretKey;
	private String mRegion;
	
	public AWSTTSEngine(AWSTTSService awsService, AudioFormat audioFormat, String accessKey, String secretKey, 
			String region, RequestScheduler requestScheduler, int priority) {
		super(awsService);
		mPriority = priority;
		mAudioFormat = audioFormat;
		mRequestScheduler = requestScheduler;
		mAccessKey = "AKIAJUWCEFT47BE2VBEA";
		mSecretKey = "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";
		mRegion = "eu-west-3"; 
	}
	
	@Override
	public int expectedMillisecPerWord() {
		return 64000;
	}

	@Override
	public Collection<AudioBuffer> synthesize(String sentence, XdmNode xmlSentence,
			Voice voice, TTSResource threadResources, AudioBufferAllocator bufferAllocator, boolean retry)
					throws SynthesisException,InterruptedException, MemoryException {
		
		if (sentence.length() > 5000) { // CB pour AWS ??
			throw new SynthesisException("The number of characters in the sentence must not exceed 5000.");
		}

		Collection<AudioBuffer> result = new ArrayList<AudioBuffer>();

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
		
		/*BasicAWSCredentials awsCredentials = new BasicAWSCredentials(mAccessKey, mSecretKey);

	    AmazonPolly client = AmazonPollyClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(awsCredentials))
	            .withRegion(mRegion)
	            .build();
	    
		DescribeVoicesRequest allVoicesRequest = new DescribeVoicesRequest();
		String nextToken;
		
        do {
            DescribeVoicesResult allVoicesResult = client.describeVoices(allVoicesRequest);
            nextToken = allVoicesResult.getNextToken();
            allVoicesRequest.setNextToken(nextToken);
            
            for (com.amazonaws.services.polly.model.Voice voice : allVoicesResult.getVoices()) {
            	result.add(new Voice(getProvider().getName(), voice.getId()));
            }

        } while (nextToken != null);
        
        client.shutdown();*/

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

	/*public static void main (String[] args) throws Exception {
		
		String log4jConfPath = "/Users/louiscaille/tts-adapter-amazon/log4j.properties";
		PropertyConfigurator.configure(log4jConfPath);

		BasicAWSCredentials awsCredentials = new BasicAWSCredentials(
				"AKIAJUWCEFT47BE2VBEA", "9KfFa4WXOpvG4aWO6JZ88AulBpDXxTuXkMXXMe+I");

		AmazonPolly client = AmazonPollyClientBuilder.standard()
				.withCredentials(
						new AWSStaticCredentialsProvider(awsCredentials))
				.withRegion("eu-west-3")
				.build();

		DescribeVoicesRequest allVoicesRequest = 
				new DescribeVoicesRequest();

		try {		
			String nextToken;
			do {
				DescribeVoicesResult allVoicesResult = 
						client.describeVoices(allVoicesRequest);
				nextToken = allVoicesResult.getNextToken();
				allVoicesRequest.setNextToken(nextToken);
				System.out.println(allVoicesResult.getVoices());
			} while (nextToken != null);	
			client.shutdown();	
		} catch (Exception e) {
			e.printStackTrace();
		}

	}*/

	/*public static void main (String[] args) throws Exception {
		
		String log4jConfPath = "/Users/louiscaille/tts-adapter-amazon/log4j.properties";
		PropertyConfigurator.configure(log4jConfPath);

		BasicAWSCredentials awsCreds = new BasicAWSCredentials("AKIAJUWCEFT47BE2VBEA", "9KfFa4WXOpvG4aWO6JZ88AulBpDXxTuXkMXXMe+I");

	    AmazonPolly client = AmazonPollyClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
	            .withRegion("eu-west-3")
	            .build();

		String outputFileName = "speech.mp3";

		SynthesizeSpeechRequest synthesizeSpeechRequest = new SynthesizeSpeechRequest()
				.withOutputFormat(OutputFormat.Mp3)
				.withVoiceId(VoiceId.Joanna)
				.withTextType(TextType.Ssml)
				.withText("<s>Hello there.</s>");

		try (FileOutputStream outputStream = new FileOutputStream(new File(outputFileName))) {
			SynthesizeSpeechResult synthesizeSpeechResult = client.synthesizeSpeech(synthesizeSpeechRequest);
			byte[] buffer = new byte[2 * 1024];
			int readBytes;

			try (InputStream in = synthesizeSpeechResult.getAudioStream()){
				while ((readBytes = in.read(buffer)) > 0) {
					outputStream.write(buffer, 0, readBytes);
				}
			}

		} catch (Exception e) {
			System.err.println("Exception caught: " + e);
		}

		client.shutdown();

	}*/
	
	/*public static void main (String[] args) throws Exception {
		
		BasicAWSCredentials awsCreds = new BasicAWSCredentials("AKIAJUWCEFT47BE2VBEA", "9KfFa4WXOpvG4aWO6JZ88AulBpDXxTuXkMXXMe+I");

	    AmazonPollyClient client = (AmazonPollyClient) AmazonPollyClientBuilder.standard()
	            .withCredentials(new AWSStaticCredentialsProvider(awsCreds))
	            .withRegion("eu-west-3")
	            .build();

		String outputFileName = "speech.json";

		SynthesizeSpeechRequest synthesizeSpeechRequest = new SynthesizeSpeechRequest()
				.withOutputFormat(OutputFormat.Json)
                .withSpeechMarkTypes(SpeechMarkType.Viseme, SpeechMarkType.Word)
				.withVoiceId(VoiceId.Joanna)
				.withTextType(TextType.Ssml)
				.withText("<s>Hello <mark name=\'here\'/>.</s>");

		try (FileOutputStream outputStream = new FileOutputStream(new File(outputFileName))) {
			SynthesizeSpeechResult synthesizeSpeechResult = client.synthesizeSpeech(synthesizeSpeechRequest);
			byte[] buffer = new byte[2 * 1024];
			int readBytes;

			try (InputStream in = synthesizeSpeechResult.getAudioStream()){
				while ((readBytes = in.read(buffer)) > 0) {
					outputStream.write(buffer, 0, readBytes);
				}
			}

		} catch (Exception e) {
			System.err.println("Exception caught: " + e);
		}

		client.shutdown();

	}*/
	
}