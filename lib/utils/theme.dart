import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Soft pink, light modern theme
class AppTheme {
  // Soft pink color palette
  static const Color primaryPink = Color(0xFFFFB6C1); // Soft pink
  static const Color secondaryPink = Color(0xFFFFC0CB); // Light pink
  static const Color accentPink = Color(0xFFFADADD); // Very light pink
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color textColor = Color(0xFF333333);
  static const Color secondaryTextColor = Color(0xFF777777);
  static const Color accentColor = Color(0xFFE91E63); // Vibrant pink

  // Glassmorphism effect colors
  static const Color glassBackgroundColor = Color(0x80FFFFFF); // 50% white
  static const Color glassBorderColor = Color(0x80FFB6C1); // 50% soft pink

  // Luxury Material 3 theme
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPink,
        primary: primaryPink,
        secondary: secondaryPink,
        surface: whiteColor,
        onSurface: textColor,
        error: Colors.red,
        brightness: Brightness.light,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          elevation: 4,
          textStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPink,
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPink,
          side: BorderSide(color: primaryPink, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: glassBorderColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryPink, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: TextStyle(color: secondaryTextColor),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: secondaryTextColor,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: whiteColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: primaryPink.withValues(alpha: 0.2),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: whiteColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: whiteColor,
        selectedItemColor: primaryPink,
        unselectedItemColor: secondaryTextColor,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(),
        elevation: 8,
      ),
    );
  }

  // Glassmorphism container decoration
  static BoxDecoration get glassBoxDecoration {
    return BoxDecoration(
      color: glassBackgroundColor,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: glassBorderColor, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  // Gradient header decoration
  static BoxDecoration get gradientHeader {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryPink,
          secondaryPink,
          Color(0xFFFF9AA2),
        ],
        stops: [0.0, 0.6, 1.0],
      ),
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      boxShadow: [
        BoxShadow(
          color: primaryPink.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: Offset(0, 10),
        ),
      ],
    );
  }
}
