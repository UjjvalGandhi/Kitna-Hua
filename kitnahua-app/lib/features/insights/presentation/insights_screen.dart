import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/metric_badge.dart';
import '../../../core/widgets/month_selector.dart';
import '../../../core/widgets/section_header.dart';
import '../../dashboard/data/dashboard_providers.dart';
import '../data/insights_providers.dart';
import '../domain/insight_item.dart';

/// Insights Tab: Monthly AI briefing and categorized spending insights.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insightsAsync = ref.watch(insightsProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Content scrolls under top bar
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 64.0, 20.0, 96.0),
              children: [
                // Summary Card: Monthly AI Briefing
                _buildSummaryCard(context, ref),
                const SizedBox(height: 16.0),

                // Section Header
                const SectionHeader(
                  title: 'Monthly Insights (4)',
                  fontSize: 11.0,
                ),
                const SizedBox(height: 10.0),

                // Insights list with async states
                insightsAsync.when(
                  data: (items) => Column(
                    children: [
                      for (final item in items) ...[
                        _buildInsightCard(context, item),
                        const SizedBox(height: 10.0),
                      ],
                    ],
                  ),
                  loading: () => _buildLoadingSkeleton(context),
                  error: (err, _) => InfoNote(
                    icon: Icons.error_outline,
                    text: 'Unable to calculate insights right now.',
                    trailing: TextButton(
                      onPressed: () =>
                          ref.read(insightsProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Footer
                Center(
                  child: Text(
                    'AI-written summary of your monthly totals · numbers calculated from your data',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Pinned Adaptive Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AdaptiveTopBar(
              customContent: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 24.0,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8.0),
                        Flexible(
                          child: Text(
                            'Financial Insights',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  const MonthSelector(
                    monthYearText: 'October 2026',
                    isPill: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final totalSpentMinor = ref.watch(totalSpentMonthProvider);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: AppRadii.cardBorderRadius,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.20),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Briefing Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.psychology_outlined,
                      size: 16.0,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6.0),
                    Flexible(
                      child: Text(
                        'Monthly AI Briefing',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'Updated 4 Oct, 9:30 AM',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          ref.read(insightsProvider.notifier).refresh(),
                      icon: const Icon(Icons.refresh, size: 16.0),
                      constraints: const BoxConstraints(
                        minWidth: 32.0,
                        minHeight: 32.0,
                      ),
                      padding: EdgeInsets.zero,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Briefing Body
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 12.0,
                height: 1.6,
                color: theme.colorScheme.onSurface,
              ),
              children: [
                const TextSpan(text: 'Total spending is '),
                TextSpan(
                  text: MoneyFormatter.formatPaise(totalSpentMinor),
                  style: theme.textTheme.bodyMedium?.withTabularFigures.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const TextSpan(text: ' — '),
                TextSpan(
                  text: '72%',
                  style: theme.textTheme.bodyMedium?.withTabularFigures.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const TextSpan(
                  text: ' of your ₹75,000 budget used by 4 Oct. Projected month-end spend is ',
                ),
                TextSpan(
                  text: '₹81,600',
                  style: theme.textTheme.bodyMedium?.withTabularFigures.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const TextSpan(
                  text: ' (excluding rent-driven front-loading). Food & Dining is ',
                ),
                TextSpan(
                  text: '₹3,200 lower',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: appColors.success,
                  ),
                ),
                const TextSpan(text: ' than same days in Sep.'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(BuildContext context, InsightItem item) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.rowBorderRadius,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row
          Row(
            children: [
              IconTile(
                size: 32.0,
                borderRadius: 12.0,
                backgroundColor:
                    appColors.categoryTint(Color(item.iconColorHex)),
                icon: item.icon,
                iconSize: 16.0,
                iconColor: Color(item.iconColorHex),
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              MetricBadge(
                text: item.badgeText,
                variant: item.badgeVariant,
                categoryColor: item.badgeCategoryColorHex != null
                    ? Color(item.badgeCategoryColorHex!)
                    : null,
                fontSize: 11.0,
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Body text
          Text(
            item.body,
            style: TextStyle(
              fontSize: 12.0,
              height: 1.35,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        for (int i = 0; i < 3; i++) ...[
          Container(
            height: 90.0,
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: AppRadii.rowBorderRadius,
            ),
          ),
        ],
      ],
    );
  }
}
