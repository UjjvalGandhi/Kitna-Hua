import 'package:cupertino_liquid_glass/cupertino_liquid_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme_extension.dart';
import 'platform_info.dart';

/// Reusable adaptive glass container.
///
/// When [PlatformInfo.useLiquidGlass] is true:
/// - Renders Apple Liquid Glass using real-time backdrop blur (sigma 20),
///   translucent surface tint, specular edge lighting, and inner shadows.
///
/// When [PlatformInfo.useLiquidGlass] is false (Android, iOS < 26, or
/// Reduce Transparency ON):
/// - Falls back to a solid [surfaceContainer] background with crisp border,
///   strictly adhering to Apple HIG accessibility rules.
class GlassSurface extends ConsumerWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.tintOpacity,
    this.customTint,
    this.borderColor,
    this.borderWidth = 1.0,
    this.fallbackColor,
    this.glowColor,
    this.glowRadius = 24.0,
  });

  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double? tintOpacity;
  final Color? customTint;
  final Color? borderColor;
  final double borderWidth;
  final Color? fallbackColor;
  final Color? glowColor;
  final double glowRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final platformInfo = ref.watch(platformInfoProvider);

    final resolvedBorderRadius = borderRadius ?? BorderRadius.zero;
    final solidFallbackColor =
        fallbackColor ?? theme.colorScheme.surfaceContainer;

    if (!platformInfo.useLiquidGlass) {
      // Solid fallback: Material 3 or iOS Reduce Transparency
      return Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: solidFallbackColor,
          borderRadius: resolvedBorderRadius,
          border: Border.all(
            color:
                borderColor ??
                theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            width: borderWidth,
          ),
          boxShadow: [appColors.glassShadow],
        ),
        child: child,
      );
    }

    // iOS 26+ Liquid Glass
    final double resolvedOpacity =
        tintOpacity ?? (appColors.isDark ? 0.45 : 0.55);

    return CupertinoLiquidGlass(
      width: width,
      height: height,
      padding: padding,
      borderRadius: resolvedBorderRadius,
      blurSigma: appColors.glassBlurSigma,
      tintOpacity: resolvedOpacity,
      edgeLightColor: borderColor ?? appColors.glassBorderColor,
      borderWidth: borderWidth,
      glowColor: glowColor,
      glowRadius: glowRadius,
      disabledColor: solidFallbackColor,
      child: child,
    );
  }
}
