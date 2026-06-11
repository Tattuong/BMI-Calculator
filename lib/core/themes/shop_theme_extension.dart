import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ShopThemeExtension extends ThemeExtension<ShopThemeExtension> {
  final Color primary;
  final Color primaryLight;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color onSurface;
  final Color onSurfaceVariant;
  final LinearGradient cardGradient;
  final LinearGradient splashGradient;

  const ShopThemeExtension({
    required this.primary,
    required this.primaryLight,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.cardGradient,
    required this.splashGradient,
  });

  static const defaultTheme = ShopThemeExtension(
    primary: AppColors.primary,
    primaryLight: AppColors.primaryLight,
    secondary: AppColors.secondary,
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceVariant: AppColors.surfaceVariant,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    cardGradient: AppColors.cardGradient,
    splashGradient: AppColors.splashGradient,
  );

  static const ocean = ShopThemeExtension(
    primary: Color(0xFF0284C7),
    primaryLight: Color(0xFF38BDF8),
    secondary: Color(0xFF0EA5E9),
    background: Color(0xFFF0F9FF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFBAE6FD),
    onSurface: Color(0xFF0C4A6E),
    onSurfaceVariant: Color(0xFF0369A1),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF0284C7), Color(0xFF0EA5E9)],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFBAE6FD), Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
    ),
  );

  static const sunset = ShopThemeExtension(
    primary: Color(0xFFEA580C),
    primaryLight: Color(0xFFFB923C),
    secondary: Color(0xFFF97316),
    background: Color(0xFFFFF7ED),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFFED7AA),
    onSurface: Color(0xFF7C2D12),
    onSurfaceVariant: Color(0xFFC2410C),
    cardGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEA580C), Color(0xFFF97316)],
    ),
    splashGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFED7AA), Color(0xFFFFF7ED), Color(0xFFFFEDD5)],
    ),
  );

  static const Map<String, ShopThemeExtension> byId = {
    'theme_ocean': ocean,
    'theme_sunset': sunset,
  };

  static ShopThemeExtension forThemeId(String? themeId) {
    if (themeId == null) return defaultTheme;
    return byId[themeId] ?? defaultTheme;
  }

  static ShopThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<ShopThemeExtension>() ?? defaultTheme;
  }

  @override
  ShopThemeExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? onSurface,
    Color? onSurfaceVariant,
    LinearGradient? cardGradient,
    LinearGradient? splashGradient,
  }) {
    return ShopThemeExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      cardGradient: cardGradient ?? this.cardGradient,
      splashGradient: splashGradient ?? this.splashGradient,
    );
  }

  @override
  ShopThemeExtension lerp(ThemeExtension<ShopThemeExtension>? other, double t) {
    if (other is! ShopThemeExtension) return this;
    return ShopThemeExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant: Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      cardGradient: cardGradient,
      splashGradient: splashGradient,
    );
  }
}
