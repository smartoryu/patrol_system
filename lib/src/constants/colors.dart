import 'package:flutter/material.dart';

Color kPrimary = fromRGB("#233142");
Color kPrimary2 = fromRGB("#36506C");
Color kSecondary = fromRGB("#A5DEF1");
Color kSecondary2 = fromRGB("#EBF7FD");

Color kWhite = fromRGB("#FFFFFF");
Color kDanger = fromRGB("#F05454");

Color fromRGB(String e) {
  String R = e.substring(1, 3);
  String G = e.substring(3, 5);
  String B = e.substring(5, 7);
  int value = int.parse("0xFF$R$G$B");
  return Color(value);
}
