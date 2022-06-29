<?xml version="1.0" encoding="UTF-8"?>

<!--
	Usage: java -jar /opt/existdb-*/lib/Saxon-HE-*.jar -s:etc/webapp/WEB-INF/web.xml -xsl:update-web.xsl enable-guest-xmlrpc=false rest-intf-hidden=true ...
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:webapp="http://xmlns.jcp.org/xml/ns/javaee">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
	<xsl:preserve-space elements="*"/>

	<!-- defaults for @select -->
	<xsl:param name="enable-guest-xmlrpc" select="//webapp:servlet[./webapp:servlet-class='org.exist.xmlrpc.RpcServlet']/webapp:init-param[./webapp:param-name='useDefaultUser']/webapp:param-value"/>

	<xsl:param name="rest-intf-hidden" select="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='hidden']/webapp:param-value/text()"/>
	<xsl:param name="xquery-submission" select="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='xquery-submission']/webapp:param-value/text()"/>
	<xsl:param name="xupdate-submission" select="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='xupdate-submission']/webapp:param-value/text()"/>

	<xsl:param name="xquery-hide-errors" select="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.XQueryServlet']/webapp:init-param[./webapp:param-name='hide-error-messages']/webapp:param-value/text()"/>

	<!-- default: identity copy -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- modify parameters of XML-RPC RpcServlet -->
	<xsl:template match="//webapp:servlet[./webapp:servlet-class='org.exist.xmlrpc.RpcServlet']/webapp:init-param[./webapp:param-name='useDefaultUser']/webapp:param-value">
		<xsl:element name="param-value" namespace="http://xmlns.jcp.org/xml/ns/javaee">
			<xsl:value-of select="$enable-guest-xmlrpc"/>
		</xsl:element>
	</xsl:template>

	<!-- modify parameters of EXistServlet -->
	<xsl:template match="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='hidden']/webapp:param-value">
		<xsl:element name="param-value" namespace="http://xmlns.jcp.org/xml/ns/javaee">
			<xsl:value-of select="$rest-intf-hidden"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='xquery-submission']/webapp:param-value">
		<xsl:element name="param-value" namespace="http://xmlns.jcp.org/xml/ns/javaee">
			<xsl:value-of select="$xquery-submission"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.EXistServlet']/webapp:init-param[./webapp:param-name='xupdate-submission']/webapp:param-value">
		<xsl:element name="param-value" namespace="http://xmlns.jcp.org/xml/ns/javaee">
			<xsl:value-of select="$xupdate-submission"/>
		</xsl:element>
	</xsl:template>

	<!-- modify paramters of XQueryServlet -->
	<xsl:template match="//webapp:servlet[./webapp:servlet-class='org.exist.http.servlets.XQueryServlet']/webapp:init-param[./webapp:param-name='hide-error-messages']/webapp:param-value">
		<xsl:element name="param-value" namespace="http://xmlns.jcp.org/xml/ns/javaee">
			<xsl:value-of select="$xquery-hide-errors"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
