import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import 'shop_theme_extension.dart';

class AppTheme {
  static ThemeData lightThemeFor(String? themeId) {
    final palette = ShopThemeExtension.forThemeId(themeId);
    return _buildLight(palette);
  }

  static ThemeData darkThemeFor(String? themeId) {
    final palette = ShopThemeExtension.forThemeId(themeId);
    return _buildDark(palette);
  }

  static ThemeData get lightTheme => _buildLight(ShopThemeExtension.defaultTheme);

  static ThemeData get darkTheme => _buildDark(ShopThemeExtension.defaultTheme);

  static ThemeData _buildLight(ShopThemeExtension palette) {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: palette.background,
      extensions: [palette],
      colorScheme: ColorScheme.light(
        primary: palette.primary,
        secondary: palette.secondary,
        surface: palette.surface,
        onPrimary: AppColors.onPrimary,
        onSurface: palette.onSurface,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: palette.onSurface,
        ),
        iconTheme: IconThemeData(color: palette.onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceVariant.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      cardTheme: CardThemeData(
        color: palette.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData _buildDark(ShopThemeExtension palette) {
    final darkBg = Color.lerp(palette.onSurface, Colors.black, 0.85)!;
    final darkSurface = Color.lerp(palette.onSurface, Colors.black, 0.7)!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBg,
      extensions: [palette],
      colorScheme: ColorScheme.dark(
        primary: palette.primaryLight,
        secondary: palette.secondary,
        surface: darkSurface,
        onSurface: palette.surfaceVariant,
      ),
      textTheme: GoogleFonts.nunitoTextTheme(ThemeData.dark().textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: palette.surfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
