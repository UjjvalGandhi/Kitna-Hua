import 'package:ai_expense/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Add Expense screen opens, parses AI prompt, and updates keypad',
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

    // Tap Add Expense FAB
    await tester.tap(find.text('Add Expense'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Add Expense elements
    expect(find.text('AMOUNT (INR)'), findsOneWidget);
    expect(find.text('Category'), findsOneWidget);
    expect(find.text('Merchant / Note'), findsOneWidget);
    expect(find.text('Save Expense (₹450)'), findsOneWidget);

    // Test keypad: tap '5'
    await tester.tap(find.text('5'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Save Expense (₹4,505)'), findsOneWidget);

    // Test keypad backspace
    await tester.tap(find.byIcon(Icons.backspace_outlined));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Save Expense (₹450)'), findsOneWidget);
  });
}
