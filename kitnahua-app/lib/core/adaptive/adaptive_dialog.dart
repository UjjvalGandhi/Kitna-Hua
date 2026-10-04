import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_radii.dart';
import 'glass_surface.dart';
import 'platform_info.dart';

/// Adaptive Dialog container.
///
/// Platform behaviors:
/// - Android: Material 3 dialog (radius 24, surface background, outlineVariant border).
/// - iOS 26+: Centered glass card with blur sigma 20, specular highlight border,
///   and subtle drop shadow.
/// - iOS Reduce Transparency ON: Solid surfaceContainer background.
class AdaptiveDialog extends ConsumerWidget {
  const AdaptiveDialog({
    super.key,
    required this.child,
  });

  final Widget child;

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.40),
      builder: (context) => AdaptiveDialog(child: child),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final platformInfo = ref.watch(platformInfoProvider);

    if (platformInfo.isAndroid) {
      return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.dialogBorderRadius,
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        backgroundColor: theme.colorScheme.surface,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: AppRadii.dialogBorderRadius,
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.60),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      );
    }

    // iOS centered glass dialog
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GlassSurface(
        borderRadius: AppRadii.dialogBorderRadius,
        padding: const EdgeInsets.all(24.0),
        borderWidth: 1.0,
        fallbackColor: theme.colorScheme.surfaceContainer,
        child: child,
      ),
    );
  }
}
