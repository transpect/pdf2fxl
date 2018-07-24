<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:template match="@*|*">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*,  node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="body">
        <xsl:copy>
            <xsl:apply-templates select="//div[a[matches(@id, 'page')]]">
                <xsl:sort select="a/@id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>-->
    
    <xsl:template match="body">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="//div[matches(@id, 'page')]">
                <xsl:sort select="@id"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>