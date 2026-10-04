/// Shared Indian currency (INR) formatter for integer minor units (paise).
///
/// Rules:
/// - Money is ALWAYS int minor units (paise), never double.
/// - Indian number grouping: ₹1,23,450 (last 3 digits, then pairs of 2).
/// - Supports whole rupee formatting, paise display, and paise rounding.
abstract final class MoneyFormatter {
  static const String currencySymbol = '₹';

  /// Formats [paiseMinor] into an Indian currency string.
  ///
  /// Examples:
  /// - `format(0)` -> `"₹0"`
  /// - `format(45000)` -> `"₹450"`
  /// - `format(12345000)` -> `"₹1,23,450"`
  /// - `format(45050, roundPaise: true)` -> `"₹451"` (paise rounding)
  /// - `format(45049, roundPaise: true)` -> `"₹450"`
  /// - `format(45050, showPaise: true)` -> `"₹450.50"`
  /// - `format(-45000)` -> `"-₹450"`
  /// Alias for [format] taking integer paise minor units.
  static String formatPaise(
    int paiseMinor, {
    bool showPaise = false,
    bool roundPaise = true,
    bool includeSymbol = true,
  }) => format(
    paiseMinor,
    showPaise: showPaise,
    roundPaise: roundPaise,
    includeSymbol: includeSymbol,
  );

  static String format(
    int paiseMinor, {
    bool showPaise = false,
    bool roundPaise = true,
    bool includeSymbol = true,
  }) {
    final isNegative = paiseMinor < 0;
    final absPaise = paiseMinor.abs();

    final int rupees;
    final int remainingPaise;

    if (showPaise) {
      rupees = absPaise ~/ 100;
      remainingPaise = absPaise % 100;
    } else if (roundPaise) {
      rupees = (absPaise / 100.0).round();
      remainingPaise = 0;
    } else {
      rupees = absPaise ~/ 100;
      remainingPaise = 0;
    }

    final groupedRupees = _groupIndian(rupees);
    final buffer = StringBuffer();

    if (isNegative) {
      buffer.write('-');
    }
    if (includeSymbol) {
      buffer.write(currencySymbol);
    }
    buffer.write(groupedRupees);

    if (showPaise) {
      buffer.write('.');
      buffer.write(remainingPaise.toString().padLeft(2, '0'));
    }

    return buffer.toString();
  }

  /// Compact representation for charts and badge counters (e.g. ₹54.2k, ₹1.2L).
  static String formatCompact(int paiseMinor, {bool includeSymbol = true}) {
    final isNegative = paiseMinor < 0;
    final absRupees = (paiseMinor.abs() / 100.0).round();

    final String result;
    if (absRupees >= 10000000) {
      final cr = (absRupees / 10000000.0)
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      result = '${cr}Cr';
    } else if (absRupees >= 100000) {
      final l = (absRupees / 100000.0)
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      result = '${l}L';
    } else if (absRupees >= 1000) {
      final k = (absRupees / 1000.0)
          .toStringAsFixed(1)
          .replaceAll(RegExp(r'\.0$'), '');
      result = '${k}k';
    } else {
      result = absRupees.toString();
    }

    final prefix = isNegative ? '-' : '';
    final symbol = includeSymbol ? currencySymbol : '';
    return '$prefix$symbol$result';
  }

  /// Converts paise to rupees as an integer, rounding to nearest whole rupee by default.
  static int paiseToRupees(int paiseMinor, {bool round = true}) {
    if (round) {
      return (paiseMinor / 100.0).round();
    }
    return paiseMinor ~/ 100;
  }

  /// Converts rupees into integer minor units (paise).
  static int rupeesToPaise(int rupees) => rupees * 100;

  /// Pure integer grouping based on the Indian numbering system.
  static String _groupIndian(int absRupees) {
    final s = absRupees.toString();
    if (s.length <= 3) return s;

    final last3 = s.substring(s.length - 3);
    final remaining = s.substring(0, s.length - 3);

    final buffer = StringBuffer();
    for (int i = 0; i < remaining.length; i++) {
      final charsFromEnd = remaining.length - i;
      if (i > 0 && charsFromEnd % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(remaining[i]);
    }
    buffer.write(',');
    buffer.write(last3);
    return buffer.toString();
  }
}
