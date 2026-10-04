import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/adaptive/adaptive.dart';

/// App scaffold providing the adaptive navigation structure:
/// - Android: Material 3 NavigationBar from Part B.
/// - iOS 26+: Native Liquid Glass tab bar capsule.
/// - iOS < 26 / Reduce Transparency: Solid CupertinoTabBar.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTabScaffold(
      navigationShell: navigationShell,
    );
  }
}
