# Ideas

 Some ideas i have to optimize autonomous launch of the pipeline and reduce overhead, expanding on the advantages of the modular structure of the pipeline for the oneshot script launch (SaveAsDAISY in embedded mode, maybe wordToEPUB, and other projects that cannot or prefer not to use the pipeline in webserver mode)
 - Optmize class loaded in the JVM and reduce service activation by simply not referencing in the class path unrequired modules or utilities, for example :
   - put all tts adapters and their dependencies in a "shared/tts-adapters" folder and only load those in the runtime classpath when the "tts option" is set to true in the script launch
   - put each script and its required dependencies in a "scripts/script-name" folder, and only load those in runtime when the script is selected
   - for each script, build a "required-jars.txt" file that would list only required jars to be passed at runtime using the [java9+ argument file feature](https://docs.oracle.com/javase/9/tools/java.htm#JSWOR-GUID-4856361B-8BFD-4964-AE84-121F5F6CF111)
- 

some additionnal resources on launch optimisation : https://medium.com/@kiarash.shamaii/optimizing-java-performance-42919a64a989