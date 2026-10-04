import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

/// Custom theme extension providing category colors with light/dark tints,
/// semantic containers, and edge-to-edge system overlay styles.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.isDark,
    required this.foodDining,
    required this.groceries,
    required this.transport,
    required this.rent,
    required this.utilities,
    required this.entertainment,
    required this.health,
    required this.shopping,
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.glassTint,
    required this.primaryGlassTint,
    required this.glassBorderColor,
    required this.glassBlurSigma,
    required this.glassShadow,
    required this.systemUiOverlayStyle,
  });

  final bool isDark;
  final Color foodDining;
  final Color groceries;
  final Color transport;
  final Color rent;
  final Color utilities;
  final Color entertainment;
  final Color health;
  final Color shopping;
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color glassTint;
  final Color primaryGlassTint;
  final Color glassBorderColor;
  final double glassBlurSigma;
  final BoxShadow glassShadow;
  final SystemUiOverlayStyle systemUiOverlayStyle;

  static const light = AppThemeExtension(
    isDark: false,
    foodDining: AppColors.catFoodDiningLight,
    groceries: AppColors.catGroceriesLight,
    transport: AppColors.catTransportLight,
    rent: AppColors.catRentLight,
    utilities: AppColors.catUtilitiesLight,
    entertainment: AppColors.catEntertainmentLight,
    health: AppColors.catHealthLight,
    shopping: AppColors.catShoppingLight,
    success: AppColors.successLight,
    onSuccess: AppColors.onSuccessLight,
    successContainer: Color(0x26186C45), // 15% opacity
    warning: AppColors.warningLight,
    onWarning: AppColors.onWarningLight,
    warningContainer: Color(0x26935800), // 15% opacity
    glassTint: Color(0x8CF9F9F9), // 55% surface light
    primaryGlassTint: Color(0x33006A60), // 20% primary light
    glassBorderColor: Color(0x59FFFFFF), // 35% white
    glassBlurSigma: 20.0,
    glassShadow: BoxShadow(
      color: Color(0x14000000), // subtle shadow
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
    systemUiOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  static const dark = AppThemeExtension(
    isDark: true,
    foodDining: AppColors.catFoodDiningDark,
    groceries: AppColors.catGroceriesDark,
    transport: AppColors.catTransportDark,
    rent: AppColors.catRentDark,
    utilities: AppColors.catUtilitiesDark,
    entertainment: AppColors.catEntertainmentDark,
    health: AppColors.catHealthDark,
    shopping: AppColors.catShoppingDark,
    success: AppColors.successDark,
    onSuccess: AppColors.onSuccessDark,
    successContainer: Color(0x2673DA9E), // 15% opacity
    warning: AppColors.warningDark,
    onWarning: AppColors.onWarningDark,
    warningContainer: Color(0x26FFB77A), // 15% opacity
    glassTint: Color(0x73161D1B), // 45% surface dark
    primaryGlassTint: Color(0x3373DA9E), // 20% primary dark
    glassBorderColor: Color(0x26FFFFFF), // 15% white
    glassBlurSigma: 20.0,
    glassShadow: BoxShadow(
      color: Color(0x3D000000), // subtle dark shadow
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
    systemUiOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  /// Resolves the background tint for an icon tile (15% in light, 20% in dark).
  Color categoryTint(Color color) {
    return color.withValues(alpha: isDark ? 0.20 : 0.15);
  }

  /// Resolves the corresponding category color for a category name.
  Color colorForCategory(String categoryName) {
    final normalized = categoryName.trim().toLowerCase();
    if (normalized.contains('food') || normalized.contains('dining')) {
      return foodDining;
    }
    if (normalized.contains('grocer')) {
      return groceries;
    }
    if (normalized.contains('transport')) {
      return transport;
    }
    if (normalized.contains('rent') || normalized.contains('housing')) {
      return rent;
    }
    if (normalized.contains('utilit') || normalized.contains('bill')) {
      return utilities;
    }
    if (normalized.contains('entertain')) {
      return entertainment;
    }
    if (normalized.contains('health')) {
      return health;
    }
    if (normalized.contains('shop')) {
      return shopping;
    }
    return shopping;
  }

  @override
  AppThemeExtension copyWith({
    bool? isDark,
    Color? foodDining,
    Color? groceries,
    Color? transport,
    Color? rent,
    Color? utilities,
    Color? entertainment,
    Color? health,
    Color? shopping,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? glassTint,
    Color? primaryGlassTint,
    Color? glassBorderColor,
    double? glassBlurSigma,
    BoxShadow? glassShadow,
    SystemUiOverlayStyle? systemUiOverlayStyle,
  }) {
    return AppThemeExtension(
      isDark: isDark ?? this.isDark,
      foodDining: foodDining ?? this.foodDining,
      groceries: groceries ?? this.groceries,
      transport: transport ?? this.transport,
      rent: rent ?? this.rent,
      utilities: utilities ?? this.utilities,
      entertainment: entertainment ?? this.entertainment,
      health: health ?? this.health,
      shopping: shopping ?? this.shopping,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      glassTint: glassTint ?? this.glassTint,
      primaryGlassTint: primaryGlassTint ?? this.primaryGlassTint,
      glassBorderColor: glassBorderColor ?? this.glassBorderColor,
      glassBlurSigma: glassBlurSigma ?? this.glassBlurSigma,
      glassShadow: glassShadow ?? this.glassShadow,
      systemUiOverlayStyle: systemUiOverlayStyle ?? this.systemUiOverlayStyle,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      isDark: t < 0.5 ? isDark : other.isDark,
      foodDining: Color.lerp(foodDining, other.foodDining, t)!,
      groceries: Color.lerp(groceries, other.groceries, t)!,
      transport: Color.lerp(transport, other.transport, t)!,
      rent: Color.lerp(rent, other.rent, t)!,
      utilities: Color.lerp(utilities, other.utilities, t)!,
      entertainment: Color.lerp(entertainment, other.entertainment, t)!,
      health: Color.lerp(health, other.health, t)!,
      shopping: Color.lerp(shopping, other.shopping, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(successContainer, other.successContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(warningContainer, other.warningContainer, t)!,
      glassTint: Color.lerp(glassTint, other.glassTint, t)!,
      primaryGlassTint: Color.lerp(primaryGlassTint, other.primaryGlassTint, t)!,
      glassBorderColor: Color.lerp(glassBorderColor, other.glassBorderColor, t)!,
      glassBlurSigma: ui.lerpDouble(glassBlurSigma, other.glassBlurSigma, t)!,
      glassShadow: BoxShadow.lerp(glassShadow, other.glassShadow, t)!,
      systemUiOverlayStyle: other.systemUiOverlayStyle,
    );
  }
}

/// Convenience extension on [BuildContext] to access [AppThemeExtension].
extension AppThemeContextExtension on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>() ?? AppThemeExtension.light;
}
