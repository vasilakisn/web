<?xml version="1.0"?>
<!--
 -
 - Transform the eltrun data into HTML web pages
 -
 - (C) Copyright 2004 Diomidis Spinellis
 -
 - $Id$
 -
 -->

<!-- Global definitions {{{1 -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:param name="today"/>	<!-- today's date -->
<xsl:param name="ogroup"/>	<!-- limit output to (projects/members) of a given group -->
<xsl:param name="oproject"/>	<!-- limit output to a given project -->
<xsl:param name="omember"/>	<!-- limit output to a given member -->
<xsl:param name="opage"/>	<!-- limit output to a given page -->
<xsl:param name="what"/>	<!-- Output:
					  members
					| alumni
					| current-projects
					| completed-projects
					| member-details
					| project-details
					| group-details
					| group-publications
					| member-publications
					| project-publications
					| seminar
					| rel-pages
				-->
<xsl:param name="menu"/>        <!-- Turn Side menu:
					  on (default is on)
					| off
				-->
<xsl:param name="seminaryear"/> <!-- limit output to seminar per year -->

	<!-- Generate heading with group name {{{1 -->
	<xsl:template match="group" mode="heading">
		<xsl:if test="@id = $ogroup">
			ELTRUN - <xsl:value-of select="shortname" />:
			<xsl:value-of select="grouptitle" />
		</xsl:if>
	</xsl:template>

	<!-- Create a bib2html template{{{1 -->
	<xsl:template name="bib2html">
		<xsl:param name="pubid" />
		<xsl:param name="type" />
<!-- Do not change the formatting of the following lines -->
<xsl:text>
</xsl:text>
<xsl:comment><xsl:text> </xsl:text>BEGIN BIBLIOGRAPHY build/<xsl:value-of select="$pubid" />-<xsl:value-of select="$type" /><xsl:text> </xsl:text></xsl:comment>
<xsl:text>
</xsl:text>
<xsl:comment><xsl:text> </xsl:text>END BIBLIOGRAPHY build/<xsl:value-of select="$pubid" />-<xsl:value-of select="$type" /><xsl:text> </xsl:text></xsl:comment>
<xsl:text>
</xsl:text>
	</xsl:template>

	<!-- Format an ISO date {{{1 -->
	<xsl:template name="date">
		<xsl:param name="date" />
		<!-- Date (00 means unknown) -->
		<xsl:variable name="day" select="number(substring($date, 7, 2))" />
		<xsl:if test="$day != 0">
			<xsl:value-of select="$day"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<!-- Month (00 means unknown)-->
		<xsl:variable name="month" select="substring($date, 5, 2)" />
		<xsl:choose>
			<xsl:when test="$month = '01'">January</xsl:when>
			<xsl:when test="$month = '02'">February</xsl:when>
			<xsl:when test="$month = '03'">March</xsl:when>
			<xsl:when test="$month = '04'">April</xsl:when>
			<xsl:when test="$month = '05'">May</xsl:when>
			<xsl:when test="$month = '06'">June</xsl:when>
			<xsl:when test="$month = '07'">July</xsl:when>
			<xsl:when test="$month = '08'">August</xsl:when>
			<xsl:when test="$month = '09'">September</xsl:when>
			<xsl:when test="$month = '10'">October</xsl:when>
			<xsl:when test="$month = '11'">November</xsl:when>
			<xsl:when test="$month = '12'">December</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<!-- Year -->
		<xsl:value-of select="substring($date, 1, 4)"/>
	</xsl:template>

	<!-- Format a publication type for the contents list {{{1 -->
	<xsl:template match="publication_type" mode="toc" >
		<ul>
		<xsl:if test="count(has_book) != 0">
			<li><a href="#book">Monographs and edited volumes</a></li>
		</xsl:if>
		<xsl:if test="count(has_article) != 0">
			<li><a href="#article">Journal articles</a></li>
		</xsl:if>
		<xsl:if test="count(has_incollection) != 0">
			<li><a href="#incollection">Book chapters</a></li>
		</xsl:if>
		<xsl:if test="count(has_inproceedings) != 0">
			<li><a href="#inproceedings">Conference publications</a></li>
		</xsl:if>
		<xsl:if test="count(has_techreport) != 0">
			<li><a href="#techreport">Technical reports</a></li>
		</xsl:if>
		<xsl:if test="count(has_whitepaper) != 0">
			<li><a href="#whitepaper">White papers</a></li>
		</xsl:if>
		<xsl:if test="count(has_workingpaper) != 0">
			<li><a href="#workingpaper">Working papers</a></li>
		</xsl:if>
		</ul>
	</xsl:template>

	<!-- Format a publication type for including BibTeX results {{{1 -->
	<xsl:template match="publication_type" mode="full" >
		<xsl:param name="pubid" />
		<xsl:if test="count(has_book) != 0">
			<a name="book"> </a><h2>Monographs and Edited Volumes</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'book'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_article) != 0">
			<a name="article"> </a><h2>Journal Articles</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'article'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_incollection) != 0">
			<a name="incollection"> </a><h2>Book Chapters</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'incollection'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_inproceedings) != 0">
			<a name="inproceedings"> </a><h2>Conference Publications</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'inproceedings'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_techreport) != 0">
			<a name="techreport"> </a><h2>Technical Reports</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'techreport'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_whitepaper) != 0">
			<a name="whitepaper"> </a><h2>White Papers</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'whitepaper'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="count(has_workingpaper) != 0">
			<a name="workingpaper"> </a><h2>Working Papers</h2>
			<xsl:call-template name="bib2html">
				<xsl:with-param name="type" select="'workingpaper'" />
				<xsl:with-param name="pubid" select="$pubid" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="simple-ref" >
		<xsl:if test="count(alumnus) = 0">
			<a href="../members/{@id}.html">
			<xsl:if test="count(memb_title) != 0">
				<xsl:value-of select="memb_title"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			</a>
		</xsl:if>
	</xsl:template>
	
	<!-- Format a member reference {{{1-->
	<xsl:template match="member" mode="pub-ref" >
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
	</xsl:template>
	

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="ref">
		<xsl:if test="count(alumnus) = 0">
			<li>
			<a href="../members/{@id}.html">
			<xsl:if test="count(memb_title) != 0">
				<xsl:value-of select="memb_title"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="givenname" />
			<xsl:text> </xsl:text>
			<xsl:value-of select="surname" />
			<xsl:if test="/eltrun/group_list/group [@id = $ogroup]/@director = @id">
			(Director)
			</xsl:if>
			</a>
			</li>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="alumnus-ref">
		<xsl:if test="count(alumnus) != 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>
		</xsl:if>
	</xsl:template>

	<!-- Format a member reference {{{1 -->
	<xsl:template match="member" mode="shortref">
		<xsl:if test="count(alumnus) = 0">
		<li>
		<a href="../members/{@id}.html">
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title"/>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</a>
		</li>
		</xsl:if>
	</xsl:template>
	
	<!-- Format member plain text -->
	<xsl:template match="member" mode="plaintext">
		<xsl:value-of select="current()/memb_title" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="current()/givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="current()/surname" />
	</xsl:template>
	
	<!-- Format members information {{{1 -->
	<xsl:template match="member" mode="full">
		<h2>
		<xsl:if test="count(memb_title) != 0">
			<xsl:value-of select="memb_title" />
		</xsl:if>
		<xsl:text> </xsl:text>
		<xsl:value-of select="givenname" />
		<xsl:text> </xsl:text>
		<xsl:value-of select="surname" />
		</h2>
		<table border="0"><tr><td valign="top">
		<xsl:if test="count(photo) != 0">
			<img src="{current()/photo}" alt="{current()/memb_title} {current()/givenname} {current()/surname}" />
		</xsl:if>
		<br /> <br />
		</td>
		<td>
		<xsl:if test="count(alumnus) != 0">
			<font color="#FF0000">
			<h4>(ELTRUN associate)</h4>
			</font>
		</xsl:if>
		<xsl:if test="count(email) != 0">
			E-mail: <xsl:value-of select="email" />
			<br />
		</xsl:if>
		<xsl:if test="count(office_phone) != 0">
			Office phone: <xsl:value-of select="office_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(mobile_phone) != 0">
			Mobile phone: <xsl:value-of select="mobile_phone" />
			<br />
		</xsl:if>
		<xsl:if test="count(Fax) != 0">
			Fax: <xsl:value-of select="fax" />
			<br />
		</xsl:if>
		<xsl:if test="count(office_address) != 0">
			Office address: <xsl:value-of select="office_address"/>
			<br />
		</xsl:if>
		<xsl:if test="count(postal_address) != 0">
			Postal address: <xsl:value-of select="postal_address"/>
			<br />
		</xsl:if>
		<xsl:if test="count(web_site) != 0">
			Web site: <a href="{web_site}"><xsl:value-of select="web_site"/></a>
			<br />
		</xsl:if>
		<!-- List group membership, if any -->
		<xsl:if test="@group != 'g_eltrun'">
			Groups: <xsl:apply-templates select="/eltrun/group_list/group [contains(current()/@group, @id)]" mode="shortref"/>
			<br />
		</xsl:if>
		</td></tr>
		</table>
		<!-- Provide publications link, if any publications exist -->
		<xsl:if test="count(/eltrun/publication_type_list/publication_type [@for = current()/@id]/has_any) != 0">
			<br />
			<a href="../publications/{$omember}-publications.html">Publication list</a>
		</xsl:if>
		<br />
		<br />
		<xsl:copy-of select="current()/shortcv"/>
	</xsl:template>

	<!-- Format a short group reference {{{1 -->
	<xsl:template match="group" mode="shortref" >
		<xsl:if test="@id != 'g_eltrun'">
			<a href="../groups/{@id}-details.html">
			<xsl:value-of select="shortname" />
			</a>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- Format a full group description {{{1-->
	<xsl:template match="group" mode="full">
		<h2>
		<xsl:value-of select="shortname"/>
		<xsl:text> - </xsl:text>
		<xsl:value-of select="grouptitle"/>
		</h2>
		<br />
		<xsl:if test="count(logo) != 0">
			<img src="{current()/logo}" alt="{current()/shortname} - {current()/grouptitle}" />
			<br /><br />
		</xsl:if>
		<xsl:if test='count(director_photo) != 0'>
			<img src="{current()/director_photo}" alt="{current()/surname}" />
			<br />
		</xsl:if>
		<br /><br />
		Director:
		<br />
		<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@director]" mode="simple-ref" />
		<br />
		<xsl:if test='current()/@director != current()/@contact'>
		Contact:
		<br />
		<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		<br />
		</xsl:if>
		<br />
		Research group information:
		<br /><br />
		<xsl:copy-of select="current()/description" />
		<br />
		<br />
		Website Maintainer:
		<br />
		<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@maintainer]" mode="simple-ref" />
	</xsl:template>
	
	<!-- Format a project reference {{{1 -->
	<xsl:template match="project" mode="ref">
		<li>
		<a href="../projects/{@id}.html">
			<xsl:value-of select="shortname" /> - <xsl:value-of select="projtitle" />
		</a>
		</li>
	</xsl:template>

	<!-- List project details {{{1 -->
	<xsl:template match="project" mode="full">
		<h1>
		<xsl:value-of select="shortname" />
		-
		<xsl:value-of select="projtitle" />
		</h1>
		<!-- Show Logo -->
		<xsl:if test="count(logo) != 0">
			<img src="{current()/logo}" alt="{current()/shortname} Logo" />
		</xsl:if>
		<br /> <br />
		<!-- Project Summary information -->
		<xsl:if test="count(project_code) != 0">
			Project Code:
			<xsl:value-of select="project_code" />
			<xsl:if test="@international = 'yes'">(International)</xsl:if>
			<br/>
		</xsl:if>
		<xsl:if test="count(funding_programme) != 0">
			Funding programme: <xsl:value-of select="funding_programme" />
			<br />
		</xsl:if>
		<xsl:if test="count(funding_agency) != 0">
			Funding Agency: <xsl:value-of select="funding_agency" />
			<br />
		</xsl:if>
		<xsl:if test="@type != ''">
			Project type:
			<xsl:choose>
				<xsl:when test="@type = 'rtd'">RTD</xsl:when>
				<xsl:when test="@type = 'consulting'">Consulting</xsl:when>
				<xsl:when test="@type = 'training'">Training</xsl:when>
				<xsl:when test="@type = 'dissemination'">Dissemination</xsl:when>
			</xsl:choose>
			<br />
		</xsl:if>
		<xsl:if test="count(web_site) != 0">
			Web site: <a href="{current()/web_site}"><xsl:value-of select="web_site" /></a>
			<br /><br />
		</xsl:if>
		<!-- Show starting date -->
		<xsl:if test="startdate != ''">
			Starting date:
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="startdate" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:if test="enddate != ''">
			Ending date:
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="enddate" />
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:if test="count(our_budget) != 0">
			ELTRUN budget: <xsl:value-of select="our_budget" />
			<br />
		</xsl:if>
		<xsl:if test="count(total_budget) != 0">
			Total budget: <xsl:value-of select="total_budget" />
			<br />
		</xsl:if>
		<br />
		<!-- Show eltrun related info -->
		<xsl:if test="@scientific_coordinator != ''">
			Scientific coordinator:
			<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@scientific_coordinator]" mode="simple-ref" />
			<br />
		</xsl:if>
		<xsl:if test="@project_manager != ''">
			Project Manager:
			<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@project_manager]" mode="simple-ref" />
			<br />
		</xsl:if>
		<xsl:if test="@contact != ''">
			Contact:
			<xsl:apply-templates select="/eltrun/member_list/member [@id=current()/@contact]" mode="simple-ref" />
		<br />
		</xsl:if>
		<!-- Show groups this project belongs to -->
		Groups:
		<xsl:apply-templates select="/eltrun/group_list/group [contains(current()/@group, @id)]" mode="shortref" />
		<!-- Provide publications link, if any publications exist -->
		<xsl:if test="count(/eltrun/publication_type_list/publication_type [@for = current()/@id]/has_any) != 0">
			<br/><br />
			<a href="../publications/{@id}-publications.html">Publication List</a>
		</xsl:if>
		<br />
		<br />
		<xsl:if test="count(description) != 0">
			Description:<br />
			<br />
			<xsl:copy-of select="current()/description" />
			<br />
		</xsl:if>
		<xsl:if test="count(partner) != 0">
			Partners:
			<ul>
			<xsl:for-each select="current()/partner">
				<li>
				<xsl:if test="count(web_site) != 0">
					<a href="{current()/web_site}"><xsl:value-of select="current()/shortname"/> (<xsl:value-of select="current()/country"/>)</a>
				</xsl:if>
				<xsl:if test="count(web_site) = 0">
					<xsl:value-of select="current()/shortname"/> (<xsl:value-of select="current()/country"/>)
				</xsl:if>
				</li>			
			</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<!-- body menu {{{1-->
	<xsl:template name="body-menu">
		<xsl:param name="bodygroup" />
		<xsl:if test="/eltrun/group_list/group[@id = $bodygroup]/@id != 'g_eltrun'">
			<a href="../groups/{/eltrun/group_list/group[@id = $bodygroup]/@id}-details.html">
			ELTRUN - <xsl:value-of select="/eltrun/group_list/group[@id = $bodygroup]/shortname" />
			</a>
			<br /><hr />
		</xsl:if>
		<a href="../groups/{$bodygroup}-members.html">Members</a>
			<br />
			<a href="../groups/{$bodygroup}-current-projects.html">Current Projects</a>
			<br />
			<a href="../groups/{$bodygroup}-completed-projects.html">Completed Projects</a>
			<br />
			<a href="../publications/{$bodygroup}-publications.html">Publications</a>
			<br />
			<xsl:if test="count(/eltrun/member_list/member[contains(@group,$bodygroup)]/alumnus) != 0">
				<a href="../groups/{$bodygroup}-alumni.html">Associates</a><br />
			</xsl:if>
			<xsl:if test="count(/eltrun/page_list/page[@group = $bodygroup]) != 0">				
				<xsl:for-each select="/eltrun/page_list/page[@group = $bodygroup]">
					<a href="../rel_pages/{@id}-page.html">
					<xsl:value-of select="page_name" />
					</a><br />
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="count(/eltrun/group_list/group[@id = $bodygroup]/rel_link) != 0">
				<xsl:for-each select="/eltrun/group_list/group[@id = $bodygroup]/rel_link">
					<xsl:copy-of select="current()/*" /><br />
				</xsl:for-each>
			</xsl:if>
	</xsl:template>
	
	<!-- presentation reference {{{1-->
	<xsl:template match="presentation" mode="ref">
		<xsl:apply-templates select="/eltrun/member_list/member [contains(current()/@by,@id)]/surname" />
		<xsl:if test="count(pres_name) != 0">
			<xsl:text> </xsl:text><xsl:value-of select="pres_name" />
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="presentation" mode="full">
		<table border="0">
		<tr>
		<td><b>Title:</b></td>
		<td><a href="{pres_url}"><xsl:value-of select="pres_title"/></a></td>
		</tr>
		<tr>
		<td><b>Presenters:</b></td>
		<td>
		<xsl:for-each select="/eltrun/member_list/member [contains(current()/@by,@id)]">
			<xsl:apply-templates select="current()" mode="pub-ref"/><br />
		</xsl:for-each>
		<xsl:if test="count(pres_name) != 0">
			<xsl:value-of select="pres_name" />
		</xsl:if>
		</td>
		</tr>
		</table>
		<br/><br />
	</xsl:template>
	
	<!-- seminar {{{1-->
	<xsl:template match="seminar" mode="ref">
		<a href="{$seminaryear}.html#{current()/sem_date}">
			<xsl:call-template name="date">
				<xsl:with-param name="date" select="sem_date" />
			</xsl:call-template>
			<xsl:text> - </xsl:text>
			<xsl:apply-templates select="current()/presentation" mode="ref"/>
		</a>
	    <br />
	</xsl:template>
	
	<!-- Seminar detailed template {{{1-->
	<xsl:template match="seminar" mode="full">
	    <hr />
	    <!-- Create the anchor -->
	    <a name="{current()/sem_date}" />
	    <h2>
	    	<xsl:call-template name="date">
			<xsl:with-param name="date" select="sem_date" />
		</xsl:call-template>
	    </h2>
	    <!-- create seminar data -->
	    <table border="0">
	    <tr>
	    <td><b>Location:</b></td> 
	    <td><xsl:value-of select="sem_room" /></td>
	    </tr>
	    <tr>
	    <td><b>Time:</b></td>
	    <td><xsl:value-of select="sem_time" /></td>
	    </tr>
	    </table>
	    <br />
	    <h3>Presentations</h3>
	    <xsl:apply-templates select="current()/presentation" mode="full"/>
	</xsl:template>

	<!-- page transformation {{{1-->
	<xsl:template match="page" mode="full">
		<h2><xsl:value-of select="page_name" /></h2>
		<xsl:copy-of select="current()/page_body" />
	</xsl:template>

	<!-- Main transformation {{{1 -->
	<xsl:template match="eltrun">
		<html>
		<!-- HEAD -->
		<head>
		<link href="../images/styles.css" type="text/css" rel="stylesheet" />
		<xsl:comment>Generated by $Id$</xsl:comment>
		<title>
		<!-- Append the appropriate title -->
		<xsl:if test="$ogroup != ''">
			<xsl:value-of select="/eltrun/group_list/group[@id = $ogroup]/shortname" />
		</xsl:if>
		<xsl:choose>
			<xsl:when test="$what = 'project-publications'">
				<xsl:value-of select="/eltrun/project_list/project[@id = $oproject]/shortname" />
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'current-projects'">
				<xsl:text> - Current Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'completed-projects'">
				<xsl:text> - Completed Projects</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'members'">
				<xsl:text> - Members</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'project-details'">
				<xsl:value-of select="/eltrun/project_list/project[@id = $oproject]/shortname" />
				<xsl:text> - Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-publications'">
				<xsl:apply-templates select="/eltrun/member_list/member[@id = $omember]" mode="plaintext" />
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-publications'">
				<xsl:text> publication list</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'member-details'">
				<xsl:apply-templates select="/eltrun/member_list/member[@id = $omember]" mode="plaintext" />
				<xsl:text> Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'group-details'">
				<xsl:text> - Group Details</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'alumni'">
				<xsl:text> - Research Associates</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'seminar'">
				<xsl:text>ELTRUN Seminars</xsl:text>
			</xsl:when>
			<xsl:when test="$what = 'rel-pages'">
				<xsl:variable name="tmpgroup" select="/eltrun/page_list/page[@id = $opage]/@group" />					     
				<xsl:value-of select="/eltrun/group_list/group[@id = $tmpgroup]/shortname" />
				<xsl:text> - </xsl:text>
				<xsl:value-of select="/eltrun/page_list/page[@id = $opage]/page_name" />
			</xsl:when>
		</xsl:choose>
		</title>
		</head>

		<!-- BODY -->
		<body>
		<a href="http://www.eltrun.gr/">
			<img src="../images/heading.jpg" alt="ELTRUN - The e-Business Center" border="0" />
		</a>
		<br />
		<table border="0">
			<tbody valign="top">
			<tr>
			<xsl:if test="$menu != 'off'">
				<xsl:if test="$what = 'rel-pages'">
					<xsl:variable name="tmpgroup" select="/eltrun/page_list/page[@id = $opage]/@group" />
					<td height="800" width="150" align="left" bgcolor="{/eltrun/group_list/group[@id = $tmpgroup]/color}">				
					<xsl:call-template name="body-menu">
						<xsl:with-param name="bodygroup" select="/eltrun/page_list/page[@id = $opage]/@group" />
					</xsl:call-template>
					</td>
				</xsl:if>
				<xsl:if test="$what != 'rel-pages'">
					<td height="800" width="150" align="left" bgcolor="{/eltrun/group_list/group[@id = $ogroup]/color}">
					<xsl:call-template name="body-menu">
						<xsl:with-param name="bodygroup" select="$ogroup" />
					</xsl:call-template>
					</td>
				</xsl:if>
			</xsl:if>
			<td align="left" width="830">
			<!-- choose which HTML to show -->
			<xsl:choose>
				<!-- Current projects -->
				<xsl:when test="$what = 'current-projects'">
				<h2>Current Projects</h2>
				    <ul>
					<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &gt;= $today]" mode="ref">
						<xsl:sort select="shortname" order="ascending"/>
					</xsl:apply-templates>
				    </ul>
				</xsl:when>
				<!-- Completed Projects -->
				<xsl:when test="$what = 'completed-projects'">
				<h2>Completed Projects</h2>
				    <ul>
					<xsl:apply-templates select="/eltrun/project_list/project [contains(@group, $ogroup)] [enddate &lt; $today]" mode="ref" >
						<xsl:sort select="shortname" order="ascending"/>
					</xsl:apply-templates>
				    </ul>
				</xsl:when>
				<!-- members -->
				<xsl:when test="$what = 'members'">
				<h2>Members</h2>
				<ul>
				<xsl:apply-templates select="/eltrun/member_list/member[contains(@group,$ogroup)]" mode="ref">
					<xsl:sort select="memb_title" order="ascending"/>
				</xsl:apply-templates>
				</ul>
				</xsl:when>
				<!-- project details -->
				<xsl:when test="$what = 'project-details'">
					<xsl:apply-templates select="/eltrun/project_list/project [@id = $oproject]" mode="full" />
				</xsl:when>
				<!-- Member Publications -->
				<xsl:when test="$what = 'member-publications'">
					<h1>
					<xsl:apply-templates select="/eltrun/member_list/member [@id=$omember]" mode="pub-ref" /> : Publications
					</h1>
					<h2>Contents</h2>
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $omember]" mode="toc" />
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $omember]" mode="full" >
						<xsl:with-param name="pubid" select="$omember" />
					</xsl:apply-templates>
				</xsl:when>
				<!-- project publications -->
				<xsl:when test="$what = 'project-publications'">
					<h1>
					<a href="../publications/{$oproject}-publications.html">
						<xsl:apply-templates select="/eltrun/project_list/project[@id = $oproject]/shortname" />
					</a>
					: Publications
					</h1>
					<h2>Contents</h2>
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $oproject]" mode="toc" />
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $oproject]" mode="full">
						<xsl:with-param name="pubid" select="$oproject" />
					</xsl:apply-templates>
				</xsl:when>
				<!-- group publications -->
				<xsl:when test="$what = 'group-publications'">
					<h1>
					<xsl:if test="$ogroup != 'g_eltrun'">
					<a href="../groups/{$ogroup}-details.html">
						<xsl:apply-templates select="/eltrun/group_list/group [@id = $ogroup]/shortname" />
					</a>
					:
					</xsl:if>
					Publications
					</h1>
					<h2>Contents</h2>
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $ogroup]" mode="toc" />
					<xsl:apply-templates select="/eltrun/publication_type_list/publication_type [@for = $ogroup]" mode="full" >
						<xsl:with-param name="pubid" select="$ogroup" />
					</xsl:apply-templates>
				</xsl:when>
				<!-- member details -->
				<xsl:when test="$what = 'member-details'">
					<xsl:apply-templates select="/eltrun/member_list/member[@id = $omember]" mode="full" />
				</xsl:when>
				<!-- group details -->
				<xsl:when test="$what = 'group-details'">
					<xsl:apply-templates select="/eltrun/group_list/group[@id = $ogroup]" mode="full" />
				</xsl:when>
				<!-- alumni -->
				<xsl:when test="$what = 'alumni'">
					<h2>Research Associates</h2>
					<ul>
					<xsl:apply-templates select="/eltrun/member_list/member [contains(@group,$ogroup)]" mode="alumnus-ref" />
					</ul>
				</xsl:when>				
				<!-- seminar -->
				<xsl:when test="$what = 'seminar'">
					<h2>Eltrun Seminars</h2>
						<xsl:apply-templates select="/eltrun/seminar_list/seminar [starts-with(sem_date,$seminaryear)]" mode="ref">
							<xsl:sort select="sem_date" data-type="number" order="descending"/>
						</xsl:apply-templates>
						<br /><br />
						<xsl:apply-templates select="/eltrun/seminar_list/seminar [starts-with(sem_date,$seminaryear)]" mode="full">
							<xsl:sort select="sem_date" data-type="number" order="descending"/>
						</xsl:apply-templates>
				</xsl:when>
				<!-- rel-pages -->
				<xsl:when test="$what = 'rel-pages'">
					<xsl:apply-templates select="/eltrun/page_list/page[@id = $opage]" mode="full"/>
				</xsl:when>
			</xsl:choose>
			</td>
			</tr>
			</tbody>
		</table>
		</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
