import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screenly/config/theme_config.dart';

class TextConfig {
  static TextStyle heading1TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w800,
    color: fontSecondaryColor,
    fontSize: 40.sp,
    height: 0.9,
  );
  static TextStyle heading2TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w800,
    color: fontSecondaryColor,
    fontSize: 36.sp,
    height: 0.9,
  );
  static TextStyle heading3TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    color: fontSecondaryColor,
    fontSize: 32.sp,
    height: 0.9,
  );
  static TextStyle heading4TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    color: fontSecondaryColor,
    fontSize: 24.sp,
    height: 0.9,
  );
  static TextStyle heading5TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: fontSecondaryColor,
    fontSize: 20.sp,
    height: 0.9,
  );
  static TextStyle heading6TextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    color: fontSecondaryColor,
    fontSize: 16.sp,
    height: 0.9,
  );
  static TextStyle paragraphLargeTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: fontSecondaryColor,
    fontSize: 20.sp,
    height: 0.9,
  );
  static TextStyle paragraphRegulerTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: fontSecondaryColor,
    fontSize: 16.sp,
    height: 0.9,
  );
  static TextStyle paragraphSmallTextStyle = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    color: fontSecondaryColor,
    fontSize: 14.sp,
    height: 0.9,
  );
}

TextStyle get heading1TextStyle => TextConfig.heading1TextStyle;

TextStyle get heading2TextStyle => TextConfig.heading2TextStyle;

TextStyle get heading3TextStyle => TextConfig.heading3TextStyle;

TextStyle get heading4TextStyle => TextConfig.heading4TextStyle;

TextStyle get heading5TextStyle => TextConfig.heading5TextStyle;

TextStyle get heading6TextStyle => TextConfig.heading6TextStyle;

TextStyle get paragraphLargeTextStyle => TextConfig.paragraphLargeTextStyle;

TextStyle get paragraphRegulerTextStyle => TextConfig.paragraphRegulerTextStyle;

TextStyle get paragraphSmallTextStyle => TextConfig.paragraphSmallTextStyle;
