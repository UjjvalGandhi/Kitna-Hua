import 'package:ai_expense/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dashboard renders total card, categories, and recent expenses', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390 * 3, 1000 * 3);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const ProviderScope(child: KitnaHuaApp()));

    await tester.pumpAndSettle();

    // Verify header elements
    expect(find.text('October 2026'), findsWidgets);
    expect(find.text('2 pending'), findsOneWidget);

    // Verify Total spent card
    expect(find.text('Total Spent this Month'), findsOneWidget);
    expect(find.text('₹54,230'), findsOneWidget);
    expect(find.text('12% vs same days in Sep'), findsOneWidget);

    // Verify Category Spend card
    expect(find.text('CATEGORY SPEND'), findsOneWidget);
    expect(find.text('Rent'), findsAtLeastNWidgets(1));
    expect(find.text('Food & Dining'), findsAtLeastNWidgets(1));

    // Scroll down to find Recent Expenses
    final recentExpensesFinder = find.text('RECENT EXPENSES');
    await tester.scrollUntilVisible(
      recentExpensesFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    expect(recentExpensesFinder, findsOneWidget);

    // Scroll down to find Swiggy Dinner
    final swiggyFinder = find.text('Swiggy Dinner');
    await tester.scrollUntilVisible(
      swiggyFinder,
      50.0,
      scrollable: find.byType(Scrollable).first,
    );
    expect(swiggyFinder, findsOneWidget);

    expect(find.text('Add Expense'), findsOneWidget);
  });
}
