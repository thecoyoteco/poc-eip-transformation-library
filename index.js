const fs = require('fs')
// require the library in your code
const { TransformerFactory, TransformerTypes } = require('eip-transformation-library')

// here I'm loading couple of files that contains a Variant Report xml file and an XSL file to transform it
const xml = fs.readFileSync('./examples/variant-report-2.2.xml')
const xsl = fs.readFileSync('./examples/variant-report-2.2-to-external.xsl')
const xsd = fs.readFileSync('./examples/variant-report-2.2-external.xsd')
const jsonSchema = fs.readFileSync('./examples/variant-report-2.2-external-schema.json')

// here I'm getting an instance of the Variant Report transformer by making use of the FActory
const transformer = TransformerFactory.getInstance(TransformerTypes.variantReportTransformer)

// example transforming XML Variant Report
// by calling the transformXml method and passing over the XML content and also the XSL content
const result = transformer.transformXml(xml.toString(), xsl.toString(), xsd.toString())

// here printing the result of the transformation
if (result.errors.length === 0) {
  console.log('--- example XML Variant Report transformed from internal to external FMI------\n\n', result.content)
  fs.writeFileSync('./output/transformed.xml', result.content)
}

// example transforming XML Variant Report and convert to JSON
const jsonResult = transformer.transformXmlAndConvertToJson(xml.toString(), xsl.toString(),xsd.toString(),jsonSchema.toString())
if (jsonResult.errors.length === 0) {
  fs.writeFileSync('./output/transformed.json', JSON.stringify(JSON.parse(jsonResult.content), null, 2))
  console.log('--- example XML Variant Report transformed from internal to external FMI and converted to JSON format------\n\n', JSON.stringify(JSON.parse(jsonResult.content), null, 2))
}


