import 'dart:core';

List<String> matchExpressions(String input, List<RegExp> regexList) {
  List<String> matchingStrings = [];
  for (RegExp regex in regexList) {
    Iterable<Match> matches = regex.allMatches(input);
    for (Match match in matches) {
      matchingStrings.add(match.group(0)!);
    }
  }
  return matchingStrings;
}

void main() {
  String inputString = "Acesta este un exemplu de test cu expresii regulate.";
  List<RegExp> regexList = [
    RegExp(r'\bexemplu\b'),
    RegExp(r'\btest\b'),
    RegExp(r'\bexpresii\b'),
  ];

  List<String> result = matchExpressions(inputString, regexList);
  print("Rezultatul este: $result");
}
