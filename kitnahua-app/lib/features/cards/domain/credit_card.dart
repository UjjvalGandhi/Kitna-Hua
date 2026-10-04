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

  /// Calculates the current cycle start and end dates relative to [now].
  ({DateTime start, DateTime end, DateTime dueDate}) cycleInfo(DateTime now) {
    // If today's day is >= billDay, current cycle started this month on billDay.
    // Otherwise it started last month on billDay.
    final DateTime cycleStart;
    final DateTime cycleEnd;
    final DateTime dueDate;

    if (now.day >= billDay) {
      cycleStart = DateTime(now.year, now.month, billDay);
      final nextMonth = DateTime(now.year, now.month + 1, 1);
      final daysInNext = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
      final endDay = billDay - 1 <= daysInNext ? billDay - 1 : daysInNext;
      cycleEnd = DateTime(nextMonth.year, nextMonth.month, endDay);
      // Due date is in month after next if dueDay < billDay, else next month
      dueDate = DateTime(now.year, now.month + 1, dueDay);
    } else {
      final prevMonth = DateTime(now.year, now.month - 1, 1);
      cycleStart = DateTime(prevMonth.year, prevMonth.month, billDay);
      cycleEnd = DateTime(now.year, now.month, billDay - 1);
      dueDate = DateTime(now.year, now.month, dueDay);
    }

    return (start: cycleStart, end: cycleEnd, dueDate: dueDate);
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
