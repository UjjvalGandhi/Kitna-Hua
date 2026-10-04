import 'package:flutter/widgets.dart';

/// Bottom scroll padding so content is never hidden behind the tab bar or the
/// Add button.
abstract final class AdaptiveInsets {
  /// Breathing room below the last item.
  static const double _contentGap = 24.0;

  /// Height the floating Add button (extended FAB or glass circle) covers
  /// above the tab bar, including its gap.
  static const double _floatingAddButton = 72.0;

  /// Bottom padding for a tab's scroll view.
  ///
  /// MediaQuery padding already covers the tab bar (iOS 26 glass uses
  /// extendBody); tabs with the floating Add button also clear its height.
  static double scrollBottom(
    BuildContext context, {
    bool hasAddButton = false,
  }) {
    final base = MediaQuery.paddingOf(context).bottom + _contentGap;
    if (!hasAddButton) {
      return base;
    }
    return base + _floatingAddButton;
  }
}
