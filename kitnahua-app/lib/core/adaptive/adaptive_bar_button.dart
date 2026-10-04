import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adaptive_haptics.dart';
import 'glass_surface.dart';
import 'platform_info.dart';

/// App bar button.
/// - iOS: Liquid Glass circle (icon only) or capsule (with [label]), 40pt
///   high like iOS 26 bar buttons. Solid when glass is unavailable.
/// - Android: Material [IconButton], or a [TextButton.icon] with [label].
class AdaptiveBarButton extends ConsumerWidget {
  const AdaptiveBarButton({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.icon,
    this.label,
    this.trailingIcon,
    this.color,
  }) : assert(icon != null || label != null);

  /// Accessibility label; also the long-press tooltip on Android.
  final String tooltip;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String? label;

  /// Small icon after the label, e.g. a dropdown chevron.
  final IconData? trailingIcon;

  /// Icon/label colour; defaults to onSurface.
  final Color? color;

  static const double height = 40.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);
    final foreground = color ?? theme.colorScheme.onSurface;

    if (platformInfo.isAndroid) {
      if (label == null) {
        return IconButton(
          tooltip: tooltip,
          onPressed: onPressed,
          icon: Icon(icon, color: foreground),
        );
      }
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: foreground),
        child: _content(theme, foreground),
      );
    }

    final isCircle = label == null;
    // Keeps the 40pt shape when a toolbar passes tight height constraints,
    // without taking extra width.
    return Center(
      widthFactor: 1.0,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: SizedBox(
          height: height,
          width: isCircle ? height : null,
          child: GlassSurface(
            borderRadius: BorderRadius.circular(height / 2),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: const StadiumBorder(),
                onTap: onPressed == null
                    ? null
                    : () {
                        AdaptiveHaptics.lightImpact();
                        onPressed!();
                      },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCircle ? 0 : 14.0,
                  ),
                  child: Center(child: _content(theme, foreground)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _content(ThemeData theme, Color foreground) {
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      color: foreground,
      fontWeight: FontWeight.w600,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) Icon(icon, size: 20.0, color: foreground),
        if (icon != null && label != null) const SizedBox(width: 6.0),
        if (label != null) Text(label!, style: textStyle),
        if (trailingIcon != null) ...[
          const SizedBox(width: 2.0),
          Icon(trailingIcon, size: 16.0, color: foreground),
        ],
      ],
    );
  }
}
