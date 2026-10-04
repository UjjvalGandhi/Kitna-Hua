import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'adaptive_add_button.dart';
import 'native_tap_fallback.dart';
import 'platform_info.dart';

/// Adaptive tab scaffold for navigating the 5 primary app branches.
///
/// Platform behaviors:
/// - Android: Material 3 NavigationBar from Part B (height 64, surfaceContainer,
///   outlineVariant border, 48x28 primary 15% indicator pill).
/// - iOS 26+: Native Liquid Glass tab bar capsule with SF Symbols
///   (house, list.bullet.rectangle, chart.pie, sparkles, creditcard) and
///   content scrolling under the floating bar (extendBody: true).
/// - iOS < 26 or Reduce Transparency ON: Solid CupertinoTabBar with
///   surfaceContainer background.
///
/// Haptics: Triggers light impact on tab switch on iOS.
class AdaptiveTabScaffold extends ConsumerWidget {
  const AdaptiveTabScaffold({
    super.key,
    required this.navigationShell,
    required this.onAddExpense,
  });

  final StatefulNavigationShell navigationShell;

  /// Called by the Add button, shown on the Home and Expenses tabs only.
  final VoidCallback onAddExpense;

  /// Diameter of the iOS 26 glass Add circle.
  static const double glassAddButtonSize = 56.0;

  /// Visible gap between the screen edges and the glass pill / Add circle.
  /// The native UITabBar already insets its pill ~20pt inside its own view,
  /// so the bar view spans the full width.
  static const double glassBarSideMargin = 20.0;

  /// Gap between the top of the glass pill and the Add circle above it.
  static const double glassAddButtonGap = 12.0;

  static const _tabsWithAddButton = {0, 1};

  static const _glassTabCount = 5;

  /// Horizontal space the native bar keeps between its view edge and the
  /// first/last item (pill inset + pill padding), measured on iOS 26/27.
  static const double _glassItemsInset = 30.0;

  /// Tab index under [x] in a native glass bar [width] points wide, used only
  /// for taps the native bar drops; items sit evenly between the insets and
  /// taps in the insets go to the nearest tab.
  @visibleForTesting
  static int glassTabIndexAt(double x, double width) {
    final itemWidth = (width - 2 * _glassItemsInset) / _glassTabCount;
    if (itemWidth <= 0) return 0;
    final index = ((x - _glassItemsInset) / itemWidth).floor();
    return index.clamp(0, _glassTabCount - 1);
  }

  void _onItemTapped(BuildContext context, WidgetRef ref, int index) {
    final platformInfo = ref.read(platformInfoProvider);
    if (platformInfo.isIOS) {
      HapticFeedback.lightImpact();
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final platformInfo = ref.watch(platformInfoProvider);
    final theme = Theme.of(context);
    final selectedIndex = navigationShell.currentIndex;
    final showAddButton = _tabsWithAddButton.contains(selectedIndex);
    final addButton = showAddButton
        ? AdaptiveAddButton(
            key: const Key('adaptive_add_button'),
            onPressed: onAddExpense,
          )
        : null;

    if (platformInfo.isAndroid) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: _buildAndroidNavigationBar(
          context,
          ref,
          theme,
          selectedIndex,
        ),
        floatingActionButton: addButton,
      );
    }

