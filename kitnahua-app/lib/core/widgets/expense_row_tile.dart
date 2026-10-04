import 'package:flutter/material.dart';

import '../theme/app_radii.dart';
import '../theme/app_theme_extension.dart';
import '../theme/app_typography.dart';
import '../utils/money_formatter.dart';
import 'icon_tile.dart';

/// Row tile displaying an expense with category icon, merchant title,
/// category subtitle, and right-aligned tabular amount with payment badge.
class ExpenseRowTile extends StatelessWidget {
  const ExpenseRowTile({
    super.key,
    required this.title,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.amountMinor,
    required this.paymentLabel,
    this.isCardPayment = false,
    this.onTap,
  });

  final String title;
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final int amountMinor;
  final String paymentLabel;
  final bool isCardPayment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final tileContent = Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.rowBorderRadius,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // 36x36 IconTile
          IconTile(
            size: 36.0,
            borderRadius: 12.0,
            backgroundColor: appColors.categoryTint(categoryColor),
            icon: categoryIcon,
            iconSize: 18.0,
            iconColor: categoryColor,
          ),
          const SizedBox(width: 12.0),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Text(
                  categoryName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Right aligned Amount and payment badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MoneyFormatter.formatPaise(amountMinor),
                style: theme.textTheme.labelMedium?.withTabularFigures.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2.0),
              if (isCardPayment)
                Text(
                  paymentLabel,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                )
              else
                Text(
                  paymentLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: AppRadii.rowBorderRadius,
        child: tileContent,
      );
    }

    return tileContent;
  }
}
