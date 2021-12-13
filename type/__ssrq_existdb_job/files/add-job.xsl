<?xml version="1.0" encoding="UTF-8"?>

<!--
	Usage examples:

	saxon -s:conf.xml -xsl:add-job.xsl name=backup type=system cron-trigger='0 0 7-19 * * ?' params='output=/var/backups/existdb<backup=yes<zip=yes'
	or
	saxon -s:conf.xml -xsl:add-job.xsl name=lemma-cleanup type=user cron-trigger='0 05 02 * * ?' xquery='/db/apps/lemmas/admin/remove_locks.xq'
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="no" indent="yes"/>

	<xsl:param name="class"/>
	<xsl:param name="cron-trigger"/>
	<xsl:param name="name"/>
	<xsl:param name="params"/>
	<xsl:param name="type"/>
	<xsl:param name="xquery"/>

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
				<xsl:copy-of select="$type"/>
			</xsl:attribute>
			<xsl:attribute name="cron-trigger">
				<xsl:copy-of select="$cron-trigger"/>
			</xsl:attribute>
			<xsl:attribute name="class">
				<xsl:copy-of select="$class"/>
			</xsl:attribute>
			<xsl:attribute name="xquery">
				<xsl:copy-of select="$xquery"/>
			</xsl:attribute>
			<xsl:for-each select="tokenize($params, '&#60;')">
				<xsl:variable name="name" select="substring-before(., '=')"/>
				<xsl:variable name="value" select="substring-after(., '=')"/>
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
