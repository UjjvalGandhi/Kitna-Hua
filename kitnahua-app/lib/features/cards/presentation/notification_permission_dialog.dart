import 'package:flutter/material.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/primary_action_button.dart';

/// Notification permission primer dialog for bill reminders.
class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({
    super.key,
    required this.remindDaysBefore,
  });

  final int remindDaysBefore;

  static Future<bool?> show(BuildContext context, int remindDaysBefore) {
    return AdaptiveDialog.show<bool>(
      context: context,
      child: NotificationPermissionDialog(remindDaysBefore: remindDaysBefore),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 56px Icon tile
        IconTile(
          size: 56.0,
          borderRadius: 16.0,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          icon: Icons.notifications_active_outlined,
          iconSize: 30.0,
          iconColor: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16.0),

        // Title
        Text(
          'Get reminded before your card payment is due',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8.0),

        // Body
        Text(
          'Kitna Hua reminds you $remindDaysBefore days before your due date so you never miss a payment.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.0,
            height: 1.5,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16.0),

        // 3 feature bullets
        _buildBullet(
          theme,
          'Alert when your bill is generated & before the due date',
        ),
        const SizedBox(height: 8.0),
        _buildBullet(theme, 'Amounts come only from expenses you log'),
        const SizedBox(height: 8.0),
        _buildBullet(theme, 'Reminders are scheduled on your phone'),
        const SizedBox(height: 20.0),

        // Primary "Allow" button
        PrimaryActionButton(
          label: 'Allow',
          onPressed: () => Navigator.of(context).pop(true),
        ),
        const SizedBox(height: 8.0),

        // "Not now" button
        SizedBox(
          width: double.infinity,
          height: 44.0,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Not now',
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBullet(ThemeData theme, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16.0,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
