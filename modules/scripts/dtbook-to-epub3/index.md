<link rev="dp2:doc" href="src/main/resources/xml/dtbook-to-epub3.xpl"/>
<link rel="rdf:type" href="http://www.daisy.org/ns/pipeline/userdoc"/>
<meta property="dc:title" content="DTBook to EPUB3"/>

# DTBook to EPUB3

Converts multiple dtbooks to epub3 format

## Synopsis

{{>synopsis}}

## Example running from command line

On Linux and Mac OS X:

    


On Windows:

    

This command will create two entries in the output directory. One is a folder called "epub", which is a temporary directory created by the converter. The second is the resulting EPUB 3 file. The EPUB 3 file is given a name based on the dc:identifier and dc:title metadata elements from the original NCC; "dc:identifier - dc:title.epub".



