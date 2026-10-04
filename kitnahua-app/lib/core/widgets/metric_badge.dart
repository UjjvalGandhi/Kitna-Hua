import 'package:flutter/material.dart';

import '../theme/app_theme_extension.dart';

enum MetricBadgeVariant { success, category, neutral }

/// Compact badge for financial metrics and comparisons.
class MetricBadge extends StatelessWidget {
  const MetricBadge({
    super.key,
    required this.text,
    this.icon,
    this.variant = MetricBadgeVariant.neutral,
    this.categoryColor,
    this.borderRadius = 999.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
    this.fontSize = 11.0,
  });

  final String text;
  final IconData? icon;
  final MetricBadgeVariant variant;
  final Color? categoryColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final Color bgColor;
    final Color textColor;
    final Border? border;

    switch (variant) {
      case MetricBadgeVariant.success:
        bgColor = appColors.success.withValues(alpha: 0.15);
        textColor = appColors.success;
        border = null;
      case MetricBadgeVariant.category:
        final c = categoryColor ?? theme.colorScheme.primary;
        bgColor = c.withValues(alpha: 0.15);
        textColor = c;
        border = null;
      case MetricBadgeVariant.neutral:
        bgColor = theme.colorScheme.surfaceContainer;
        textColor = theme.colorScheme.onSurfaceVariant;
        border = Border.all(
          color: theme.colorScheme.outlineVariant,
          width: 1.0,
        );
    }

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize + 2.0,
              color: textColor,
            ),
            const SizedBox(width: 4.0),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
