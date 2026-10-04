import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'platform_info.dart';

/// Compact, non-collapsing bar for full-screen forms (e.g. Add Expense).
/// Scrolling screens use [AdaptiveScrollPage] instead.
/// - iOS: transparent, centred title, glass buttons (pass
///   [AdaptiveBarButton]s), as on iOS 26 sheets.
/// - Android: Material top bar with start-aligned title.
class AdaptiveTopBar extends ConsumerWidget {
  const AdaptiveTopBar({
    super.key,
    required this.title,
    this.leading,
    this.actions = const [],
  });

  static const double height = 56.0;

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);
    final titleText = Text(
      title,
      style: platformInfo.isIOS
          ? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)
          : theme.textTheme.titleLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (platformInfo.isAndroid) {
      return SizedBox(
        height: height,
        child: Row(
          children: [
            const SizedBox(width: 4.0),
            ?leading,
            const SizedBox(width: 12.0),
            Expanded(child: titleText),
            ...actions,
            const SizedBox(width: 8.0),
          ],
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: NavigationToolbar(
          leading: leading,
          middle: titleText,
          trailing: actions.isEmpty
              ? null
              : Row(mainAxisSize: MainAxisSize.min, children: actions),
          centerMiddle: true,
        ),
      ),
    );
  }
}
