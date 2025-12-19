<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="text" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:for-each select="//dc:identifier[contains(.,'mdz')]">
            <xsl:variable name="filename">
                <xsl:value-of select="ancestor::oai_dc:dc/dc:date[1]"/>
                <xsl:text>_</xsl:text>
                <xsl:value-of select="ancestor::oai_dc:dc/dc:title[1]/substring(.,1,15)"/>
                <xsl:text>_</xsl:text>
                <!-- <xsl:value-of select="ancestor::oai_dc:dc/dc:identifier[contains(.,'ppn')]/translate(translate(normalize-space(),':','_'),' ','')"/> -->
                <xsl:value-of select="ancestor::oai_dc:dc/dc:identifier[matches(.,'^\d{1,3}:\d{6}\w')]/translate(.,':','_')"/>
            </xsl:variable>
            <xsl:try>
                <xsl:result-document href="corpus/messrelation_{$filename}.txt">
                    <xsl:for-each select="json-doc(concat('https://api.digitale-sammlungen.de/iiif/presentation/v2/',./substring-before(substring-after(.,'bvb:12-'),'-'),'/manifest'))">
                        <xsl:for-each select="map:get(.,'sequences')">
                            <xsl:for-each select="array:get(.,1)">                            
                                <xsl:for-each select="map:get(.,'canvases')">
                                    <xsl:variable name="canvas" select="."/>
                                    <xsl:for-each select="1 to array:size(.)">
                                        <xsl:variable name="position" select="."/>
                                        <xsl:for-each select="map:get(array:get($canvas,$position),'seeAlso')">
                                            <xsl:variable name="url_ocr" select="map:get(.,'@id')"/>
                                            <xsl:try>
                                                <xsl:value-of select="document($url_ocr)//xhtml:body/normalize-space()"/>
                                                <xsl:catch></xsl:catch>
                                            </xsl:try>                                       
                                            <xsl:if test="position()!=last()">
                                                <xsl:text>&#xA;</xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:for-each>                                
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:result-document>
                <xsl:catch>
                    <xsl:variable name="appendix_filename" select="concat(translate(string(current-time()),':.+',''),generate-id())"/>
                    <xsl:result-document href="corpus/messrelation_{$filename}_{$appendix_filename}.txt">
                        <xsl:for-each select="json-doc(concat('https://api.digitale-sammlungen.de/iiif/presentation/v2/',./substring-before(substring-after(.,'bvb:12-'),'-'),'/manifest'))">
                            <xsl:for-each select="map:get(.,'sequences')">
                                <xsl:for-each select="array:get(.,1)">                            
                                    <xsl:for-each select="map:get(.,'canvases')">
                                        <xsl:variable name="canvas" select="."/>
                                        <xsl:for-each select="1 to array:size(.)">
                                            <xsl:variable name="position" select="."/>
                                            <xsl:for-each select="map:get(array:get($canvas,$position),'seeAlso')">
                                                <xsl:variable name="url_ocr" select="map:get(.,'@id')"/>
                                                <xsl:try>
                                                    <xsl:value-of select="document($url_ocr)//xhtml:body/normalize-space()"/>
                                                    <xsl:catch></xsl:catch>
                                                </xsl:try>                                       
                                                <xsl:if test="position()!=last()">
                                                    <xsl:text>&#xA;</xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:for-each>                                
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:result-document>
                </xsl:catch>
            </xsl:try>            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>