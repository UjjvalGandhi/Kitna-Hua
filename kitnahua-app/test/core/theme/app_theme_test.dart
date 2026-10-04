import 'package:ai_expense/core/theme/app_colors.dart';
import 'package:ai_expense/core/theme/app_radii.dart';
import 'package:ai_expense/core/theme/app_theme.dart';
import 'package:ai_expense/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Part A — Theme Fixes & Mockup Parity Tests', () {
    test('outline is darker than outlineVariant in light theme', () {
      final light = AppTheme.lightTheme;
      final outlineLuminance = light.colorScheme.outline.computeLuminance();
      final variantLuminance = light.colorScheme.outlineVariant
          .computeLuminance();

      expect(
        outlineLuminance,
        lessThan(variantLuminance),
        reason:
            'outline (#6F7976) must be darker than outlineVariant (#BFC9C5)',
      );
    });

    test(
      'every TextTheme style in dark theme has a light color (luminance > 0.5)',
      () {
        final darkTextTheme = AppTheme.darkTheme.textTheme;

        final styles = [
          darkTextTheme.displayLarge,
          darkTextTheme.displayMedium,
          darkTextTheme.displaySmall,
          darkTextTheme.headlineLarge,
          darkTextTheme.headlineMedium,
          darkTextTheme.headlineSmall,
          darkTextTheme.titleLarge,
          darkTextTheme.titleMedium,
          darkTextTheme.titleSmall,
          darkTextTheme.bodyLarge,
          darkTextTheme.bodyMedium,
          darkTextTheme.bodySmall,
          darkTextTheme.labelLarge,
          darkTextTheme.labelMedium,
          darkTextTheme.labelSmall,
        ];

        for (final style in styles) {
          expect(style, isNotNull);
          expect(style!.color, isNotNull);
          final lum = style.color!.computeLuminance();
          expect(
            lum,
            greaterThan(0.5),
            reason:
                'Dark theme text style with color ${style.color} must have luminance > 0.5',
          );
        }
      },
    );

    test(
      'no TextTheme style is smaller than 11sp in light and dark themes',
      () {
        for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
          final textTheme = theme.textTheme;
          final styles = [
            textTheme.displayLarge,
            textTheme.displayMedium,
            textTheme.displaySmall,
            textTheme.headlineLarge,
            textTheme.headlineMedium,
            textTheme.headlineSmall,
            textTheme.titleLarge,
            textTheme.titleMedium,
            textTheme.titleSmall,
            textTheme.bodyLarge,
            textTheme.bodyMedium,
            textTheme.bodySmall,
            textTheme.labelLarge,
            textTheme.labelMedium,
            textTheme.labelSmall,
          ];

          for (final style in styles) {
            expect(style, isNotNull);
            expect(
              style!.fontSize,
              greaterThanOrEqualTo(11),
              reason: 'Style $style font size must be >= 11sp',
            );
          }
        }
      },
    );

    test('AppRadii aliases match design system specifications', () {
      expect(AppRadii.card, equals(24.0));
      expect(AppRadii.row, equals(16.0));
      expect(AppRadii.iconTile, equals(12.0));
      expect(AppRadii.input, equals(12.0));
      expect(AppRadii.chip, equals(AppRadii.full));
      expect(AppRadii.pill, equals(AppRadii.full));
      expect(AppRadii.sheet, equals(28.0));
      expect(AppRadii.dialog, equals(28.0));
    });

    test('BottomSheet and Dialog theme radiuses match specifications', () {
      final light = AppTheme.lightTheme;
      // AdaptiveSheet draws its own grabber; a theme handle would duplicate it.
      expect(light.bottomSheetTheme.showDragHandle, isFalse);
      expect(light.cardTheme.shape, isA<RoundedRectangleBorder>());
      final cardShape = light.cardTheme.shape! as RoundedRectangleBorder;
      expect(cardShape.borderRadius, equals(AppRadii.cardBorderRadius));
    });

    test(
      'colorForCategory resolves standard 8 Indian categories with tints',
      () {
        final lightExt = AppThemeExtension.light;
        final darkExt = AppThemeExtension.dark;

        expect(
          lightExt.colorForCategory('Food & Dining'),
          equals(AppColors.catFoodDiningLight),
        );
        expect(
          darkExt.colorForCategory('Food & Dining'),
          equals(AppColors.catFoodDiningDark),
        );
        expect(
          lightExt.colorForCategory('Groceries'),
          equals(AppColors.catGroceriesLight),
        );
        expect(
          darkExt.colorForCategory('Groceries'),
          equals(AppColors.catGroceriesDark),
        );
        expect(
          lightExt.colorForCategory('Transport'),
          equals(AppColors.catTransportLight),
        );
        expect(
          darkExt.colorForCategory('Transport'),
          equals(AppColors.catTransportDark),
        );
        expect(
          lightExt.colorForCategory('Rent'),
          equals(AppColors.catRentLight),
        );
        expect(darkExt.colorForCategory('Rent'), equals(AppColors.catRentDark));
        expect(
          lightExt.colorForCategory('Utilities'),
          equals(AppColors.catUtilitiesLight),
        );
        expect(
          darkExt.colorForCategory('Utilities'),
          equals(AppColors.catUtilitiesDark),
        );
        expect(
          lightExt.colorForCategory('Entertainment'),
          equals(AppColors.catEntertainmentLight),
        );
        expect(
          darkExt.colorForCategory('Entertainment'),
          equals(AppColors.catEntertainmentDark),
        );
        expect(
          lightExt.colorForCategory('Health'),
          equals(AppColors.catHealthLight),
        );
        expect(
          darkExt.colorForCategory('Health'),
          equals(AppColors.catHealthDark),
        );
        expect(
          lightExt.colorForCategory('Shopping'),
          equals(AppColors.catShoppingLight),
        );
        expect(
          darkExt.colorForCategory('Shopping'),
          equals(AppColors.catShoppingDark),
        );
      },
    );
  });
}
