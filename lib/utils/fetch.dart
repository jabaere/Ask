import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> fetchWords() async {
  String jsonString = await rootBundle.loadString('words.json');
  List<dynamic> parsedJson = jsonDecode(jsonString);
  return parsedJson.cast<String>();
}
