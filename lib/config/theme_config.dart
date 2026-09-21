import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenly/app/routes/app_pages.dart';
import 'package:screenly/utils/preferences_utils.dart';

// Define the enum for themes
enum AppTheme { light, dark }

class ThemeConfig {
  // Define all themes here
  static final Map<AppTheme, ThemeColors> themes = {
    AppTheme.light: ThemeColors(
      primary: const Color(0xffFFD771),
      primaryDark: const Color(0xffEBBD47),
      primaryLight: const Color(0xffFAEED1),
      secondary: const Color(0xff4484FF),
      secondaryDark: const Color(0xff477EEB),
      secondaryLight: const Color(0xffD1DFFA),
      secondaryDisabled: const Color(0xff84AAF4),
      tertiary: const Color(0xffFFA471),
      tertiaryDark: const Color(0xffEB8247),
      tertiaryLight: const Color(0xffFAE0D1),
      fontPrimary: const Color(0xffFFFFFF),
      fontSecondary: const Color(0xff1F2140),
      white: const Color.fromARGB(255, 255, 255, 255),
      black: const Color.fromARGB(255, 0, 0, 0),
    ),
    AppTheme.dark: ThemeColors(
      primary: const Color(0xffE57373),
      primaryDark: const Color(0xffD32F2F),
      primaryLight: const Color(0xffFFCDD2),
      secondary: const Color(0xff64B5F6),
      secondaryDark: const Color(0xff1976D2),
      secondaryLight: const Color(0xffBBDEFB),
      secondaryDisabled: const Color(0xff84AAF4),
      tertiary: const Color(0xff81C784),
      tertiaryDark: const Color(0xff388E3C),
      tertiaryLight: const Color(0xffC8E6C9),
      fontPrimary: const Color(0xffFFFFFF),
      fontSecondary: const Color(0xff1F2140),
      white: const Color.fromARGB(255, 255, 255, 255),
      black: const Color.fromARGB(255, 0, 0, 0),
    ),
  };

  // Define the current theme
  static AppTheme currentTheme = AppTheme.light;

  // Getter for current theme colors
  static ThemeColors get currentThemeColors => themes[currentTheme]!;

  // Method to switch themes
  static void switchTheme(AppTheme theme) {
    currentTheme = theme;
    PreferencesUtils.addTheme(theme.name);
    Get.offAllNamed(Routes.HOME);
    debugPrint('THEME CHANGED INTO: ${theme.name}');
  }

  static Future<dynamic> getCurrentTheme() async {
    var currTheme = await PreferencesUtils.getTheme();
    if (currTheme == null) {
      PreferencesUtils.addTheme(currentTheme.name);
    } else {
      AppTheme theme = AppTheme.values
          .firstWhere((e) => e.toString().split('.').last == currTheme);
      currentTheme = theme;
    }
    return currTheme;
  }
}

class ThemeColors {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color secondaryDark;
  final Color secondaryLight;
  final Color secondaryDisabled;
  final Color tertiary;
  final Color tertiaryDark;
  final Color tertiaryLight;
  final Color fontPrimary;
  final Color fontSecondary;
  final Color white;
  final Color black;

  ThemeColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.secondaryDark,
    required this.secondaryLight,
    required this.secondaryDisabled,
    required this.tertiary,
    required this.tertiaryDark,
    required this.tertiaryLight,
    required this.fontPrimary,
    required this.fontSecondary,
    required this.white,
    required this.black,
  });
}

// Access the current theme's colors
Color get primaryColor => ThemeConfig.currentThemeColors.primary;
Color get primaryDarkColor => ThemeConfig.currentThemeColors.primaryDark;
Color get primaryLightColor => ThemeConfig.currentThemeColors.primaryLight;

Color get secondaryColor => ThemeConfig.currentThemeColors.secondary;
Color get secondaryDarkColor => ThemeConfig.currentThemeColors.secondaryDark;
Color get secondaryLightColor => ThemeConfig.currentThemeColors.secondaryLight;
Color get secondaryDisabledColor =>
    ThemeConfig.currentThemeColors.secondaryDisabled;

Color get tertiaryColor => ThemeConfig.currentThemeColors.tertiary;
Color get tertiaryDarkColor => ThemeConfig.currentThemeColors.tertiaryDark;
Color get tertiaryLightColor => ThemeConfig.currentThemeColors.tertiaryLight;

Color get fontPrimaryColor => ThemeConfig.currentThemeColors.fontPrimary;
Color get fontSecondaryColor => ThemeConfig.currentThemeColors.fontSecondary;

Color get whiteColor => ThemeConfig.currentThemeColors.white;
Color get blackColor => ThemeConfig.currentThemeColors.black;
