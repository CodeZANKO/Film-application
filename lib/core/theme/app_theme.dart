import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFF020617); // Deep slate black
  static const Color glassBase = Colors.white;
  static const Color primary = Color(0xFF38BDF8); // Cyan sky
  static const Color accent = Color(0xFFC084FC); // Purple accent
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color surface = Color(0xFF1E293B);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      textTheme:
          GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(
            color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        bodyMedium: const TextStyle(color: AppColors.textSecondary),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}

