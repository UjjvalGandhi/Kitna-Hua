import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_expense/core/adaptive/adaptive.dart';
import 'package:ai_expense/core/theme/app_theme.dart';
import 'package:ai_expense/router/app_router.dart';

class _StaticPlatformInfoNotifier extends PlatformInfoNotifier {
  _StaticPlatformInfoNotifier(this._initial);
  final PlatformInfo _initial;

  @override
  PlatformInfo build() => _initial;
}

Widget _buildTestApp({required PlatformInfo platformInfo, Key? key}) {
  return ProviderScope(
    key: key,
    overrides: [
      platformInfoProvider.overrideWith(
        () => _StaticPlatformInfoNotifier(platformInfo),
      ),
    ],
    child: MaterialApp.router(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Adaptive Layer - PlatformInfo & Navigation Tests', () {
    testWidgets('Android shows NavigationBar and extended FAB Add button', (
      tester,
    ) async {
      const androidInfo = PlatformInfo(
        isIOS: false,
        iosMajorVersion: 0,
        reduceTransparency: false,
      );

      await tester.pumpWidget(
        _buildTestApp(key: const Key('android_app'), platformInfo: androidInfo),
      );
      await tester.pumpAndSettle();

      // Android Material 3 NavigationBar labels
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Cards'), findsOneWidget);

      // Extended FAB "Add Expense"
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);

      // Native iOS components must not exist on Android
      expect(find.byType(CNTabBar), findsNothing);
    });

    testWidgets(
      'iOS 26 shows Liquid Glass tab scaffold (CNTabBar) and round Add button',
      (tester) async {
        const ios26Info = PlatformInfo(
          isIOS: true,
          iosMajorVersion: 26,
          reduceTransparency: false,
        );

        await tester.pumpWidget(
          _buildTestApp(key: const Key('ios26_app'), platformInfo: ios26Info),
        );
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pumpAndSettle();

        // Native iOS 26 tab bar capsule
        expect(find.byType(CNTabBar), findsOneWidget);

        // The glass bar spans the full width; the "+" circle floats above
        // its right edge instead of squeezing the five tabs.
        expect(find.text('Add Expense'), findsNothing);
        final addButton = find.byKey(const Key('adaptive_add_button'));
        expect(addButton, findsOneWidget);
        final screenWidth = tester.getSize(find.byType(MaterialApp)).width;
        final tabBarRect = tester.getRect(find.byType(CNTabBar));
        final addRect = tester.getRect(addButton);
        expect(tabBarRect.width, screenWidth);
        expect(addRect.width, AdaptiveTabScaffold.glassAddButtonSize);
        expect(addRect.bottom, lessThan(tabBarRect.top + 14.0));
        expect(
          screenWidth - addRect.right,
          AdaptiveTabScaffold.glassBarSideMargin,
        );
      },
    );

    test('glass tab index maps tap x to the five evenly spaced items', () {
      // 420pt wide bar: items are 72pt wide between 30pt insets.
      const w = 420.0;
      expect(AdaptiveTabScaffold.glassTabIndexAt(66, w), 0);
      expect(AdaptiveTabScaffold.glassTabIndexAt(138, w), 1);
      expect(AdaptiveTabScaffold.glassTabIndexAt(210, w), 2);
      expect(AdaptiveTabScaffold.glassTabIndexAt(282, w), 3);
      expect(AdaptiveTabScaffold.glassTabIndexAt(354, w), 4);
      // Taps in the insets go to the nearest tab.
      expect(AdaptiveTabScaffold.glassTabIndexAt(5, w), 0);
      expect(AdaptiveTabScaffold.glassTabIndexAt(415, w), 4);
    });

    testWidgets('iOS 26: tapping the glass bar switches tabs', (tester) async {
      // appRouter is shared by all tests; put it back on Home afterwards.
      addTearDown(() => appRouter.go('/'));
      const ios26Info = PlatformInfo(
        isIOS: true,
        iosMajorVersion: 26,
        reduceTransparency: false,
      );
      await tester.pumpWidget(
        _buildTestApp(key: const Key('ios26_tap'), platformInfo: ios26Info),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      final bar = tester.getRect(find.byType(CNTabBar));
      final index = AdaptiveTabScaffold.glassTabIndexAt;
      // Find an x that maps to Insights (index 3).
      var x = bar.left;
      while (index(x - bar.left, bar.width) != 3) {
        x += 4;
      }
      await tester.tapAt(Offset(x + 8, bar.center.dy));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.text('Monthly AI Briefing'), findsOneWidget);
    });

    testWidgets('iOS 17 shows solid CupertinoTabBar', (tester) async {
      const ios17Info = PlatformInfo(
        isIOS: true,
        iosMajorVersion: 17,
        reduceTransparency: false,
      );

      await tester.pumpWidget(
        _buildTestApp(key: const Key('ios17_app'), platformInfo: ios17Info),
      );
      await tester.pumpAndSettle();

      // Solid CupertinoTabBar on iOS 17
      expect(find.byType(CupertinoTabBar), findsOneWidget);
      expect(find.byType(CNTabBar), findsNothing);
    });

    testWidgets(
      'Reduce Transparency ON forces solid CupertinoTabBar and solid surfaces',
      (tester) async {
        const reduceTransparencyInfo = PlatformInfo(
          isIOS: true,
          iosMajorVersion: 26,
          reduceTransparency: true,
        );

        await tester.pumpWidget(
          _buildTestApp(
            key: const Key('reduce_transparency_app'),
            platformInfo: reduceTransparencyInfo,
          ),
        );
        await tester.pumpAndSettle();

        // Even on iOS 26, Reduce Transparency ON forces solid CupertinoTabBar
        expect(find.byType(CupertinoTabBar), findsOneWidget);
        expect(find.byType(CNTabBar), findsNothing);

        // Add button is rendered in solid circular format
        expect(find.byKey(const Key('adaptive_add_button')), findsOneWidget);
        expect(find.byIcon(Icons.add), findsWidgets);
      },
    );

    testWidgets('AdaptiveSwitch renders Material Switch on Android', (
      tester,
    ) async {
      const androidInfo = PlatformInfo(
        isIOS: false,
        iosMajorVersion: 0,
        reduceTransparency: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          key: const Key('android_switch'),
          overrides: [
            platformInfoProvider.overrideWith(
              () => _StaticPlatformInfoNotifier(androidInfo),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: AdaptiveSwitch(value: true, onChanged: null)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Switch), findsOneWidget);
      expect(find.byType(CupertinoSwitch), findsNothing);
    });

    testWidgets('AdaptiveSwitch renders CupertinoSwitch on iOS', (
      tester,
    ) async {
      const iosInfo = PlatformInfo(
        isIOS: true,
        iosMajorVersion: 26,
        reduceTransparency: false,
      );

      await tester.pumpWidget(
        ProviderScope(
          key: const Key('ios_switch'),
          overrides: [
            platformInfoProvider.overrideWith(
              () => _StaticPlatformInfoNotifier(iosInfo),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(body: AdaptiveSwitch(value: true, onChanged: null)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoSwitch), findsOneWidget);
      expect(find.byType(Switch), findsNothing);
    });
  });
}
