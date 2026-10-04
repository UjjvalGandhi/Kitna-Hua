import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';

/// Progress bar for tracking budget utilization.
/// Height 10, full radius, outlineVariant track.
/// Color turns warning at >= 80% and error at >= 100%.
class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.progress,
    this.height = 10.0,
  });

  /// Fraction between 0.0 and 1.0 (or greater if over budget).
  final double progress;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final Color fillColor;
    if (progress >= 1.0) {
      fillColor = theme.colorScheme.error;
    } else if (progress >= 0.80) {
      fillColor = appColors.warning;
    } else {
      fillColor = theme.colorScheme.primary;
    }

    final clampedProgress = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final fillWidth = totalWidth * clampedProgress;

        return Container(
          width: totalWidth,
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: fillWidth,
            height: height,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      },
    );
  }
}
