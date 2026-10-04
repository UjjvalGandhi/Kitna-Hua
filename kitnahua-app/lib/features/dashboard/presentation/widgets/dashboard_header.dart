import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/adaptive/adaptive.dart';
import '../../data/dashboard_providers.dart';

/// Home large title: the selected month with a dropdown chevron.
class DashboardMonthTitle extends StatelessWidget {
  const DashboardMonthTitle({super.key, required this.monthYearText});

  final String monthYearText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    );

    return Semantics(
      button: true,
      label: 'Change month, $monthYearText',
      excludeSemantics: true,
      child: InkWell(
        // Month picker arrives with real data; the affordance is in place.
        onTap: () {},
        borderRadius: BorderRadius.circular(8.0),
        // Scales down in the collapsed Android toolbar instead of overflowing.
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(monthYearText, style: style),
              const SizedBox(width: 4.0),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 26.0,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar in the Home bar; opens Settings.
class DashboardAvatarButton extends StatelessWidget {
  const DashboardAvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Settings',
      excludeSemantics: true,
      child: InkWell(
        onTap: () => context.push('/settings'),
        customBorder: const CircleBorder(),
        child: CircleAvatar(
          radius: AdaptiveBarButton.height / 2,
          backgroundColor: theme.colorScheme.primary,
          child: Text(
            'UG',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass capsule showing how many local changes are waiting to sync.
class DashboardSyncButton extends ConsumerWidget {
  const DashboardSyncButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCount = ref.watch(pendingSyncCountProvider);
    final theme = Theme.of(context);

    return AdaptiveBarButton(
      tooltip: '$pendingCount changes waiting to sync',
      icon: Icons.sync_rounded,
      label: '$pendingCount pending',
      color: theme.colorScheme.onSurfaceVariant,
      onPressed: () {},
    );
  }
}
