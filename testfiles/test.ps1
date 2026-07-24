# Rebuild word to dtbook
mvn -s C:\Users\admin\devs\_Perso\pipeline\settings.xml -f C:\Users\admin\devs\_Perso\pipeline\modules\scripts\word-to-dtbook\pom.xml clean package -DskipTests

# rebuild assembly with simple api
mvn -s C:\Users\admin\devs\_Perso\pipeline\settings.xml -f C:\Users\admin\devs\_Perso\pipeline\assembly\pom.xml clean package -DskipTests -Pwith-simple-api

Copy-Item   -Path C:\Users\admin\devs\_Perso\pipeline\modules\scripts\word-to-dtbook\target\word-to-dtbook-1.1.2.jar `
            -Destination C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\system\common\org.daisy.pipeline.modules.word-to-dtbook-1.1.2.jar

Remove-Item "C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\system\simple-api" -Recurse -Force
Copy-Item   -Path C:\Users\admin\devs\_Perso\pipeline\assembly\target\simple-api `
            -Destination C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\system\ `
            -Recurse -Force

Copy-Item   -Path C:\Users\admin\devs\_Perso\pipeline\assembly\src\main\resources\bin\pipeline2.bat`
            -Destination C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\bin\pipeline2.bat `
            -Recurse -Force

Remove-Item "C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\test" -Recurse -Force

# Print start date and time with milliseconds precision
$dateFormat = New-Object System.Globalization.CultureInfo("en-US")
$dateFormat.DateTimeFormat.ShortDatePattern = "yyyy-MM-dd"
$dateFormat.DateTimeFormat.LongTimePattern = "HH:mm:ss.fff"
Write-Output ((Get-Date).ToString("yyyy-MM-dd'T'HH:mm:ss.fff", $dateFormat) + " : Launching simple cli from command line ")

# &"C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\bin\simplecli.bat" `
#    word-to-dtbook `
#    --source "C:\Users\admin\devs\_Perso\pipeline\testfiles\default_sample_for_dtbook_conversion.docx" `
#    --result "C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\test"

&"C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\bin\pipeline2.bat" `
   "-Dorg.daisy.pipeline.ocr.mistral.apikey" "4yhuRHwEDH1ffkS2lH8YBb7UDvSAacnK" `
   ui `
   word-to-dtbook `
   --source "C:\Users\admin\devs\_Perso\pipeline\testfiles\default_sample_for_dtbook_conversion.docx" `
   --result "C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\test"

# 9791028536817_SanteMentaleTousConcernes.docx
# &"C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\bin\simplecli.bat" `
#     word-to-dtbook `
#     --source "C:\Users\admin\AppData\Local\Temp\miekkq0q.fn4\9791097150501_FemmeDeCoquilles.docx" `
#     --title "Femme de coquilles" `
#     --publisher "Terres de l’Ouest" `
#     --uid "" `
#     --subject "" `
#     --accept-revisions "false" `
#     --pagination "custom" `
#     --image-size "original" `
#     --character-styles "false" `
#     --footnotes-position "inline" `
#     --footnotes-numbering "none" `
#     --footnotes-start-value "1" `
#     --extract-shapes "false" `
#     --repair "true" `
#     --tidy "true" `
#     --result "C:\Users\admin\Documents\SaveAsDAISY Results\9791097150501_FemmeDeCoquilles_word-to-dtbook_202604011015585337" `
#     --narrator "false" `
#     --ApplySentenceDetection "false"

#<!--Importing library.xsl for using common pipeline extension functions (like pf:info)
#	xmlns:pf="http://www.daisy.org/ns/pipeline/functions"
#	-->
#	<!-- <xsl:include href="http://www.daisy.org/pipeline/modules/common-utils/library.xsl"/> -->
#               <!-- <xsl:call-template name="pf:info">
#					<xsl:with-param name="msg">
#						Converting element {} - {} / {}
#					</xsl:with-param>
#					<xsl:with-param name="args" select="(name(),position(),$ElementCountToConvert)"/>
#				</xsl:call-template> -->
#				<!-- <xsl:call-template name="pf:progress">
#					<xsl:with-param name="progress" select="concat(string(position()+1),'/',string($ElementCountToConvert))"/>
#				</xsl:call-template> -->
#				<!-- <xsl:message terminate="no">progress:Converting element <xsl:value-of select="name()"/> - <xsl:value-of select="position()"/> / <xsl:value-of select="$ElementCountToConvert"/></xsl:message> -->
# Issue with a title that took 16G of RAM !

#  &"C:\Users\admin\devs\_Perso\pipeline\pipeline2-1.15.4_sad\daisy-pipeline\bin\simplecli.bat" `
#      word-to-dtbook `
# --source "C:\Users\admin\devs\_Perso\pipeline\testfiles\9791036384592_TrilogieDesGemmesT2_BleuSaphir.docx" --title "La Trilogie des gemmes, tome 2 : Bleu saphir" --publisher "Bayard Jeunesse" --uid "" --subject "" --accept-revisions "false" --pagination "custom" --image-size "original" --character-styles "false" --footnotes-position "inline" --footnotes-numbering "none" --footnotes-start-value "1" --extract-shapes "false" --repair "true" --tidy "true" --result "C:\Users\admin\Documents\SaveAsDAISY Results\9791036384592_TrilogieDesGemmesT2_BleuSaphir_word-to-dtbook_202604031046511980" --narrator "false" --ApplySentenceDetection "false"