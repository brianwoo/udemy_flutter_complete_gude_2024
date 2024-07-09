import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getQATextStyle({
  Color? color,
  FontWeight? fontWeight,
  double? fontSize,
}) {
  return GoogleFonts.lato(
    textStyle: TextStyle(color: color, fontWeight: fontWeight),
    fontSize: fontSize,
  );
}
