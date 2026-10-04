import 'package:flutter/material.dart';

import '../../../core/widgets/metric_badge.dart';

/// Data structure for a financial insight card.
class InsightItem {
  const InsightItem({
    required this.id,
    required this.icon,
    required this.iconColorHex,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeVariant,
    this.badgeCategoryColorHex,
    required this.body,
  });

  final String id;
  final IconData icon;
  final int iconColorHex;
  final String title;
  final String subtitle;
  final String badgeText;
  final MetricBadgeVariant badgeVariant;
  final int? badgeCategoryColorHex;
  final String body;
}
