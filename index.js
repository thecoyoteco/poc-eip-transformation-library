const fs = require('fs')
// require the library in your code
const { TransformerFactory, TransformerTypes } = require('eip-transformation-library')

// here I'm loading couple of files that contains a Variant Report xml file and an XSL file to transform it
const xml = fs.readFileSync('./examples/variant-report-2.2.xml')
const xsl = fs.readFileSync('./examples/variant-report-2.2-to-external.xsl')

// here I'm getting an instance of the Variant Report transformer by making use of the FActory
const transformer = TransformerFactory.getInstance(TransformerTypes.variantReportTransformer)

// then, I'm calling the transformXml method and passing over the XML content and also the XSL content
const result = transformer.transformXml(xml.toString(), xsl.toString())

// here printing the result of the transformation
console.log(result.content)

// here making sure that no errors
console.log(result.errors)
