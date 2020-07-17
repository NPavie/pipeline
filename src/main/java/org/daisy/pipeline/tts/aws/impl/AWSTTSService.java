package org.daisy.pipeline.tts.aws.impl;

import java.util.Map;

import javax.sound.sampled.AudioFormat;

import org.daisy.pipeline.tts.AbstractTTSService;
import org.daisy.pipeline.tts.TTSEngine;
import org.daisy.pipeline.tts.TTSService;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;

@Component(
		name = "aws-tts-service",
		service = { TTSService.class }
		)
public class AWSTTSService extends AbstractTTSService {

	@Activate
	protected void loadSSMLadapter() {
		super.loadSSMLadapter("/transform-ssml.xsl", AWSTTSService.class);
	}

	@Override
	public TTSEngine newEngine(Map<String, String> params) throws Throwable {
		
		String accessKey = params.get("org.daisy.pipeline.tts.aws.accesskey");
		String secretKey = params.get("org.daisy.pipeline.tts.aws.secretkey");
		String region = params.get("org.daisy.pipeline.tts.aws.region");
		
		//int sampleRate = convertToInt(params, "org.daisy.pipeline.tts.aws.samplerate", 22050);
		
		int priority = convertToInt(params, "org.daisy.pipeline.tts.aws.priority", 17);

		AudioFormat audioFormat = new AudioFormat((float) 22050, 16, 1, true, false);
		
		AWSRequestScheduler scheduler = new AWSRequestScheduler();
		
		return new AWSRestTTSEngine(this, audioFormat, accessKey, secretKey, region, scheduler, priority);

	}

	@Override
	public String getName() {
		return "aws";
	}

	@Override
	public String getVersion() {
		return "cli";
	}
	
	private static int convertToInt(Map<String, String> params, String prop, int defaultVal)
	        throws SynthesisException {
		String str = params.get(prop);
		if (str != null) {
			try {
				defaultVal = Integer.valueOf(str);
			} catch (NumberFormatException e) {
				throw new SynthesisException(str + " is not a valid a value for property "
				        + prop);
			}
		}
		return defaultVal;
	}

}
