<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step type="px:fileset-compare" name="main"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:px="http://www.daisy.org/ns/pipeline/xproc"
                xmlns:pxi="http://www.daisy.org/ns/pipeline/xproc/internal"
                exclude-inline-prefixes="px pxi"
                version="1.0">
    
    <p:documentation xmlns="http://www.w3.org/1999/xhtml">
        <p>Compare two d:fileset documents.</p>
    </p:documentation>
    
    <p:input port="source" primary="true" px:media-type="application/x-pef+xml"/>
    <p:input port="alternate" px:media-type="application/x-pef+xml"/>
    <p:output port="result" primary="false" sequence="false">
        <p:pipe step="compare" port="result"/>
    </p:output>
    
    <p:option name="fail-if-not-equal" select="'false'"/>
    
    <p:declare-step type="pxi:normalize-fileset">
        <p:input port="source"/>
        <p:output port="result"/>
        <p:label-elements match="*[@href]" attribute="href" replace="true" label="resolve-uri(@href,base-uri(.))"/>
        <p:label-elements match="*[@original-href]" attribute="original-href" replace="true" label="resolve-uri(@href,base-uri(.))"/>
        <p:delete match="@xml:base"/>
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
                        <xsl:template match="/*">
                            <xsl:copy>
                                <xsl:sequence select="@*"/>
                                <xsl:apply-templates select="*">
                                    <xsl:sort select="@href"/>
                                </xsl:apply-templates>
                            </xsl:copy>
                        </xsl:template>
                        <xsl:template match="*">
                            <xsl:sequence select="."/>
                        </xsl:template>
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty/>
            </p:input>
        </p:xslt>
    </p:declare-step>
    
    <pxi:normalize-fileset name="normalize-source">
        <p:input port="source">
            <p:pipe step="main" port="source"/>
        </p:input>
    </pxi:normalize-fileset>
    
    <pxi:normalize-fileset name="normalize-alternate">
        <p:input port="source">
            <p:pipe step="main" port="alternate"/>
        </p:input>
    </pxi:normalize-fileset>
    
    <p:compare name="compare">
        <p:input port="source">
            <p:pipe step="normalize-source" port="result"/>
        </p:input>
        <p:input port="alternate">
            <p:pipe step="normalize-alternate" port="result"/>
        </p:input>
        <p:with-option name="fail-if-not-equal" select="$fail-if-not-equal"/>
    </p:compare>
    
</p:declare-step>
