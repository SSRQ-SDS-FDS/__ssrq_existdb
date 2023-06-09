<?xml version="1.0" encoding="UTF-8"?>

<!--
	Usage:

	saxon -s:conf.xml -xsl:set-job.xsl +job=job.xml
-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

	<xsl:param name="job"/>
	<xsl:variable name="job_name" select="$job/job/@name"/>

	<!-- default: identity copy -->
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name="inject-job">
		<xsl:copy-of select="$job/job"/>
	</xsl:template>

	<xsl:template match="/exist/scheduler">
	  <xsl:copy>
			<xsl:apply-templates/>

			<xsl:if test="not(job[@name = $job_name])">
			  <xsl:call-template name="inject-job"/>
			</xsl:if>
	  </xsl:copy>
	</xsl:template>

	<xsl:template match="/exist/scheduler/job[@name = $job_name][1]" priority="1">
	  <xsl:call-template name="inject-job"/>
	</xsl:template>
	<xsl:template match="/exist/scheduler/job[@name = $job_name]">
		<!-- delete duplicates -->
	</xsl:template>
</xsl:stylesheet>
