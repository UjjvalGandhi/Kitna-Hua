import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform_info.dart';

/// Adaptive Toggle Switch.
///
/// Platform behaviors:
/// - iOS: [CupertinoSwitch] with [primary] active tint.
/// - Android: Material 3 [Switch].
class AdaptiveSwitch extends ConsumerWidget {
  const AdaptiveSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);

    if (platformInfo.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: theme.colorScheme.primary,
      );
    }

    return Switch(value: value, onChanged: onChanged);
  }
}

/// Adaptive Segmented Control.
///
/// Platform behaviors:
/// - iOS: [CupertinoSlidingSegmentedControl] with primary tint.
/// - Android: Material segmented row of selection chips/buttons.
class AdaptiveSegmented<T extends Object> extends ConsumerWidget {
  const AdaptiveSegmented({
    super.key,
    required this.groupValue,
    required this.onValueChanged,
    required this.children,
  });

  final T groupValue;
  final ValueChanged<T> onValueChanged;
  final Map<T, Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);

    if (platformInfo.isIOS) {
      return CupertinoSlidingSegmentedControl<T>(
        groupValue: groupValue,
        onValueChanged: (val) {
          if (val != null) {
            onValueChanged(val);
          }
        },
        thumbColor: theme.colorScheme.primary.withValues(alpha: 0.20),
        backgroundColor: theme.colorScheme.surfaceContainer,
        children: children,
      );
    }

    // Android Segmented Button row
    return Row(
      children: [
        for (final entry in children.entries) ...[
          Expanded(
            child: InkWell(
              onTap: () => onValueChanged(entry.key),
              borderRadius: BorderRadius.circular(12.0),
              child: Container(
                height: 44.0,
                decoration: BoxDecoration(
                  color: entry.key == groupValue
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12.0),
                  border: entry.key == groupValue
                      ? null
                      : Border.all(
                          color: theme.colorScheme.outlineVariant,
                          width: 1.0,
                        ),
                ),
                alignment: Alignment.center,
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: entry.key == groupValue
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: entry.key == groupValue
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface,
                  ),
                  child: entry.value,
                ),
              ),
            ),
          ),
          if (entry.key != children.keys.last) const SizedBox(width: 6.0),
        ],
      ],
    );
  }
}
