import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/dashboard_providers.dart';

/// Donut chart card showing category spend breakdown.
class CategorySpendCard extends ConsumerWidget {
  const CategorySpendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final breakdown = ref.watch(categorySpendBreakdownProvider);

    // Map each category to color
    Color getColor(String categoryId) {
      switch (categoryId) {
        case 'rent':
          return appColors.rent;
        case 'food':
          return appColors.foodDining;
        case 'groceries':
          return appColors.groceries;
        default:
          return appColors.transport;
      }
    }

    final totalSpentMinor = ref.watch(totalSpentMonthProvider);

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: 'Category Spend',
            actionLabel: 'See all (8)',
            onAction: () {},
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              // 96x96 Donut Chart with center text
              SizedBox(
                width: 96.0,
                height: 96.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 36.0,
                        startDegreeOffset: -90,
                        sections: [
                          for (final item in breakdown)
                            PieChartSectionData(
                              color: getColor(item.categoryId),
                              value: item.amountMinor.toDouble(),
                              showTitle: false,
                              radius: 12.0,
                            ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Spends',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '₹${(totalSpentMinor / 100000).toStringAsFixed(1)}k',
                          style: theme.textTheme.labelMedium?.withTabularFigures
                              .copyWith(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),

              // Legend items
              Expanded(
                child: Column(
                  children: [
                    for (final item in breakdown) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: Row(
                          children: [
                            Container(
                              width: 10.0,
                              height: 10.0,
                              decoration: BoxDecoration(
                                color: getColor(item.categoryId),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              MoneyFormatter.formatPaise(item.amountMinor),
                              style: theme
                                  .textTheme
                                  .bodyMedium
                                  ?.withTabularFigures
                                  .copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
