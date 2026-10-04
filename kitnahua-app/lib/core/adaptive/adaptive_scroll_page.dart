import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'adaptive_bar_button.dart';
import 'adaptive_insets.dart';
import 'platform_info.dart';

/// A scrolling screen with the platform's own app bar.
/// - iOS: large title that collapses into a compact blurred bar on scroll
///   (CupertinoSliverNavigationBar), with Liquid Glass bar buttons. The bar
///   background only appears once content scrolls under it.
/// - Android: Material 3 medium app bar that collapses on scroll.
///
/// Screens only provide a title, optional bar widgets and their [children];
/// top/bottom insets (status bar, tab bar, Add button) are handled here.
class AdaptiveScrollPage extends ConsumerWidget {
  const AdaptiveScrollPage({
    super.key,
    required this.title,
    required this.children,
    this.largeTitle,
    this.leading,
    this.actions = const [],
    this.hasAddButton = false,
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 20.0),
  });

  /// Shown large at the top and small in the collapsed bar.
  final String title;

  /// Replaces the large title text (e.g. a tappable month selector on Home).
  final Widget? largeTitle;

  /// Leading bar widget. When null and the route can pop, a back button is
  /// shown.
  final Widget? leading;

  /// Trailing bar widgets, usually [AdaptiveBarButton]s.
  final List<Widget> actions;

  /// Whether the floating Add button is shown over this tab.
  final bool hasAddButton;

  final EdgeInsets bodyPadding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();
    final resolvedLeading =
        leading ??
        (canPop
            ? AdaptiveBarButton(
                tooltip: 'Back',
                icon: platformInfo.isIOS
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_back,
                onPressed: () => Navigator.of(context).maybePop(),
              )
            : null);

    final body = SliverPadding(
      padding: bodyPadding.copyWith(
        top: 8.0,
        bottom: AdaptiveInsets.scrollBottom(
          context,
          hasAddButton: hasAddButton,
        ),
      ),
      sliver: SliverList.list(children: children),
    );

    final trailing = actions.isEmpty
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0) const SizedBox(width: 8.0),
                actions[i],
              ],
            ],
          );

    if (platformInfo.isIOS) {
      return Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle:
                  largeTitle ??
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
              middle: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              // Small title appears only once the large title scrolls away.
              alwaysShowMiddle: false,
              leading: resolvedLeading,
              trailing: trailing,
              automaticallyImplyLeading: false,
              // Every tab owns a nav bar; hero transitions between them would
              // collide on the default tag.
              transitionBetweenRoutes: false,
              border: null,
              // Opaque enough that scrolled content behind the blur doesn't
              // compete with the bar's title and buttons.
              backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16.0),
            ),
            body,
          ],
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: largeTitle ?? Text(title),
            leading: resolvedLeading,
            automaticallyImplyLeading: false,
            actions: [...actions, const SizedBox(width: 12.0)],
            backgroundColor: theme.colorScheme.surface,
            surfaceTintColor: Colors.transparent,
          ),
          body,
        ],
      ),
    );
  }
}
