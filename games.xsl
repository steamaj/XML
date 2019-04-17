<?xml version="1.0" encoding="UTF-8" ?>
<!--
   New Perspectives on XML, 3rd Edition
   Tutorial 6
   Review Assignment

   Harpe Gaming Products Style Sheet
   Author: 
   Date:   

   Filename:         games.xsl
   Supporting Files: 
-->


<xsl:stylesheet version="1.0"
     xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
     xmlns:df="http://example.com/dateformats">
	 
	<xsl:include href="hgfunctions.xsl" />
	
	<xsl:param name="gameID" select="'bg210'" />
	
	<xsl:variable name ="currentGame" select="/games/game[@gid=$gameID]" />
	
	<xsl:variable name="externalReviews" select="document('game_reviews.xml')/reviews/review[@gid=$gameID]" />
	
	<xsl:variable name="externalReviewers" select="document('reviewers.xml')/reviewers/reviewer"  />

   
   <xsl:output method="html"
      doctype-system="about:legacy-compat"
      encoding="UTF-8"
      indent="yes" />

   <xsl:template match="/">
      <html>
         <head>
            <title><xsl:value-of select="games/game[@gid=$gameID]/title" /></title>
            <link href="hgstyles.css" rel="stylesheet" type="text/css" />
         </head>

         <body>
            <div id="wrap">
               <header>
                  <h1>Harpe Gaming</h1>
               </header>

               <section id="gameSummary">
                  <xsl:apply-templates select="games/game[@gid=$gameID]" />
               </section>

               <footer>.</footer>
             </div>
         </body>
      </html>
   </xsl:template>


   <xsl:template match="game">
      <img src="{image}" alt="" />
	  <xsl:apply-templates select="$externalReviews" />

      <h1><xsl:value-of select="title" /></h1>
      <h2>By:
         <em><xsl:value-of select="manufacturer" /></em>
      </h2>
      <table id="summaryTable">
         <tr>
            <th>Game ID: </th>
            <td><xsl:value-of select="@gid" /></td>
         </tr>

         <tr>
            <th>List Price: </th>
            <td>
				<!-- format the price value -->
               <xsl:value-of select="format-number(price,'$#,#0.00')" />
            </td>
         </tr>

         <tr>
            <th>Media: </th>
            <td>
               <xsl:value-of select="media" />
            </td>
         </tr>
         <tr>
            <th>Release Date: </th>
            <td>
				<!-- Change to 'apply-template' -->
               <xsl:apply-templates select="releaseDate" />
            </td>
         </tr>
         <tr>
            <th>Age: </th>
            <td>
               <xsl:value-of select="age" />
            </td>
         </tr>
         <tr>
            <th>Players: </th>
            <td>
               <xsl:value-of select="players" />
            </td>
         </tr>
         <tr>
            <th>Time: </th>
            <td>
               <xsl:value-of select="time" />
            </td>
         </tr>
      </table>
	  <!-- Display the summary information-->	  
	  <xsl:copy-of select="summary/*" />
	  
	  <!--step 10 make variable 'avgScore' -->
	  <xsl:variable name="avgScore" select="sum(scores/score) div count(scores/score)" />

	  <table id="scoreTable">
		
		<tr>
			<xsl:for-each select="scores/score">
				<xsl:call-template name="score">
				</xsl:call-template>
			</xsl:for-each>

			<th>
			OVERALL(<xsl:value-of select="format-number($avgScore, '0.00')" />/10)
			</th>
			
			<td>
				<xsl:call-template name="imageRow">
					<xsl:with-param name="imgFile" select="'token.png'" />
					<xsl:with-param name="imgCount" select="round($avgScore)" />
				</xsl:call-template>
			</td>
		</tr>
	  </table>
   </xsl:template>
   
   <xsl:template name="score" >
	<tr>
		<th> 
			<xsl:value-of select="current()/@category" />
			(<xsl:value-of select="current()" />/10)
		</th>
		<td>
		<xsl:call-template name="imageRow">
			<xsl:with-param name="imgFile" select="'token.png'" />
			<xsl:with-param name="imgCount" select="current()" />
		</xsl:call-template>
		</td>
	</tr>
   </xsl:template>
   
   <xsl:template match="review">
	<section class="review">
 	<xsl:variable name="reviewerTitle" select="$externalReviewers[@revid=current()/@revid]/title" />
    <xsl:variable name="reviewerURL" select="$externalReviewers[@revid=current()/@revid]/url" />
		<xsl:copy-of select="summary/*" />
		<p>
			<xsl:value-of select="$reviewerTitle" />
			<br />
			(<a href="{$reviewerURL}"><xsl:value-of select="$reviewerURL" /></a>)
		</p>
	</section>
   </xsl:template>
   
</xsl:stylesheet>





