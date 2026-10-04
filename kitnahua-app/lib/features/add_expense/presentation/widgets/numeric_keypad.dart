import 'package:flutter/material.dart';

import '../../../../core/adaptive/adaptive.dart';
import '../../../../core/theme/app_radii.dart';

/// Custom 3x4 numeric keypad for quick expense entry.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onDot,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onDot;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildKey(context, '1', () => onDigit('1')),
            const SizedBox(width: 8.0),
            _buildKey(context, '2', () => onDigit('2')),
            const SizedBox(width: 8.0),
            _buildKey(context, '3', () => onDigit('3')),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            _buildKey(context, '4', () => onDigit('4')),
            const SizedBox(width: 8.0),
            _buildKey(context, '5', () => onDigit('5')),
            const SizedBox(width: 8.0),
            _buildKey(context, '6', () => onDigit('6')),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            _buildKey(context, '7', () => onDigit('7')),
            const SizedBox(width: 8.0),
            _buildKey(context, '8', () => onDigit('8')),
            const SizedBox(width: 8.0),
            _buildKey(context, '9', () => onDigit('9')),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            _buildKey(context, '.', onDot),
            const SizedBox(width: 8.0),
            _buildKey(context, '0', () => onDigit('0')),
            const SizedBox(width: 8.0),
            _buildKey(
              context,
              null,
              onBackspace,
              icon: Icons.backspace_outlined,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(
    BuildContext context,
    String? text,
    VoidCallback onTap, {
    IconData? icon,
  }) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () {
          AdaptiveHaptics.lightImpact();
          onTap();
        },
        borderRadius: AppRadii.rowBorderRadius,
        child: Container(
          height: 48.0,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: AppRadii.rowBorderRadius,
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: 1.0,
            ),
          ),
          alignment: Alignment.center,
          child: icon != null
              ? Icon(
                  icon,
                  size: 20.0,
                  color: theme.colorScheme.onSurface,
                )
              : Text(
                  text!,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
        ),
      ),
    );
  }
}
