# Amazon Polly tts adapter

To use this adapter, please follow the [instructions](https://docs.aws.amazon.com/polly/latest/dg/getting-started.html) as given by Amazon : 
1. [Set Up an AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html?nc2=h_ct&src=default) and Create a User.
2. [Create an access key](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) from the IAM pannel.

The following parameters must then be set in the pipeline configuration to start using it :
 - `org.daisy.pipeline.tts.aws.accesskey` with the access key generated  
 - `org.daisy.pipeline.tts.aws.secretkey` with the secret key provided with the access key
 - `org.daisy.pipeline.tts.aws.region` the geographic region of the server to use (check [endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/pol.html) for the list of region)
 
 
## Running tests

To run the tests, the previous parameters must be defined as system properties.
Please define them in your pom, or (preferably) pass them to the command line when building the module with maven :

```
maven test -Dorg.daisy.pipeline.tts.aws.accesskey="your_key" ...
```

