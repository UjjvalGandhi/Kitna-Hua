import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_radii.dart';
import 'adaptive_bar_button.dart';
import 'glass_surface.dart';
import 'platform_info.dart';

/// Adaptive Bottom Sheet.
///
/// Platform behaviors:
/// - Android: Material 3 bottom sheet (radius 28, surface background, outlineVariant border).
/// - iOS 26+: Liquid Glass sheet with grabber, swipe to dismiss, blur sigma 20,
///   and highlight border.
/// - iOS Reduce Transparency ON: Falls back to solid surfaceContainer background.
class AdaptiveSheet extends ConsumerWidget {
  const AdaptiveSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AdaptiveSheet(title: title, subtitle: subtitle, child: child),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final platformInfo = ref.watch(platformInfoProvider);
    // Keyboard when open, otherwise the home indicator area.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom > 0
        ? MediaQuery.viewInsetsOf(context).bottom
        : MediaQuery.paddingOf(context).bottom;

    final sheetContent = Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 12.0,
        bottom: 16.0 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle / Grabber
          Center(
            child: Container(
              width: platformInfo.isIOS ? 36.0 : 48.0,
              height: platformInfo.isIOS ? 5.0 : 4.0,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant.withValues(
                  alpha: platformInfo.isIOS ? 0.80 : 1.0,
                ),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
          ),
          const SizedBox(height: 12.0),

          // Header: Title & Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
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
              AdaptiveBarButton(
                tooltip: 'Close',
                icon: Icons.close_rounded,
                color: theme.colorScheme.onSurfaceVariant,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Child content
          child,
        ],
      ),
    );

    if (platformInfo.isAndroid) {
      return Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppRadii.sheetBorderRadius,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
              width: 1.0,
            ),
          ),
        ),
        child: sheetContent,
      );
    }

    // iOS Sheet (Liquid Glass or Solid fallback)
    return GlassSurface(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28.0)),
      borderWidth: 1.0,
      fallbackColor: theme.colorScheme.surfaceContainer,
      child: sheetContent,
    );
  }
}
