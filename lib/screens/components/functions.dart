import 'package:flutter/material.dart';

Color colorByHtmlCode(String htmlColor) {
  String valueString = "FF$htmlColor".replaceFirst(RegExp(r'#'), '');
  int value = int.parse(valueString, radix: 16);
  return Color(value);
}
