import 'package:ai_expense/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Cards tab displays HDFC and ICICI cards with billing cycle info', (
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

    // Tap Cards tab on navigation bar
    await tester.tap(find.text('Cards'));
    await tester.pumpAndSettle();

    // Verify Cards screen elements
    expect(find.text('Credit Cards'), findsWidgets);
    expect(find.text('HDFC Millennia'), findsOneWidget);
    expect(find.text('ICICI Amazon Pay'), findsOneWidget);
    expect(
      find.text(
        'Track billing cycles offline. Amounts represent expenses logged in Kitna Hua for that cycle.',
      ),
      findsOneWidget,
    );
    expect(find.text('₹12,340'), findsOneWidget);
    expect(find.text('₹4,210'), findsOneWidget);
    expect(find.text('Add another card'), findsOneWidget);

    // Toggle reminder switch on first card
    final switches = find.byType(Switch);
    expect(switches, findsAtLeastNWidgets(2));
    await tester.tap(switches.first);
    await tester.pumpAndSettle();
  });
}
