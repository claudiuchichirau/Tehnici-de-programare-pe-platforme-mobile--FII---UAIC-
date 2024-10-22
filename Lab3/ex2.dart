import 'package:xml/xml.dart' as xml;

class Example {
  int varA;
  int varB;
  String varC;
  List<int> varD;
  double varE;

  Example({
    required this.varA,
    required this.varB,
    required this.varC,
    required this.varD,
    required this.varE,
  });

factory Example.fromXml(String str) {
  var document = xml.XmlDocument.parse(str);
  return Example(
    varA: int.parse(document.findAllElements('varA').first.text), // parseaza varA ca un int
    varB: int.parse(document.findAllElements('varB').first.text), // parseaza varB ca un int
    varC: document.findAllElements('varC').first.text,  // parseaza varC ca un string
    varD: document.findAllElements('varD').first.text // parseaza varD ca o lista de string-uri
        .split(',')
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .toList(),
    varE: double.parse(document.findAllElements('varE').first.text),  // parseaza varE ca un double
  );
}

String toXml() {
  var builder = xml.XmlBuilder();
  builder.processing('xml', 'version="1.0"');   // 
  builder.element('Example', nest: () {
    builder.element('varA', nest: varA);
    builder.element('varB', nest: varB);
    builder.element('varC', nest: varC);
    builder.element('varD', nest: () {
      for (var value in varD) {
        builder.element('value', nest: value);
      }
    });
    builder.element('varE', nest: varE);
  });
  return builder.buildDocument().toXmlString(pretty: true);
}

}


void main() {
  var example = Example(
    varA: 1,
    varB: 2,
    varC: 'Test',
    varD: [3, 4, 5],
    varE: 6.7,
  );

  String xmlString = example.toXml();
  print('\nXML String:\n$xmlString');

  var newExample = Example.fromXml(xmlString);
  print('\nExample from XML:');
  print('varA: ${newExample.varA}');
  print('varB: ${newExample.varB}');
  print('varC: ${newExample.varC}');
  print('varD: ${newExample.varD}');
  print('varE: ${newExample.varE}');
}