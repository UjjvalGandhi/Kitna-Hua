import 'package:flutter/material.dart';

/// Semantic color tokens for light and dark themes matching Material 3 and design/mockups.html.
abstract final class AppColors {
  // Light Palette Core
  static const Color primaryLight = Color(0xFF006A60);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);
  static const Color primaryContainerLight = Color(0xFF74F8E5);
  static const Color onPrimaryContainerLight = Color(0xFF00201C);

  static const Color surfaceLight = Color(0xFFFAFDFB);
  static const Color surfaceContainerLowestLight = Color(0xFFFFFFFF);
  static const Color surfaceContainerLowLight = Color(0xFFF3F6F4);
  static const Color surfaceContainerLight = Color(0xFFEDF0EE);
  static const Color surfaceContainerHighLight = Color(0xFFE7EAE8);
  static const Color surfaceContainerHighestLight = Color(0xFFE1E4E2);

  static const Color onSurfaceLight = Color(0xFF191C1B);
  static const Color onSurfaceVariantLight = Color(0xFF3F4947);

  // Correct outline & outlineVariant mapping
  static const Color outlineLight = Color(0xFF6F7976);
  static const Color outlineVariantLight = Color(0xFFBFC9C5);

  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Color(0xFFFFFFFF);
  static const Color errorContainerLight = Color(0xFFFFDAD6);
  static const Color onErrorContainerLight = Color(0xFF410002);

  static const Color inverseSurfaceLight = Color(0xFF2E3130);
  static const Color onInverseSurfaceLight = Color(0xFFF0F1EF);
  static const Color inversePrimaryLight = Color(0xFF53DBC9);

  static const Color successLight = Color(0xFF186C45);
  static const Color onSuccessLight = Color(0xFFFFFFFF);

  static const Color warningLight = Color(0xFF935800);
  static const Color onWarningLight = Color(0xFFFFFFFF);

  // Dark Palette Core
  static const Color primaryDark = Color(0xFF53DBC9);
  static const Color onPrimaryDark = Color(0xFF003731);
  static const Color primaryContainerDark = Color(0xFF005048);
  static const Color onPrimaryContainerDark = Color(0xFF74F8E5);

  static const Color surfaceDark = Color(0xFF101413);
  static const Color surfaceContainerLowestDark = Color(0xFF0B0F0E);
  static const Color surfaceContainerLowDark = Color(0xFF181C1B);
  static const Color surfaceContainerDark = Color(0xFF1C201F);
  static const Color surfaceContainerHighDark = Color(0xFF272B2A);
  static const Color surfaceContainerHighestDark = Color(0xFF313634);

  static const Color onSurfaceDark = Color(0xFFE1E3E2);
  static const Color onSurfaceVariantDark = Color(0xFFBFC9C5);

  // Correct outline & outlineVariant mapping
  static const Color outlineDark = Color(0xFF899390);
  static const Color outlineVariantDark = Color(0xFF3F4947);

  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);
  static const Color errorContainerDark = Color(0xFF93000A);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6);

  static const Color inverseSurfaceDark = Color(0xFFE1E3E2);
  static const Color onInverseSurfaceDark = Color(0xFF2E3130);
  static const Color inversePrimaryDark = Color(0xFF006A60);

  static const Color successDark = Color(0xFF73DA9E);
  static const Color onSuccessDark = Color(0xFF00391F);

  static const Color warningDark = Color(0xFFFFB77A);
  static const Color onWarningDark = Color(0xFF4F2500);

  // General Constants
  static const Color scrim = Color(0xFF000000);
  static const Color shadow = Color(0xFF000000);
  static const Color surfaceTint = Colors.transparent;

  // 8 Category Colors (Light)
  static const Color catFoodDiningLight = Color(0xFFD95D39);
  static const Color catGroceriesLight = Color(0xFF2E7D32);
  static const Color catTransportLight = Color(0xFF0288D1);
  static const Color catRentLight = Color(0xFF6A1B9A);
  static const Color catUtilitiesLight = Color(0xFFE65100);
  static const Color catEntertainmentLight = Color(0xFFC2185B);
  static const Color catHealthLight = Color(0xFF00897B);
  static const Color catShoppingLight = Color(0xFF546E7A);

  // 8 Category Colors (Dark Tints)
  static const Color catFoodDiningDark = Color(0xFFFF8A65);
  static const Color catGroceriesDark = Color(0xFF81C784);
  static const Color catTransportDark = Color(0xFF4FC3F7);
  static const Color catRentDark = Color(0xFFBA68C8);
  static const Color catUtilitiesDark = Color(0xFFFFB74D);
  static const Color catEntertainmentDark = Color(0xFFF06292);
  static const Color catHealthDark = Color(0xFF4DB6AC);
  static const Color catShoppingDark = Color(0xFF90A4AE);
}
