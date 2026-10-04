import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/section_header.dart';

/// Settings: profile, preferences and app info as grouped rows.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final platformInfo = ref.watch(platformInfoProvider);

    return AdaptiveScrollPage(
      title: 'Settings',
      children: [
        AppSurfaceCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.0,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  'UG',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 14.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ujjval Gandhi', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2.0),
                    Text(
                      'Stored on this device · sync off',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24.0),
        const SectionHeader(title: 'Preferences'),
        const SizedBox(height: 8.0),
        _SettingsGroup(
          rows: [
            const _SettingsRow(
              icon: Icons.currency_rupee_rounded,
              title: 'Currency',
              value: 'INR (₹)',
            ),
            const _SettingsRow(
              icon: Icons.notifications_none_rounded,
              title: 'Card reminders',
              value: 'On',
            ),
            if (platformInfo.isIOS)
              _SettingsRow(
                icon: Icons.blur_on_rounded,
                title: 'Solid backgrounds',
                subtitle: 'Turn off the glass effect',
                trailing: AdaptiveSwitch(
                  value: platformInfo.reduceTransparency,
                  onChanged: (value) => ref
                      .read(platformInfoProvider.notifier)
                      .setReduceTransparency(value),
                ),
              ),
          ],
        ),
        const SizedBox(height: 24.0),
        const SectionHeader(title: 'About'),
        const SizedBox(height: 8.0),
        const _SettingsGroup(
          rows: [
            _SettingsRow(
              icon: Icons.info_outline_rounded,
              title: 'Kitna Hua',
              value: 'Version 0.1.0',
            ),
          ],
        ),
      ],
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: 1.0,
      indent: 60.0,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) divider,
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        child: Row(
          children: [
            IconTile(
              size: 32.0,
              borderRadius: 10.0,
              backgroundColor: theme.colorScheme.primary.withValues(
                alpha: 0.12,
              ),
              icon: icon,
              iconSize: 18.0,
              iconColor: theme.colorScheme.primary,
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge),
                  if (subtitle != null)
                    Text(subtitle!, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}
