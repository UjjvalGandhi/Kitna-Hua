import 'package:ai_expense/core/utils/money_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MoneyFormatter - Indian Currency Grouping', () {
    test('formats ₹0 correctly', () {
      expect(MoneyFormatter.format(0), equals('₹0'));
    });

    test('formats ₹450 (45000 paise) correctly', () {
      expect(MoneyFormatter.format(45000), equals('₹450'));
    });

    test(
      'formats ₹1,23,450 (12345000 paise) correctly with Indian grouping',
      () {
        expect(MoneyFormatter.format(12345000), equals('₹1,23,450'));
      },
    );

    test('handles paise rounding correctly', () {
      // 450.50 rupees -> rounds up to 451
      expect(MoneyFormatter.format(45050, roundPaise: true), equals('₹451'));

      // 450.49 rupees -> rounds down to 450
      expect(MoneyFormatter.format(45049, roundPaise: true), equals('₹450'));

      // 450.99 rupees -> rounds up to 451
      expect(MoneyFormatter.format(45099, roundPaise: true), equals('₹451'));

      // 450.01 rupees -> rounds down to 450
      expect(MoneyFormatter.format(45001, roundPaise: true), equals('₹450'));
    });

    test('formats with paise when showPaise is true', () {
      expect(MoneyFormatter.format(45050, showPaise: true), equals('₹450.50'));
      expect(
        MoneyFormatter.format(12345075, showPaise: true),
        equals('₹1,23,450.75'),
      );
      expect(MoneyFormatter.format(0, showPaise: true), equals('₹0.00'));
    });

    test('formats negative amounts correctly', () {
      expect(MoneyFormatter.format(-45000), equals('-₹450'));
      expect(MoneyFormatter.format(-12345000), equals('-₹1,23,450'));
    });

    test('formats large Indian numbers (Lakhs & Crores)', () {
      // 1 Lakh (1,00,000)
      expect(MoneyFormatter.format(10000000), equals('₹1,00,000'));
      // 1 Crore (1,00,00,000)
      expect(MoneyFormatter.format(1000000000), equals('₹1,00,00,000'));
    });

    test('compact formatting works as expected', () {
      expect(MoneyFormatter.formatCompact(5423000), equals('₹54.2k'));
      expect(MoneyFormatter.formatCompact(12000000), equals('₹1.2L'));
      expect(MoneyFormatter.formatCompact(1500000000), equals('₹1.5Cr'));
    });

    test('converts between paise and rupees accurately', () {
      expect(MoneyFormatter.paiseToRupees(45050), equals(451));
      expect(MoneyFormatter.paiseToRupees(45049), equals(450));
      expect(MoneyFormatter.rupeesToPaise(450), equals(45000));
    });
  });
}
