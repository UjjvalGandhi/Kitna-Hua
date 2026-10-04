import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/metric_badge.dart';
import '../../dashboard/data/dashboard_providers.dart';
import '../domain/insight_item.dart';

/// AsyncNotifier managing financial insights.
class InsightsNotifier extends AsyncNotifier<List<InsightItem>> {
  @override
  Future<List<InsightItem>> build() async {
    // Watch dashboard data so insights react to changes
    final totalSpentMinor = ref.watch(totalSpentMonthProvider);
    final groceryBudgetMinor = ref.watch(groceryBudgetProvider);
    final breakdown = ref.watch(categorySpendBreakdownProvider);

    int rentSpendMinor = 0;
    int grocerySpendMinor = 0;

    for (final item in breakdown) {
      if (item.categoryId == 'rent') rentSpendMinor = item.amountMinor;
      if (item.categoryId == 'groceries') grocerySpendMinor = item.amountMinor;
    }

    final rentPercent = totalSpentMinor > 0
        ? ((rentSpendMinor / totalSpentMinor) * 100).round()
        : 41;
    final groceryPercent = ((grocerySpendMinor / groceryBudgetMinor) * 100)
        .round();

    return [
      const InsightItem(
        id: 'dining_spend',
        icon: Icons.restaurant_outlined,
        categoryName: 'Food & Dining',
        title: 'Dining Spend Down',
        subtitle: 'Food & Dining',
        badgeText: '-₹3,200 vs Sep',
        badgeVariant: MetricBadgeVariant.success,
        body:
            'Food & Dining spend is ₹3,200 lower than the same days in September across all restaurant and delivery orders.',
      ),
      InsightItem(
        id: 'rent_spend',
        icon: Icons.home_outlined,
        categoryName: 'Rent',
        title: 'Rent is $rentPercent% of spend',
        subtitle: 'Rent',
        badgeText: '$rentPercent% of total',
        badgeVariant: MetricBadgeVariant.category,
        body:
            '₹22,000 paid on 1 Oct accounts for 40.6% of your total expenditure this month. Spends normalize after week 1.',
      ),
      InsightItem(
        id: 'grocery_spend',
        icon: Icons.shopping_cart_outlined,
        categoryName: 'Groceries',
        title: 'Grocery Spend on Track',
        subtitle: 'BigBasket & Instamart',
        badgeText: '$groceryPercent% utilized',
        badgeVariant: MetricBadgeVariant.neutral,
        body:
            '₹6,400 spent of your ₹10,000 monthly grocery budget. Within regular monthly purchasing pace.',
      ),
      const InsightItem(
        id: 'top_merchant',
        icon: Icons.storefront_outlined,
        categoryName: 'Food & Dining',
        title: 'Top merchant: Swiggy',
        subtitle: '9 orders · ₹3,850',
        badgeText: '₹428 avg',
        badgeVariant: MetricBadgeVariant.neutral,
        body:
            'Swiggy is your most frequented merchant this month with 9 orders totaling ₹3,850.',
      ),
    ];
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      return build();
    });
  }
}

final insightsProvider =
    AsyncNotifierProvider<InsightsNotifier, List<InsightItem>>(
      InsightsNotifier.new,
    );
