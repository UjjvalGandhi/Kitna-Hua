import 'package:intl/intl.dart';

/// Helper methods for relative and calendar date formatting.
abstract final class DateHelpers {
  /// Formats date relative to [now]: "Today", "Yesterday", or "dd MMM" (e.g. "02 Oct").
  static String formatRelative(DateTime date, DateTime now) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM').format(date);
    }
  }

  /// Formats month and year, e.g. "October 2026".
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  /// Formats date with day number, e.g. "Today, 04 Oct".
  static String formatDayWithDate(DateTime date, DateTime now) {
    final rel = formatRelative(date, now);
    if (rel == 'Today' || rel == 'Yesterday') {
      return '$rel, ${DateFormat('dd MMM').format(date)}';
    }
    return DateFormat('EEE, dd MMM').format(date);
  }

  /// Formats billing cycle range, e.g. "16 Sep – 15 Oct".
  static String formatCycleRange(DateTime start, DateTime end) {
    final startStr = DateFormat('d MMM').format(start);
    final endStr = DateFormat('d MMM').format(end);
    return '$startStr – $endStr';
  }

  /// Calculates days remaining between [from] and [to].
  static int daysBetween(DateTime from, DateTime to) {
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day);
    return toDate.difference(fromDate).inDays;
  }
}
