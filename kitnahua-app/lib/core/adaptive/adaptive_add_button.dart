import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_radii.dart';
import 'native_tap_fallback.dart';
import 'platform_info.dart';

/// Adaptive Add button. It never positions itself; the parent decides where
/// it sits ([AdaptiveTabScaffold] places it).
/// - Android: Extended FAB "Add Expense".
/// - iOS 26+: native Liquid Glass circle with a primary-tinted "plus" symbol,
///   sized by [size] so it matches the glass tab bar height exactly.
/// - iOS < 26 or Reduce Transparency ON: solid circular button.
class AdaptiveAddButton extends ConsumerWidget {
  const AdaptiveAddButton({
    super.key,
    required this.onPressed,
    this.size = 56.0,
  });

  final VoidCallback onPressed;

  /// Diameter of the circular iOS variants.
  final double size;

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
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w700),
        ),
      );
    }

    if (platformInfo.useLiquidGlass) {
      return _GlassAddButton(
        size: size,
        tint: theme.colorScheme.primary,
        onPressed: () => _handleTap(platformInfo),
      );
    }

    // iOS < 26 or Reduce Transparency ON: solid circle.
    return Semantics(
      button: true,
      label: 'Add Expense',
      child: Material(
        color: theme.colorScheme.primary,
        shape: const CircleBorder(),
        elevation: 3.0,
        child: InkWell(
          onTap: () => _handleTap(platformInfo),
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: size,
            child: Icon(
              Icons.add,
              size: 24.0,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Native Liquid Glass "+" circle. Native touches keep the glass press effect;
/// [NativeTapFallback] catches short taps the native button drops, and
/// [TapDeduper] prevents opening the screen twice.
class _GlassAddButton extends StatefulWidget {
  const _GlassAddButton({
    required this.size,
    required this.tint,
    required this.onPressed,
  });

  final double size;
  final Color tint;
  final VoidCallback onPressed;

  @override
  State<_GlassAddButton> createState() => _GlassAddButtonState();
}

class _GlassAddButtonState extends State<_GlassAddButton> {
  final _deduper = TapDeduper(window: const Duration(milliseconds: 800));

  void _press() => _deduper.run(#add, widget.onPressed);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add Expense',
      child: NativeTapFallback(
        onTap: (_) => _press(),
        child: SizedBox.square(
          dimension: widget.size,
          child: CNButton.icon(
            icon: const CNSymbol('plus', size: 20.0),
            tint: widget.tint,
            onPressed: _press,
            config: CNButtonConfig(
              style: CNButtonStyle.glass,
              width: widget.size,
              minHeight: widget.size,
            ),
          ),
        ),
      ),
    );
  }
}
