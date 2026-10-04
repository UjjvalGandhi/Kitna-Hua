import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/budget_progress_bar.dart';
import '../../dashboard/data/dashboard_providers.dart';

/// Screen displaying monthly budgets and limits.
class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalSpentMinor = ref.watch(totalSpentMonthProvider);
    final overallBudgetMinor = ref.watch(monthlyBudgetProvider);
    final groceryBudgetMinor = ref.watch(groceryBudgetProvider);
    final breakdown = ref.watch(categorySpendBreakdownProvider);

    int grocerySpent = 0;
    for (final item in breakdown) {
      if (item.categoryId == 'groceries') grocerySpent = item.amountMinor;
    }

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Content scrolls under top bar
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 56.0, 20.0, 96.0),
              children: [
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Overall Monthly Budget',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${MoneyFormatter.formatPaise(totalSpentMinor)} / ${MoneyFormatter.formatPaise(overallBudgetMinor)}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${((totalSpentMinor / overallBudgetMinor) * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      BudgetProgressBar(
                        progress: totalSpentMinor / overallBudgetMinor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Groceries Budget',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${MoneyFormatter.formatPaise(grocerySpent)} / ${MoneyFormatter.formatPaise(groceryBudgetMinor)}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${((grocerySpent / groceryBudgetMinor) * 100).round()}%',
                            style: const TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      BudgetProgressBar(
                        progress: grocerySpent / groceryBudgetMinor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Pinned Adaptive Top Bar
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AdaptiveTopBar(
              title: 'Budgets',
            ),
          ),
        ],
      ),
    );
  }
}