    if (platformInfo.useLiquidGlass) {
      // Five tabs need the full width to breathe, so the bar always spans the
      // screen (same size on every tab) and the Add circle floats above its
      // right edge. extendBody lets content scroll under both; see
      // AdaptiveInsets for the matching bottom padding.
      return Scaffold(
        body: navigationShell,
        extendBody: true,
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 12.0),
          child: _buildGlassTabBar(context, ref, theme, selectedIndex),
        ),
        floatingActionButtonLocation: const _GlassAddButtonLocation(),
        floatingActionButton: showAddButton
            ? AdaptiveAddButton(
                key: const Key('adaptive_add_button'),
                onPressed: onAddExpense,
                size: glassAddButtonSize,
              )
            : null,
      );
    }

    // iOS < 26 or Reduce Transparency ON: Solid CupertinoTabBar
    return Scaffold(
      body: navigationShell,
      floatingActionButton: addButton,
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, ref, index),
        backgroundColor: theme.colorScheme.surfaceContainer,
        activeColor: theme.colorScheme.primary,
        inactiveColor: theme.colorScheme.onSurfaceVariant,
        iconSize: 20.0,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            width: 1.0,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 20.0),
            activeIcon: Icon(Icons.home, size: 20.0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined, size: 20.0),
            activeIcon: Icon(Icons.receipt_long, size: 20.0),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline, size: 20.0),
            activeIcon: Icon(Icons.pie_chart, size: 20.0),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined, size: 20.0),
            activeIcon: Icon(Icons.auto_awesome, size: 20.0),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined, size: 20.0),
            activeIcon: Icon(Icons.credit_card, size: 20.0),
            label: 'Cards',
          ),
        ],
      ),
    );
  }

  Widget _buildGlassTabBar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    int selectedIndex,
  ) {
    return _GlassTabBar(
      selectedIndex: selectedIndex,
      onSelect: (index) => _onItemTapped(context, ref, index),
    );
  }

  Widget _buildAndroidNavigationBar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    int selectedIndex,
  ) {
    return Container(
      height: 64.0,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildAndroidNavItem(
            context,
            ref,
            index: 0,
            selectedIndex: selectedIndex,
            label: 'Home',
            selectedIcon: Icons.home,
            unselectedIcon: Icons.home_outlined,
          ),
          _buildAndroidNavItem(
            context,
            ref,
            index: 1,
            selectedIndex: selectedIndex,
            label: 'Expenses',
            selectedIcon: Icons.receipt_long,
            unselectedIcon: Icons.receipt_long_outlined,
          ),
          _buildAndroidNavItem(
            context,
            ref,
            index: 2,
            selectedIndex: selectedIndex,
            label: 'Budgets',
            selectedIcon: Icons.pie_chart,
            unselectedIcon: Icons.pie_chart_outline,
          ),
          _buildAndroidNavItem(
            context,
            ref,
            index: 3,
            selectedIndex: selectedIndex,
            label: 'Insights',
            selectedIcon: Icons.auto_awesome,
            unselectedIcon: Icons.auto_awesome_outlined,
          ),
          _buildAndroidNavItem(
            context,
            ref,
            index: 4,
            selectedIndex: selectedIndex,
            label: 'Cards',
            selectedIcon: Icons.credit_card,
            unselectedIcon: Icons.credit_card_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildAndroidNavItem(
    BuildContext context,
    WidgetRef ref, {
    required int index,
    required int selectedIndex,
    required String label,
    required IconData selectedIcon,
    required IconData unselectedIcon,
  }) {
    final theme = Theme.of(context);
    final isSelected = index == selectedIndex;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(context, ref, index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.0,
              height: 28.0,
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.15)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14.0),
              ),
              alignment: Alignment.center,
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                size: 20.0,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Puts the Add circle above the glass tab bar, right-aligned with the
/// pill's visible edge.
class _GlassAddButtonLocation extends FloatingActionButtonLocation {
  const _GlassAddButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final size = geometry.floatingActionButtonSize;
    final x =
        geometry.scaffoldSize.width -
        AdaptiveTabScaffold.glassBarSideMargin -
        size.width;
    // contentBottom is the top of the native bar view, which reserves 14pt
    // above the glass pill for its selection morph (cupertino_native_better).
    const nativePillTopRoom = 14.0;
    final pillTop = geometry.contentBottom + nativePillTopRoom;
    final y = pillTop - AdaptiveTabScaffold.glassAddButtonGap - size.height;
    return Offset(x, y);
  }
}

/// Native iOS 26 Liquid Glass tab bar. The native bar keeps every touch (press
/// effect, drag-to-switch lens); [NativeTapFallback] also catches the short
/// taps it drops, and [TapDeduper] makes sure one tap switches tabs once.
class _GlassTabBar extends StatefulWidget {
  const _GlassTabBar({required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  State<_GlassTabBar> createState() => _GlassTabBarState();
}

class _GlassTabBarState extends State<_GlassTabBar> {
  final _deduper = TapDeduper();

  void _select(int index) => _deduper.run(index, () => widget.onSelect(index));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => NativeTapFallback(
        onTap: (position) => _select(
          AdaptiveTabScaffold.glassTabIndexAt(
            position.dx,
            constraints.maxWidth,
          ),
        ),
        child: CNTabBar(
          // The native bar picks light/dark glass only when created; rebuild
          // it when the system appearance changes while the app is open.
          key: ValueKey(theme.brightness),
          currentIndex: widget.selectedIndex,
          onTap: _select,
          // Morph the glass pill when Flutter switches tabs too (fallback
          // taps, "View all"), not only on native taps.
          animateSelectionChanges: true,
          tint: theme.colorScheme.primary,
          iconSize: 20.0,
          items: const [
            CNTabBarItem(
              label: 'Home',
              icon: CNSymbol('house'),
              activeIcon: CNSymbol('house.fill'),
            ),
            CNTabBarItem(
              label: 'Expenses',
              icon: CNSymbol('list.bullet.rectangle'),
              activeIcon: CNSymbol('list.bullet.rectangle.fill'),
            ),
            CNTabBarItem(
              label: 'Budgets',
              icon: CNSymbol('chart.pie'),
              activeIcon: CNSymbol('chart.pie.fill'),
            ),
            CNTabBarItem(label: 'Insights', icon: CNSymbol('sparkles')),
            CNTabBarItem(
              label: 'Cards',
              icon: CNSymbol('creditcard'),
              activeIcon: CNSymbol('creditcard.fill'),
            ),
          ],
        ),
      ),
    );
  }
}
