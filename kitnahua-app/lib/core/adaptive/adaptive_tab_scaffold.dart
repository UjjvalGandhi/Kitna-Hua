import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  });

  final StatefulNavigationShell navigationShell;

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

    if (platformInfo.isAndroid) {
      return Scaffold(
        body: navigationShell,
        extendBody: false,
        bottomNavigationBar: _buildAndroidNavigationBar(
          context,
          ref,
          theme,
          selectedIndex,
        ),
      );
    }

    // iOS platform
    if (platformInfo.useLiquidGlass) {
      // iOS 26+ Liquid Glass native floating capsule
      return Scaffold(
        body: navigationShell,
        extendBody: true,
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
            child: CNTabBar(
              currentIndex: selectedIndex,
              onTap: (index) => _onItemTapped(context, ref, index),
              tint: theme.colorScheme.primary,
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
                CNTabBarItem(
                  label: 'Insights',
                  icon: CNSymbol('sparkles'),
                  activeIcon: CNSymbol('sparkles'),
                ),
                CNTabBarItem(
                  label: 'Cards',
                  icon: CNSymbol('creditcard'),
                  activeIcon: CNSymbol('creditcard.fill'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // iOS < 26 or Reduce Transparency ON: Solid CupertinoTabBar
    return Scaffold(
      body: navigationShell,
      extendBody: false,
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, ref, index),
        backgroundColor: theme.colorScheme.surfaceContainer,
        activeColor: theme.colorScheme.primary,
        inactiveColor: theme.colorScheme.onSurfaceVariant,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            width: 1.0,
          ),
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Budgets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_outlined),
            activeIcon: Icon(Icons.auto_awesome),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
        ],
      ),
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
