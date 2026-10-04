import 'package:ai_expense/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Insights tab renders AI briefing and 4 monthly insight cards',
      (tester) async {
    tester.view.physicalSize = const Size(390 * 3, 1000 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: KitnaHuaApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Tap Insights tab
    await tester.tap(find.text('Insights'));
    await tester.pumpAndSettle();

    // Verify Insights header and briefing
    expect(find.text('Financial Insights'), findsOneWidget);
    expect(find.text('Monthly AI Briefing'), findsOneWidget);
    expect(find.text('MONTHLY INSIGHTS (4)'), findsOneWidget);

    // Verify 4 insight cards
    expect(find.text('Dining Spend Down'), findsOneWidget);
    expect(find.text('Rent is 41% of spend'), findsOneWidget);
    expect(find.text('Grocery Spend on Track'), findsOneWidget);

    // Scroll to bottom to find last card and footer
    final swiggyFinder = find.text('Top merchant: Swiggy');
    await tester.scrollUntilVisible(
      swiggyFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    expect(swiggyFinder, findsOneWidget);

    final footerFinder = find.text(
      'AI-written summary of your monthly totals · numbers calculated from your data',
    );
    await tester.scrollUntilVisible(
      footerFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    expect(footerFinder, findsOneWidget);
  });
}
