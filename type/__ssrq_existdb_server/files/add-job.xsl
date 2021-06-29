<?xml version="1.0" encoding="UTF-8"?>

<!--
	Use: saxon -s:conf.xml -xsl:add-job.xsl name=backup cronTrigger="0 0 7-19 * * ?" params="output=/var/backups/existdb;backup=yes;zip=yes"
		 or
		 saxon -s:conf.xml -xsl:add-job.xsl name=lemma-cleanup cronTrigger="0 05 02 * * ?" xqueryPath="/db/apps/lemmas/admin/remove_locks.xq"
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<xsl:param name="name"/>
	<xsl:param name="cronTrigger"/>
	<xsl:param name="xqueryPath"/>
	<xsl:param name="params"/>

	<xsl:template match="/">
		<xsl:if test="exists(/exist/scheduler/job[@name = $name])">
			<xsl:message terminate="yes">ERROR: A job named "<xsl:copy-of select="$name"/>" already exists, exiting…</xsl:message>
		</xsl:if>
		<xsl:apply-templates/>
	</xsl:template>

	<!-- default: copy everything as is -->
	<xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

	<!-- add job element after last comment node -->
	<xsl:template match="scheduler/comment()[position() = last()]">
		<job>
			<xsl:attribute name="name">
				<xsl:copy-of select="$name"/>
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:choose>
					<xsl:when test="$name = 'backup'">system</xsl:when>
					<xsl:otherwise>user</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:attribute name="cron-trigger">
				<xsl:copy-of select="$cronTrigger"/>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$name = 'backup'">
					<xsl:attribute name="class">org.exist.storage.ConsistencyCheckTask</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xquery">
						<xsl:copy-of select="$xqueryPath"/>
					</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:for-each select="tokenize($params, ';')">
				<xsl:variable name="name" select="tokenize(., '=')[1]"/>
				<xsl:variable name="value" select="tokenize(., '=')[2]"/>
				<parameter>
					<xsl:attribute name="name">
						<xsl:copy-of select="$name"/>
					</xsl:attribute>
					<xsl:attribute name="value">
						<xsl:copy-of select="$value"/>
					</xsl:attribute>
				</parameter>
			</xsl:for-each>
		</job>
	</xsl:template>

</xsl:stylesheet>
