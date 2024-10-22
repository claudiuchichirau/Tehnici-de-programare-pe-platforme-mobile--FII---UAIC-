import 'dart:convert';
import 'dart:io';

Map<String, dynamic> jsonSubJson(String jsonPath1, String jsonPath2) {
  final file1 = File(jsonPath1);
  final file2 = File(jsonPath2);

  final jsonString1 = file1.readAsStringSync();
  final jsonString2 = file2.readAsStringSync();

  final Map<String, dynamic> map1 = json.decode(jsonString1);
  final Map<String, dynamic> map2 = json.decode(jsonString2);

  // Subtract map2 from map1 (remove common nodes)
  final Map<String, dynamic> result = {};
  map1.forEach((key, value) {
    if (!map2.containsKey(key)) {
      result[key] = value;
    }
  });

  return result;
}

void main() {
  final jsonPath1 = 'firstJSON.json';
  final jsonPath2 = 'secondJSON.json';

  final subtractedJson = jsonSubJson(jsonPath1, jsonPath2);
  print('Diferenta: ' + json.encode(subtractedJson));
}
