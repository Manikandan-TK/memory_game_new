import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Modern, vibrant color palette
  static const Color primaryColor = Color(0xFF6366F1);    // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6);  // Purple
  static const Color accentColor = Color(0xFFEC4899);     // Pink
  static const Color backgroundColor = Color(0xFF0F172A);  // Dark blue
  static const Color surfaceColor = Color(0xFF1E293B);    // Slate 800
  static const Color cardColor = Color(0xFF334155);       // Slate 700
  
  // Text colors
  static const Color headingColor = Color(0xFFE2E8F0);    // Light gray/white
  static const Color bodyTextColor = Color(0xFFF8FAFC);   // Almost white
  static const Color subtitleColor = Color(0xFFCBD5E1);   // Light gray

  // Gradient colors
  static const Color gradientStart = Color(0xFF3B82F6);   // Blue
  static const Color gradientMiddle = Color(0xFF8B5CF6);  // Purple
  static const Color gradientEnd = Color(0xFFEC4899);     // Pink

  // Spacing scale
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusRound = 999.0;

  // Opacity values
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.15;
  static const double opacityMedium = 0.3;
  static const double opacityHigh = 0.87;

  // Animation durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationMedium = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // Animation curves
  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveDemphasized = Curves.easeInCubic;

  static TextTheme _buildTextTheme(TextTheme base, Color textColor) {
    return base.copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        letterSpacing: -1.5,
        height: 1.1,
        color: headingColor,
      ),
      displayMedium: GoogleFonts.spaceGrotesk(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        height: 1.1,
        color: headingColor,
      ),
      displaySmall: GoogleFonts.spaceGrotesk(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        color: headingColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        color: bodyTextColor,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: bodyTextColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: bodyTextColor,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: bodyTextColor,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: bodyTextColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: bodyTextColor,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: subtitleColor,
      ),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ).copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      textTheme: _buildTextTheme(base.textTheme, Colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ).copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardTheme(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: cardColor,
      ),
      textTheme: _buildTextTheme(base.textTheme, Colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
