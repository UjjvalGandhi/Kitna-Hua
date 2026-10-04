import 'package:flutter_test/flutter_test.dart';

import 'package:ai_expense/features/cards/domain/credit_card.dart';

CreditCard _card(int billDay, int dueDay) => CreditCard(
  id: 'c',
  nickname: 'Card',
  billDay: billDay,
  dueDay: dueDay,
  remindDaysBefore: 3,
);

void main() {
  test('HDFC (bill 16, due 7) on 4 Oct: cycle 16 Sep–15 Oct, due 7 Nov', () {
    final c = _card(16, 7).cycleInfo(DateTime(2026, 10, 4));
    expect(c.start, DateTime(2026, 9, 16));
    expect(c.end, DateTime(2026, 10, 15));
    expect(c.billDate, DateTime(2026, 10, 16));
    expect(c.dueDate, DateTime(2026, 11, 7));
  });

  test('ICICI (bill 12, due 1) on 4 Oct: cycle 12 Sep–11 Oct, due 1 Nov', () {
    final c = _card(12, 1).cycleInfo(DateTime(2026, 10, 4));
    expect(c.start, DateTime(2026, 9, 12));
    expect(c.end, DateTime(2026, 10, 11));
    expect(c.dueDate, DateTime(2026, 11, 1));
  });

  test('on the bill day a new cycle starts', () {
    final c = _card(16, 7).cycleInfo(DateTime(2026, 10, 16));
    expect(c.start, DateTime(2026, 10, 16));
    expect(c.billDate, DateTime(2026, 11, 16));
    expect(c.dueDate, DateTime(2026, 12, 7));
  });

  test('due day after bill day falls in the same month', () {
    final c = _card(5, 25).cycleInfo(DateTime(2026, 10, 10));
    expect(c.billDate, DateTime(2026, 11, 5));
    expect(c.dueDate, DateTime(2026, 11, 25));
  });

  test('bill day 31 uses the last day of shorter months', () {
    final c = _card(31, 20).cycleInfo(DateTime(2026, 2, 10));
    expect(c.start, DateTime(2026, 1, 31));
    expect(c.billDate, DateTime(2026, 2, 28));
    expect(c.end, DateTime(2026, 2, 27));
    expect(c.dueDate, DateTime(2026, 3, 20));
  });

  test('cycle crosses the year boundary', () {
    final c = _card(20, 10).cycleInfo(DateTime(2027, 1, 5));
    expect(c.start, DateTime(2026, 12, 20));
    expect(c.billDate, DateTime(2027, 1, 20));
    expect(c.dueDate, DateTime(2027, 2, 10));
  });

  test('last statement before 4 Oct: generated 16 Sep, due 7 Oct', () {
    final s = _card(16, 7).lastStatement(DateTime(2026, 10, 4));
    expect(s.billDate, DateTime(2026, 9, 16));
    expect(s.dueDate, DateTime(2026, 10, 7));
  });
}
