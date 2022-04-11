<xsl:stylesheet version="1.0"
   xmlns:vr="http://foundationmedicine.com/compbio/variant-report"
   xmlns="http://foundationmedicine.com/compbio/variant-report-external"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

   <!--
   
   PURPOSE: Filter a variant-report document (schema 2.1) for distribution outside FMI.
   
   An objective of this stylesheet is to be explicit about what to include. Rather than
   selectively filtering things out, this stylesheet prefers to explicitly opt items in.
   
   Taken to the extreme, we'd have to list every element and attribute. So there's a
   compromise:
   
      - elements to preserve are explicit (opt-in)
      - attributes are always kept unless filtered (opt-out)
   
   -->

   <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

   <xsl:param name="clinical-variants-only"/>

   <!-- by default, disable all nodes (element, text, comment, or processing instruction) -->
   <xsl:template match="node()"/>
   
   <!-- by default, enable all attributes -->
   <xsl:template match="@*">
      <xsl:copy/>
   </xsl:template>

   <!-- status variable -->
   <xsl:variable name="quality-status" select="/vr:variant-report/vr:quality-control/@status" />
    
   <!-- global validations -->
   <xsl:template match="/">

      <!-- check the value of the user-configurable variable to prevent typo confusion -->
      <!-- it's enforced here (instead of when the rule is applied) so notification does not depend on runtime content -->
      <!--<xsl:if test="not($clinical-variants-only='true' or $clinical-variants-only='false')">
         <xsl:message terminate="yes">
            Illegal value for string parameter $clinical-variants-only.
            Expected 'true' or 'false', got '<xsl:value-of select="$clinical-variants-only"/>'.
         </xsl:message>
      </xsl:if>
      -->
      <!-- fail unless we recognize the variant report version described in the schemaLocation -->
      <xsl:if test="not(contains(/*/@xsi:schemaLocation, 'variant-report-2.2.xsd'))">
         <xsl:message terminate="yes">
            Unrecognized schemaLocation - unsupported source variant report version?
            <xsl:value-of select="concat('&quot;', /*/@xsi:schemaLocation, '&quot;')"/>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates/>

   </xsl:template>

   <!-- rewrite the schemaLocation to map from "full" to "external" format -->
   <xsl:template match="/*/@xsi:schemaLocation">
      <xsl:attribute name="xsi:schemaLocation">
         <xsl:value-of select="'http://foundationmedicine.com/compbio/variant-report-external http://integration.foundationmedicine.com/reporting/variant-report-external-2.2.xsd'"/>
      </xsl:attribute>
   </xsl:template>

   <!-- filter out specific attributes -->
   <xsl:template match="vr:variant-report/@age"/>
   <xsl:template match="vr:variant-report/@tumor-type"/>
   <xsl:template match="vr:variant-report/@reportable-variants-detected"/>
   <xsl:template match="vr:variant-report/@version"/>
   <xsl:template match="vr:variant-report/@specimen-id"/>
   <xsl:template match="vr:quality-control/@hold"/>
   <xsl:template match="vr:short-variant/@germline-status"/>
   <xsl:template match="vr:microsatellite-instability/@score"/>
   <xsl:template match="@novelty-score"/>
   <xsl:template match="@clinical"/>
   <xsl:template match="@actionability"/>

   <!--
      Special handling for variants to support filtering out non-clinical ones.
      
      It would have been tidy to filter them out with an XPath expression for the template match
      that included the variable - so we could just "do nothing" instead of "copy sometimes" -
      but unfortunately variables in template matches are illegal.
   -->
   <xsl:template match="
           vr:short-variant
         | vr:copy-number-alteration
         | vr:rearrangement
         | vr:microsatellite-instability
         | vr:tumor-mutation-burden
         | vr:non-human">

       <!-- only copy this variant if the user wants it -->
		<xsl:if test="($clinical-variants-only = 'false' or @clinical = 'true') and not($quality-status = 'Fail')">
		    <!-- instantiate element in "external" namespace -->
			<xsl:element name="{local-name()}">
			    <xsl:apply-templates select="@*|node()"/>
			</xsl:element>
		</xsl:if>

   </xsl:template>
   
   <!-- specific list of allowed elements -->
   <xsl:template match="
           vr:variant-reports
         | vr:variant-report
         | vr:samples
         | vr:samples/vr:sample
         | vr:quality-control
         | vr:short-variants
         | vr:copy-number-alterations
         | vr:rearrangements
         | vr:biomarkers
         | vr:non-human-content
         | vr:dna-evidence
         | vr:rna-evidence">

      <!-- instantiate element in "external" namespace -->
      <xsl:element name="{local-name()}">
         <xsl:apply-templates select="@*|node()"/>
      </xsl:element>
	  
   </xsl:template>
   
   
</xsl:stylesheet>
