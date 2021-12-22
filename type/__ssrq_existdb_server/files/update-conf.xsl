<?xml version="1.0" encoding="UTF-8"?>

<!--
	Usage: java -jar /opt/existdb-*/lib/Saxon-HE-*.jar -s:conf.xml -xsl:update-conf.xsl cache-size=2048M ...
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
	<xsl:preserve-space elements="*"/>

	<!-- defaults for @select -->
	<xsl:param name="cache-size" select="/exist/db-connection/@cacheSize"/>
	<xsl:param name="files" select="/exist/db-connection/@files"/>
	<xsl:param name="page-size" select="/exist/db-connection/@pageSize"/>
	<xsl:param name="sync-period" select="/exist/db-connection/pool/@sync-period"/>
	<xsl:param name="sync-on-commit" select="/exist/db-connection/recovery/@sync-on-commit"/>

	<!-- default: identity copy -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- modify attributes of <db-connection/> -->
	<xsl:template match="/exist/db-connection/@cacheSize">
		<xsl:attribute name="cacheSize">
			<xsl:value-of select="$cache-size"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/exist/db-connection/@files">
		<xsl:attribute name="files">
			<xsl:value-of select="$files"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/exist/db-connection/@pageSize">
		<xsl:attribute name="pageSize">
			<xsl:value-of select="$page-size"/>
		</xsl:attribute>
	</xsl:template>

	<!-- modify attributes of <pool/> -->
	<xsl:template match="/exist/db-connection/pool/@sync-period">
		<xsl:attribute name="sync-period">
			<xsl:value-of select="$sync-period"/>
		</xsl:attribute>
	</xsl:template>

	<!-- modify attributes of <recovery/> -->
	<xsl:template match="/exist/db-connection/recovery/@journal-dir">
		<xsl:attribute name="journal-dir">
			<xsl:value-of select="$files"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/exist/db-connection/recovery/@sync-on-commit">
		<xsl:attribute name="sync-on-commit">
			<xsl:value-of select="$sync-on-commit"/>
		</xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
