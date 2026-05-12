import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class FontService {
  static const String _fontSizeKey = 'font_size_scale';
  static const String _fontFamilyKey = 'font_family';
  static final GetStorage _storage = GetStorage();

  static const Map<String, String> availableFonts = {
    'Poppins': 'poppins',
    'Roboto': 'roboto',
    'Open Sans': 'openSans',
    'Lato': 'lato',
    'Montserrat': 'montserrat',
  };

  static const Map<String, double> fontSizeScales = {
    'Small': 0.8,
    'Normal': 1.0,
    'Large': 1.2,
    'Extra Large': 1.4,
  };

  static double get currentFontScale =>
      _storage.read(_fontSizeKey) ?? fontSizeScales['Normal']!;

  static String get currentFontFamily =>
      _storage.read(_fontFamilyKey) ?? availableFonts['Poppins']!;

  static Future<void> setFontScale(double scale) async {
    await _storage.write(_fontSizeKey, scale);
  }

  static Future<void> setFontFamily(String fontFamily) async {
    await _storage.write(_fontFamilyKey, fontFamily);
  }

  static TextTheme getCustomTextTheme(
      TextTheme baseTheme,
      double fontScale,
      String fontFamily,
      ) {

    TextTheme getFontTheme() {
      switch (fontFamily) {
        case 'roboto':
          return GoogleFonts.robotoTextTheme(baseTheme);
        case 'openSans':
          return GoogleFonts.openSansTextTheme(baseTheme);
        case 'lato':
          return GoogleFonts.latoTextTheme(baseTheme);
        case 'montserrat':
          return GoogleFonts.montserratTextTheme(baseTheme);
        case 'poppins':
        default:
          return GoogleFonts.poppinsTextTheme(baseTheme);
      }
    }

    final theme = getFontTheme();

    return theme.copyWith(
      displayLarge: theme.displayLarge?.copyWith(
        fontSize: (baseTheme.displayLarge?.fontSize ?? 32) * fontScale,
      ),
      displayMedium: theme.displayMedium?.copyWith(
        fontSize: (baseTheme.displayMedium?.fontSize ?? 28) * fontScale,
      ),
      displaySmall: theme.displaySmall?.copyWith(
        fontSize: (baseTheme.displaySmall?.fontSize ?? 24) * fontScale,
      ),
      headlineMedium: theme.headlineMedium?.copyWith(
        fontSize: (baseTheme.headlineMedium?.fontSize ?? 20) * fontScale,
      ),
      titleLarge: theme.titleLarge?.copyWith(
        fontSize: (baseTheme.titleLarge?.fontSize ?? 18) * fontScale,
      ),
      bodyLarge: theme.bodyLarge?.copyWith(
        fontSize: (baseTheme.bodyLarge?.fontSize ?? 16) * fontScale,
      ),
      bodyMedium: theme.bodyMedium?.copyWith(
        fontSize: (baseTheme.bodyMedium?.fontSize ?? 14) * fontScale,
      ),
      labelLarge: theme.labelLarge?.copyWith(
        fontSize: (baseTheme.labelLarge?.fontSize ?? 14) * fontScale,
      ),
    );
  }
}
