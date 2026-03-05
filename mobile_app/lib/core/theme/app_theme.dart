import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// نظام تصميم "فجر الطين" - أشكال عضوية، فخامة دافئة. RTL.
class AppTheme {
  AppTheme._();

  static const double _spaceBase = 6.0;

  static double get space1 => _spaceBase;
  static double get space2 => _spaceBase * 2;
  static double get space3 => _spaceBase * 3;
  static double get space4 => _spaceBase * 4;
  static double get space5 => _spaceBase * 5;
  static double get space6 => _spaceBase * 6;
  static double get space8 => _spaceBase * 8;
  static double get space10 => _spaceBase * 10;

  // Organic, soft shapes - pill-like radii
  static BorderRadius get radiusSmall => BorderRadius.circular(16);
  static BorderRadius get radiusMedium => BorderRadius.circular(24);
  static BorderRadius get radiusLarge => BorderRadius.circular(32);
  static BorderRadius get radiusXLarge => BorderRadius.circular(48);
  static BorderRadius get radiusPill => BorderRadius.circular(999);

  static ThemeData get luxuryTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.peach,
        onPrimary: Colors.white,
        secondary: AppColors.peachDark,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: Color(0xFFC45C4A),
      ),
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Tajawal',
      textTheme: _textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.tajawal(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: -0.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusMedium),
        color: AppColors.cardBackground,
        clipBehavior: Clip.antiAlias,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(borderRadius: radiusSmall),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusSmall,
          borderSide: const BorderSide(color: AppColors.stone, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusSmall,
          borderSide: const BorderSide(color: AppColors.peach, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: space4, vertical: space3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: space6, vertical: space3),
          shape: RoundedRectangleBorder(borderRadius: radiusSmall),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.peach,
        unselectedItemColor: AppColors.textSecondary,
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.tajawal(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: -0.8,
      ),
      displayMedium: GoogleFonts.tajawal(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.tajawal(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.tajawal(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.tajawal(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.6,
      ),
      bodySmall: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.tajawal(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.tajawal(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.tajawal(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }
}
