<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:css="http://www.w3.org/1996/css" 
  xmlns="http://www.w3.org/1999/xhtml"
  exclude-result-prefixes="#all"
  version="2.0" 
  xpath-default-namespace="http://www.w3.org/1999/xhtml">
  
  <!-- serialization options, ignored when invoked over calabash -->
  <xsl:output
    method="xhtml" 
    encoding="UTF-8" 
    version="1.0"
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" 
    indent="yes"/>
  
  <xsl:strip-space elements="*"/>
  
  <!-- global params -->
  
  <!-- if the PDF page is rastered as image with ImageMagick before, we have to patch some file references -->
  <xsl:param name="rastertext" select="'no'" as="xs:string"/>
  
  <!-- Regular expression for paragraphs to be automatically dropped. -->
  <xsl:param name="false-para-regex" select="'^([0-9\.,:;\s]+)$'"/>
  
  <!-- Sequence that includes generated ids for all divs -->
  <xsl:variable name="page-id" select="for $i in //div return generate-id($i)"/>
  
  <!-- max string length of div ids -->
  <xsl:variable name="page-id-max-length" select="string-length(xs:string(count(//div)))"/>
  
	<!-- max string length of para ids -->
	<xsl:variable name="para-id-max-length" select="string-length(xs:string(count(//p)))"/>
    
  
	<!-- identity template with lower precedence -->
	<xsl:template match="@*|*">
    <xsl:copy copy-namespaces="no">
      <xsl:apply-templates select="@*, node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="html|head|body|meta">
    <xsl:apply-templates/>
  </xsl:template>
  
  <!-- generate basic html structure -->
  
  <xsl:template match="/">
    <html>
      <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <xsl:call-template name="viewport"/>
        <title>title</title>
        <style type="text/css">
          <xsl:call-template name="generate-css"/>
        </style>
      </head>
      <body>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="*:collection">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template name="viewport">
    <xsl:variable name="width" select="descendant::div[1]/img/@width"/>
    <xsl:variable name="height" select="descendant::div[1]/img/@height"/>
    <meta name="viewport" content="width={$width}, height={$height}"/>
  </xsl:template>
  
  
  <xsl:template match="div">
    <xsl:variable name="div-id" select="replace(@id, 'page(\d+)-div', '$1')"/>
    <xsl:variable name="id-length" select="string-length(xs:string($div-id))"/>
    <xsl:variable name="leading-zeros-string"
      select="string-join(for $i in ($id-length to $page-id-max-length - 1) return '0', '')"/>
    
    <xsl:copy copy-namespaces="no">
      <xsl:attribute name="id" select="concat('page-', $leading-zeros-string, $div-id)"/>
      <!-- generate page anchor -->
    	<a id="{concat('page_', $div-id)}"/>
    	<!-- generate blind title for table of contents -->
    	<h1 class="blind" title="{if(p[1]) then p[1] else @id}"/>
            
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="img"/>
  
  <xsl:template match="p">
    <xsl:copy copy-namespaces="no">
      <xsl:call-template name="generate-attributes"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

	<!-- dissolve paras that only contain whitespace -->
  <xsl:template match="p[matches(., '^&#160;$')]"/>

  <xsl:template match="p/text()">
    <xsl:variable name="replace-whitespace" 
      select="replace(
                    replace(., '^&#160;?(.+?)&#160;?$', '$1'),
                      '&#160;&#160;+',
                    ' ')" as="xs:string"/>
    <xsl:value-of select="$replace-whitespace"/>
  </xsl:template>
  

  <!-- insert missing whitespace, poppler seems to have sometimes problems with italics -->
  <xsl:template match="i">
    <xsl:copy copy-namespaces="no">
      <xsl:text>&#x20;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x20;</xsl:text>      
    </xsl:copy>
  </xsl:template>
  
  <!-- drop former style information -->
  <xsl:template match="style|@css:*|@style|@class|title"/>
  
  <!-- generates class attribute adding font name and id attribute that's referenced by CSS -->
  <xsl:template name="generate-attributes">
    <xsl:if test="@css:font-family">
      <xsl:variable name="font-name" select="@css:font-family"/>
      <xsl:attribute name="class" select="$font-name"/>
    </xsl:if>
        
    <xsl:variable name="div-id" select="replace(ancestor::div/@id, 'page(\d+)-div', '$1')"/>
    <xsl:variable name="para-id" select="for $i in parent::div//* return generate-id($i)"/>
    <xsl:variable name="id" select="index-of($para-id, generate-id())"/>
    <xsl:variable name="id-length" select="string-length(xs:string($id))"/>
    <!-- attach zero, iterate between current and max string length of the id -->
    <xsl:variable name="leading-zeros-string"
      select="string-join(for $i in ($id-length to $para-id-max-length - 1) return '0', '')"/>
    <xsl:variable name="id-value" select="concat('p-', $div-id, '-', $leading-zeros-string, $id)"/>
    <xsl:attribute name="id" select="$id-value"/>
  </xsl:template>
  
  <!-- generate stylesheet from individual css attributes -->
  <xsl:template name="generate-css">
    <xsl:variable name="css-blacklist" select="''"
      as="xs:string+"/>
    
    <!-- for each element with css-attribtues, generate id css selector and corresponding values -->
    <xsl:for-each select="//div/*">
      <xsl:variable name="div-id" select="replace(ancestor::div/@id, 'page(\d+)-div', '$1')"/>
      <xsl:variable name="element-id" select="for $i in parent::div//* return generate-id($i)"/>
      <xsl:variable name="id" select="index-of($element-id, generate-id())"/>
      <xsl:variable name="id-length" select="string-length(xs:string($id))"/>
      <!-- Iteration über Differenz der maximalen Stringlänge und aktuellen Stringlänge sowie Ausgabe jeweils einer Null -->
      <xsl:variable name="leading-zeros-string"
        select="string-join(for $i in ($id-length to $para-id-max-length - 1) return '0', '')"/>
      
      <xsl:variable name="filtered-css-properties"
        select="@css:*[every $i in $css-blacklist satisfies $i ne local-name()]" as="attribute()*"/>
      
      <xsl:variable name="patched-css-properties" as="attribute()*">
        <xsl:for-each select="@css:*">
          <xsl:attribute name="{name()}" select="if(local-name() eq  'font-family') then replace(., '[A-Z]+\+(.+)', '''$1''') else ."/>
        </xsl:for-each>
      </xsl:variable>
      
      
      <xsl:variable name="css-properties-sequence"
        select="for $i in $patched-css-properties return concat($i/local-name(), ':', $i)"/>
      <xsl:variable name="css-properties" select="string-join($css-properties-sequence, '; ')"/>
    	
    	<xsl:variable name="complex-id"
        select="concat('p-', $div-id, '-', $leading-zeros-string, $id)"/>
      
      <xsl:if test="@css:*">
      	<!-- hide text if rasterized images are used -->
      	<xsl:variable name="opacity" select="if($rastertext eq 'yes') then '; opacity:0; z-index:-1' else ''"/>
        <!-- write out css properties -->
        <xsl:value-of
        	select="concat('#', $complex-id, ' { ', $css-properties,  $opacity, '; }', '&#xa;')"/>
      </xsl:if>
      <xsl:if test="local-name() eq 'img'">
      	<!-- patch file extension conditionally, because ImageMagick stores page images in a different manner than Poppler -->      	
      	<xsl:variable name="page-count" select="xs:integer(replace(@src, '(.+?)(\d+)\.jpg', '$2')) - 1" as="xs:integer"/>
      	
      	<xsl:variable name="img-src" select="if($rastertext eq 'yes')
      		then replace(@src, '0+(\d+)\.jpg', concat('-', $page-count, '.png'))
      		else @src" as="xs:string"/>
        <xsl:variable name="css-image-reference" select="concat('background-image:url(''', $img-src, '''); position:absolute; width:', @width, 'px; height:', @height, 'px;')"/>
        <xsl:variable name="leading-zeros-string" select="string-join(for $i in (string-length($div-id) to $page-id-max-length - 1) return '0', '')"/>
          <xsl:value-of 
          select="concat('#page-', $leading-zeros-string, $div-id, ' { ', $css-image-reference, ' }', '&#xa;')"/>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  
</xsl:stylesheet>