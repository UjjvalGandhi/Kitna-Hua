import 'package:flutter/material.dart';

import '../../../core/widgets/metric_badge.dart';

/// Data structure for a financial insight card.
class InsightItem {
  const InsightItem({
    required this.id,
    required this.icon,
    required this.categoryName,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeVariant,
    required this.body,
  });

  final String id;
  final IconData icon;

  /// Category whose theme colour tints the icon (and a category badge).
  final String categoryName;
  final String title;
  final String subtitle;
  final String badgeText;
  final MetricBadgeVariant badgeVariant;
  final String body;
}
