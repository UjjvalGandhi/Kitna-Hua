import 'package:flutter/material.dart';

/// Typography definitions using bundled Inter font asset with Material 3 styling.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  /// Creates a complete Material 3 [TextTheme] with all 15 typography styles
  /// built from the brightness-correct base.
  ///
  /// - Primary text styles use [onSurface].
  /// - Only [TextTheme.bodySmall] and [TextTheme.labelSmall] use [onSurfaceVariant].
  /// - Minimum size across all styles is strictly 11sp.
  static TextTheme createTextTheme({
    required Brightness brightness,
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    final base = brightness == Brightness.light
        ? Typography.material2021(platform: TargetPlatform.android).black
        : Typography.material2021(platform: TargetPlatform.android).white;

    return base.copyWith(
      displayLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ).copyWith(color: onSurface),
      displayMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ).copyWith(color: onSurface),
      displaySmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ).copyWith(color: onSurface),

      headlineLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ).copyWith(color: onSurface),
      headlineMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 26,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ).copyWith(color: onSurface),
      headlineSmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ).copyWith(color: onSurface),

      titleLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ).copyWith(color: onSurface),
      titleMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ).copyWith(color: onSurface),
      titleSmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ).copyWith(color: onSurface),

      bodyLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ).copyWith(color: onSurface),
      bodyMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ).copyWith(color: onSurface),
      bodySmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ).copyWith(color: onSurfaceVariant),

      labelLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ).copyWith(color: onSurface),
      labelMedium: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ).copyWith(color: onSurface),
      labelSmall: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.2,
      ).copyWith(color: onSurfaceVariant),
    );
  }
}

/// Helper extension to enable tabular figures for aligned numeric currency displays.
extension TabularFiguresExtension on TextStyle {
  TextStyle get tabularFigures =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);

  TextStyle get withTabularFigures =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
