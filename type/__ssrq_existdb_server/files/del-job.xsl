<?xml version="1.0" encoding="UTF-8"?>

<!--
	Use: saxon -s:conf.xml -xsl:del-job.xsl name=backup
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="name"/>

	<!-- default: copy everything as is -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="scheduler/job[@name = $name]">
		<!-- just omit it ;-) -->
	</xsl:template>

</xsl:stylesheet>
