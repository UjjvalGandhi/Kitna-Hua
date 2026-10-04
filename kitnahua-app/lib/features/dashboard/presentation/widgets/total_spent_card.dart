import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../core/widgets/budget_progress_bar.dart';
import '../../../../core/widgets/metric_badge.dart';
import '../../data/dashboard_providers.dart';

/// Total spend summary card with budget progress bar.
class TotalSpentCard extends ConsumerWidget {
  const TotalSpentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalSpentMinor = ref.watch(totalSpentMonthProvider);
    final budgetLimitMinor = ref.watch(monthlyBudgetProvider);

    final remainingMinor = (budgetLimitMinor - totalSpentMinor).clamp(
      0,
      budgetLimitMinor,
    );
    final percentUsed = ((totalSpentMinor / budgetLimitMinor) * 100).round();
    final progressFraction = (totalSpentMinor / budgetLimitMinor).clamp(
      0.0,
      1.0,
    );

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row with spent amount and comparison badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Spent this Month',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      MoneyFormatter.formatPaise(totalSpentMinor),
                      style: theme.textTheme.displaySmall?.withTabularFigures
                          .copyWith(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                            color: theme.colorScheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              const MetricBadge(
                text: '12% vs same days in Sep',
                icon: Icons.trending_down,
                variant: MetricBadgeVariant.success,
                borderRadius: 8.0,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                fontSize: 11.0,
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // 30% opacity divider
          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.30),
            height: 1.0,
            thickness: 1.0,
          ),
          const SizedBox(height: 12.0),

          // Budget row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Monthly Budget: ${MoneyFormatter.formatPaise(budgetLimitMinor)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '$percentUsed% used',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Progress bar
          BudgetProgressBar(progress: progressFraction),
          const SizedBox(height: 8.0),

          // Remaining and days left
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${MoneyFormatter.formatPaise(remainingMinor)} remaining',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                '27 days left',
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
  }
}
