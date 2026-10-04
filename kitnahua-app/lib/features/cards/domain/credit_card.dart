import 'package:flutter/material.dart';

/// Represents a credit card tracked for bill cycles and reminders.
@immutable
class CreditCard {
  const CreditCard({
    required this.id,
    required this.nickname,
    this.last4,
    required this.billDay,
    required this.dueDay,
    required this.remindDaysBefore,
    this.isReminderEnabled = true,
    this.colorHex = 0xFF006A60,
    this.lastStatementAmountMinor = 0,
    this.isLastStatementPaid = true,
    this.currentCycleAmountMinor = 0,
  });

  final String id;
  final String nickname;
  final String? last4;
  final int billDay;
  final int dueDay;
  final int remindDaysBefore;
  final bool isReminderEnabled;
  final int colorHex;
  final int lastStatementAmountMinor;
  final bool isLastStatementPaid;
  final int currentCycleAmountMinor;

  /// Formatted masked display, e.g. "•••• •••• •••• 4821" or "•••• 4821".
  String get maskedNumber {
    if (last4 == null || last4!.isEmpty) return '';
    return '•••• •••• •••• $last4';
  }

  /// Short display title, e.g. "HDFC Millennia ••4821".
  String get shortTitle {
    if (last4 == null || last4!.isEmpty) return nickname;
    return '$nickname ••$last4';
  }

  /// The billing cycle that contains [now]:
  /// - [start]: last bill day on or before today; [end]: the day before the
  ///   next bill day.
  /// - [billDate]: when this cycle's statement is generated (next bill day).
  /// - [dueDate]: the first [dueDay] after [billDate].
  /// Days past a month's end (e.g. 31 in September) fall on its last day.
  ({DateTime start, DateTime end, DateTime billDate, DateTime dueDate})
  cycleInfo(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final billThisMonth = _onDay(today.year, today.month, billDay);
    final start = today.isBefore(billThisMonth)
        ? _onDay(today.year, today.month - 1, billDay)
        : billThisMonth;
    final billDate = _onDay(start.year, start.month + 1, billDay);
    var dueDate = _onDay(billDate.year, billDate.month, dueDay);
    if (!dueDate.isAfter(billDate)) {
      dueDate = _onDay(billDate.year, billDate.month + 1, dueDay);
    }
    return (
      start: start,
      end: billDate.subtract(const Duration(days: 1)),
      billDate: billDate,
      dueDate: dueDate,
    );
  }

  /// The most recent statement before [now]'s cycle: generated on this
  /// cycle's start and due on the first [dueDay] after that.
  ({DateTime billDate, DateTime dueDate}) lastStatement(DateTime now) {
    final current = cycleInfo(now);
    final previous = cycleInfo(current.start.subtract(const Duration(days: 1)));
    return (billDate: previous.billDate, dueDate: previous.dueDate);
  }

  static DateTime _onDay(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day);
  }

  CreditCard copyWith({
    String? id,
    String? nickname,
    String? last4,
    int? billDay,
    int? dueDay,
    int? remindDaysBefore,
    bool? isReminderEnabled,
    int? colorHex,
    int? lastStatementAmountMinor,
    bool? isLastStatementPaid,
    int? currentCycleAmountMinor,
  }) {
    return CreditCard(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      last4: last4 ?? this.last4,
      billDay: billDay ?? this.billDay,
      dueDay: dueDay ?? this.dueDay,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      isReminderEnabled: isReminderEnabled ?? this.isReminderEnabled,
      colorHex: colorHex ?? this.colorHex,
      lastStatementAmountMinor:
          lastStatementAmountMinor ?? this.lastStatementAmountMinor,
      isLastStatementPaid: isLastStatementPaid ?? this.isLastStatementPaid,
      currentCycleAmountMinor:
          currentCycleAmountMinor ?? this.currentCycleAmountMinor,
    );
  }
}
