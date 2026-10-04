import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/budget_progress_bar.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../categories/data/categories_data.dart';
import '../../dashboard/data/dashboard_providers.dart';

/// Monthly budgets: overall limit plus per-category limits.
class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final totalSpentMinor = ref.watch(totalSpentMonthProvider);
    final overallBudgetMinor = ref.watch(monthlyBudgetProvider);
    final groceryBudgetMinor = ref.watch(groceryBudgetProvider);
    final breakdown = ref.watch(categorySpendBreakdownProvider);

    var grocerySpent = 0;
    for (final item in breakdown) {
      if (item.categoryId == 'groceries') grocerySpent = item.amountMinor;
    }
    final groceries = CategoriesData.findById('groceries');
    final groceriesColor = appColors.colorForCategory(groceries.name);

    return AdaptiveScrollPage(
      title: 'Budgets',
      children: [
        _BudgetCard(
          title: 'Overall monthly budget',
          icon: Icons.account_balance_wallet_outlined,
          color: theme.colorScheme.primary,
          spentMinor: totalSpentMinor,
          limitMinor: overallBudgetMinor,
        ),
        const SizedBox(height: 12.0),
        _BudgetCard(
          title: groceries.name,
          icon: groceries.icon,
          color: groceriesColor,
          spentMinor: grocerySpent,
          limitMinor: groceryBudgetMinor,
        ),
      ],
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.spentMinor,
    required this.limitMinor,
  });

  final String title;
  final IconData icon;
  final Color color;
  final int spentMinor;
  final int limitMinor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final progress = limitMinor == 0 ? 0.0 : spentMinor / limitMinor;
    final percent = (progress * 100).round();
    final remainingMinor = limitMinor - spentMinor;
    final statusColor = progress >= 1.0
        ? theme.colorScheme.error
        : progress >= 0.8
        ? appColors.warning
        : theme.colorScheme.onSurface;

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconTile(
                size: 36.0,
                borderRadius: 12.0,
                backgroundColor: appColors.categoryTint(color),
                icon: icon,
                iconSize: 18.0,
                iconColor: color,
              ),
              const SizedBox(width: 12.0),
              Expanded(child: Text(title, style: theme.textTheme.titleSmall)),
              Text(
                '$percent%',
                style: theme.textTheme.labelLarge?.withTabularFigures.copyWith(
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            '${MoneyFormatter.formatPaise(spentMinor)} of '
            '${MoneyFormatter.formatPaise(limitMinor)}',
            style: theme.textTheme.bodyLarge?.withTabularFigures.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          BudgetProgressBar(progress: progress),
          const SizedBox(height: 6.0),
          Text(
            remainingMinor >= 0
                ? '${MoneyFormatter.formatPaise(remainingMinor)} left'
                : '${MoneyFormatter.formatPaise(-remainingMinor)} over budget',
            style: theme.textTheme.bodySmall?.copyWith(
              color: remainingMinor >= 0 ? null : theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
