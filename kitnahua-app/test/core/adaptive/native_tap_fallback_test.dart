import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_expense/core/adaptive/native_tap_fallback.dart';

void main() {
  group('TapDeduper', () {
    test('runs a tap reported by both native and Flutter only once', () {
      var now = DateTime(2026, 10, 4, 9);
      final deduper = TapDeduper(now: () => now);
      var runs = 0;

      deduper.run(3, () => runs++); // Flutter fallback
      now = now.add(const Duration(milliseconds: 120));
      deduper.run(3, () => runs++); // native report of the same tap

      expect(runs, 1);
    });

    test('runs again for another key or after the window', () {
      var now = DateTime(2026, 10, 4, 9);
      final deduper = TapDeduper(now: () => now);
      var runs = 0;

      deduper.run(1, () => runs++);
      deduper.run(2, () => runs++); // different tab
      now = now.add(const Duration(milliseconds: 600));
      deduper.run(2, () => runs++); // deliberate second tap later

      expect(runs, 3);
    });
  });

  group('NativeTapFallback', () {
    Future<List<Offset>> pumpTarget(WidgetTester tester) async {
      final taps = <Offset>[];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: NativeTapFallback(
              onTap: taps.add,
              child: const SizedBox(width: 200, height: 60),
            ),
          ),
        ),
      );
      return taps;
    }

    testWidgets('reports a tap', (tester) async {
      final taps = await pumpTarget(tester);
      await tester.tap(find.byType(SizedBox));
      expect(taps, hasLength(1));
    });

    testWidgets('ignores drags, which the native control handles', (
      tester,
    ) async {
      final taps = await pumpTarget(tester);
      await tester.drag(find.byType(SizedBox), const Offset(80, 0));
      expect(taps, isEmpty);
    });
  });
}
