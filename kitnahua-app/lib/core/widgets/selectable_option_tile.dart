import 'package:flutter/material.dart';

import '../theme/app_radii.dart';
import 'icon_tile.dart';

/// Option tile for selecting payment method or card.
class SelectableOptionTile extends StatelessWidget {
  const SelectableOptionTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.icon = Icons.credit_card,
  });

  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color bgColor;
    final Border border;
    final Color iconTileBg;
    final Color iconColor;
    final Border? iconTileBorder;
    final FontWeight titleWeight;
    final IconData radioIcon;
    final Color radioColor;

    if (isSelected) {
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.10);
      border = Border.all(color: theme.colorScheme.primary, width: 1.0);
      iconTileBg = theme.colorScheme.primary;
      iconColor = theme.colorScheme.onPrimary;
      iconTileBorder = null;
      titleWeight = FontWeight.w700;
      radioIcon = Icons.radio_button_checked;
      radioColor = theme.colorScheme.primary;
    } else {
      bgColor = theme.colorScheme.surfaceContainer;
      border = Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
        width: 1.0,
      );
      iconTileBg = theme.colorScheme.surfaceContainer;
      iconColor = theme.colorScheme.onSurfaceVariant;
      iconTileBorder = Border.all(
        color: theme.colorScheme.outlineVariant,
        width: 1.0,
      );
      titleWeight = FontWeight.w600;
      radioIcon = Icons.radio_button_unchecked;
      radioColor = theme.colorScheme.outlineVariant;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.rowBorderRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadii.rowBorderRadius,
          border: border,
        ),
        child: Row(
          children: [
            IconTile(
              size: 36.0,
              borderRadius: 12.0,
              backgroundColor: iconTileBg,
              icon: icon,
              iconSize: 18.0,
              iconColor: iconColor,
              border: iconTileBorder,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: titleWeight,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2.0),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              radioIcon,
              size: 20.0,
              color: radioColor,
            ),
          ],
        ),
      ),
    );
  }
}
