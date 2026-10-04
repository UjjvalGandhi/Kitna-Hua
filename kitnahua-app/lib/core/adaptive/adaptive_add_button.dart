import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_radii.dart';
import 'glass_surface.dart';
import 'platform_info.dart';

/// Adaptive Add button:
/// - Android: Extended FAB "Add Expense" with primary background and onPrimary text/icon.
/// - iOS 26+: Glass circular 56x56 "+" button floating above the tab bar,
///   rendered in 20% primary-tinted glass with blur sigma 20 and highlight border.
/// - iOS < 26 or Reduce Transparency ON: Solid circular button with
///   surfaceContainer background and primary icon.
///
/// Triggers light haptic feedback on iOS when pressed.
class AdaptiveAddButton extends ConsumerWidget {
  const AdaptiveAddButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  void _handleTap(PlatformInfo platformInfo) {
    if (platformInfo.isIOS) {
      HapticFeedback.lightImpact();
    }
    onPressed();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);

    if (platformInfo.isAndroid) {
      return FloatingActionButton.extended(
        onPressed: () => _handleTap(platformInfo),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.rowBorderRadius,
        ),
        elevation: 2.0,
        icon: const Icon(Icons.add, size: 20.0),
        label: const Text(
          'Add Expense',
          style: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    // iOS circular floating "+" button
    final isLiquidGlass = platformInfo.useLiquidGlass;

    if (isLiquidGlass) {
      return Container(
        width: 56.0,
        height: 56.0,
        margin: const EdgeInsets.only(bottom: 24.0, right: 4.0),
        child: GlassSurface(
          borderRadius: BorderRadius.circular(28.0),
          tintOpacity: 0.20, // Primary-tinted glass at 20%
          borderColor: theme.colorScheme.primary.withValues(alpha: 0.40),
          glowColor: theme.colorScheme.primary.withValues(alpha: 0.25),
          glowRadius: 20.0,
          fallbackColor: theme.colorScheme.surfaceContainer,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _handleTap(platformInfo),
              borderRadius: BorderRadius.circular(28.0),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 28.0,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // iOS Reduce Transparency or iOS < 26: Solid surfaceContainer button
    return Container(
      width: 56.0,
      height: 56.0,
      margin: const EdgeInsets.only(bottom: 24.0, right: 4.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.60),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleTap(platformInfo),
          borderRadius: BorderRadius.circular(28.0),
          child: Center(
            child: Icon(
              Icons.add,
              size: 28.0,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
