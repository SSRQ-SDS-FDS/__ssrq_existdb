<?xml version="1.0" encoding="UTF-8"?>

<!--
	Use: saxon -s:conf.xml -xsl:del-job.xsl name=check1
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

	<xsl:param name="name"/>

	<!-- default: identity copy -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="/exist/scheduler/job[@name = $name]">
		<!-- just omit it ;-) -->
	</xsl:template>
</xsl:stylesheet>
