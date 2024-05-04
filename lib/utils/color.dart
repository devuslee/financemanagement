import 'package:flutter/material.dart';

hexStringToColor(String code) {
  return Color(int.parse(code.substring(0, 6), radix: 16) + 0xFF000000);
}