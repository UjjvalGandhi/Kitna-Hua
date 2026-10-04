import 'package:flutter/material.dart';

/// Represents an expense logged by the user.
@immutable
class Expense {
  const Expense({
    required this.id,
    required this.amountMinor,
    required this.categoryId,
    required this.spentOn,
    required this.merchantNote,
    this.paymentMethod = 'UPI',
    this.cardId,
    this.source = 'manual',
  });

  final String id;

  /// Amount in minor currency units (paise). ₹450 = 45000 paise.
  final int amountMinor;

  final String categoryId;
  final DateTime spentOn;
  final String merchantNote;
  final String paymentMethod;
  final String? cardId;
  final String source;

  Expense copyWith({
    String? id,
    int? amountMinor,
    String? categoryId,
    DateTime? spentOn,
    String? merchantNote,
    String? paymentMethod,
    String? cardId,
    String? source,
  }) {
    return Expense(
      id: id ?? this.id,
      amountMinor: amountMinor ?? this.amountMinor,
      categoryId: categoryId ?? this.categoryId,
      spentOn: spentOn ?? this.spentOn,
      merchantNote: merchantNote ?? this.merchantNote,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardId: cardId ?? this.cardId,
      source: source ?? this.source,
    );
  }
}
