import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/month_selector.dart';
import '../../../../core/widgets/status_pill.dart';
import '../../data/dashboard_providers.dart';

/// Top bar on dashboard: Avatar, MonthSelector, and StatusPill.
class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pendingCount = ref.watch(pendingSyncCountProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Row(
        children: [
          // 32px Avatar circle
          InkWell(
            onTap: () => context.push('/settings'),
            borderRadius: BorderRadius.circular(16.0),
            child: CircleAvatar(
              radius: 16.0,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                'UG',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),

          // Month selector
          const Flexible(
            child: MonthSelector(
              monthYearText: 'October 2026',
            ),
          ),

          const SizedBox(width: 8.0),

          // Status Pill
          StatusPill(
            icon: Icons.sync_outlined,
            text: '$pendingCount pending sync',
          ),
        ],
      ),
    );
  }
}
