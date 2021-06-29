<?xml version="1.0" encoding="UTF-8"?>

<!--
	Use: saxon -s:conf.xml -xsl:set-db-connection.xsl cacheSize=2048M ...
-->

<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<!-- defaults in @select -->
	<xsl:param name="cacheSize" select="'1024M'"/>
	<xsl:param name="files" select="'../data'"/>
	<xsl:param name="pageSize" select="'4096'"/>
	<xsl:param name="syncPeriod" select="'120000'"/><!-- beware: argument name is sync-period… -->
	<xsl:param name="syncOnCommit" select="'yes'"/><!-- beware: argument name is sync-on-commit… -->

	<!-- default: copy everything as is -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<!-- modify attributes of <db-connection> -->
	<xsl:template match="/exist/db-connection/@cacheSize">
		<xsl:attribute name="cacheSize">
			<xsl:value-of select="$cacheSize"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/exist/db-connection/@files">
		<xsl:attribute name="files">
			<xsl:value-of select="$files"/>
		</xsl:attribute>
	</xsl:template>
	<xsl:template match="/exist/db-connection/@pageSize">
		<xsl:attribute name="pageSize">
			<xsl:value-of select="$pageSize"/>
		</xsl:attribute>
	</xsl:template>

	<!-- modify attributes of <pool/> -->
	<xsl:template match="/exist/db-connection/pool/@sync-period">
		<xsl:attribute name="sync-period">
			<xsl:value-of select="$syncPeriod"/>
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
			<xsl:value-of select="$syncOnCommit"/>
		</xsl:attribute>
	</xsl:template>

</xsl:stylesheet>
