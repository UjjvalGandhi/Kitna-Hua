import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'glass_surface.dart';
import 'platform_info.dart';

/// Adaptive Top Bar component.
///
/// Platform behaviors:
/// - Android: The Material 3 header from Part B.
/// - iOS 26+: Glass bar pinned at the top with real-time backdrop blur,
///   translucency, and specular bottom highlight border. Content scrolls
///   underneath the translucent surface.
/// - iOS Reduce Transparency ON: Solid surfaceContainer background.
class AdaptiveTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AdaptiveTopBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.customContent,
    this.height = 52.0,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? customContent;
  final double height;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);

    // If custom content (like Home avatar + month + sync) is provided
    if (customContent != null) {
      if (platformInfo.isAndroid) {
        return Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            bottom: false,
            child: customContent!,
          ),
        );
      }

      // iOS glass header
      return GlassSurface(
        borderWidth: 1.0,
        borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            child: customContent!,
          ),
        ),
      );
    }

    // Standard title + actions top bar
    final content = SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            leading ?? const SizedBox(width: 8.0),
            const SizedBox(width: 8.0),
            Expanded(
              child: titleWidget ??
                  Text(
                    title ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
            ),
            ...?actions,
          ],
        ),
      ),
    );

    if (platformInfo.isAndroid) {
      return Container(
        color: theme.colorScheme.surface,
        child: SafeArea(
          bottom: false,
          child: content,
        ),
      );
    }

    // iOS Glass Bar
    return GlassSurface(
      borderWidth: 1.0,
      borderColor: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
      child: SafeArea(
        bottom: false,
        child: content,
      ),
    );
  }
}
