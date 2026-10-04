import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cards/domain/credit_card.dart';
import '../../expenses/domain/expense.dart';

/// Clock provider returning the simulation reference date: 4 Oct 2026.
final clockProvider = Provider<DateTime>((ref) {
  return DateTime(2026, 10, 4);
});

/// Total monthly budget limit (in minor units: ₹75,000 = 7,500,000 paise).
final monthlyBudgetProvider = Provider<int>((ref) => 7500000);

/// Grocery monthly budget limit (in minor units: ₹10,000 = 1,000,000 paise).
final groceryBudgetProvider = Provider<int>((ref) => 1000000);

/// Pending sync count provider.
final pendingSyncCountProvider = Provider<int>((ref) => 2);

/// September baseline spending (same days 1-4 Sep: ₹61,625, giving ~12% lower in Oct).
final sepBaselineSpendProvider = Provider<int>((ref) => 6162500);

/// Food & Dining Sep baseline (same days 1-4 Sep: ₹21,650 vs ₹18,450 Oct = ₹3,200 lower).
final sepFoodDiningProvider = Provider<int>((ref) => 2165000);

/// Initial fake cards data.
final initialCards = <CreditCard>[
  const CreditCard(
    id: 'hdfc_millennia',
    nickname: 'HDFC Millennia',
    last4: '4821',
    billDay: 16,
    dueDay: 7,
    remindDaysBefore: 3,
    isReminderEnabled: true,
    colorHex: 0xFF006A60,
    lastStatementAmountMinor: 1892000, // ₹18,920
    isLastStatementPaid: false,
    currentCycleAmountMinor: 1234000, // ₹12,340
  ),
  const CreditCard(
    id: 'icici_amazon_pay',
    nickname: 'ICICI Amazon Pay',
    last4: '1190',
    billDay: 12,
    dueDay: 1,
    remindDaysBefore: 3,
    isReminderEnabled: true,
    colorHex: 0xFF546E7A,
    lastStatementAmountMinor: 0,
    isLastStatementPaid: true,
    currentCycleAmountMinor: 421000, // ₹4,210
  ),
];

/// Initial fake expenses for October 2026 totaling exactly ₹54,230 (5,423,000 paise):
/// Rent: ₹22,000
/// Food & Dining: ₹18,450
/// Groceries: ₹6,400
/// Others: ₹7,380
final initialExpenses = <Expense>[
  Expense(
    id: 'exp_1',
    amountMinor: 45000, // ₹450
    categoryId: 'food',
    spentOn: DateTime(2026, 10, 4, 20, 30),
    merchantNote: 'Swiggy Dinner',
    paymentMethod: 'UPI',
  ),
  Expense(
    id: 'exp_2',
    amountMinor: 28000, // ₹280
    categoryId: 'transport',
    spentOn: DateTime(2026, 10, 4, 9, 15),
    merchantNote: 'Uber Go to Office',
    paymentMethod: 'UPI',
  ),
  Expense(
    id: 'exp_3',
    amountMinor: 184000, // ₹1,840
    categoryId: 'groceries',
    spentOn: DateTime(2026, 10, 3, 17, 45),
    merchantNote: 'BigBasket Weekly',
    paymentMethod: 'Card',
    cardId: 'hdfc_millennia',
  ),
  Expense(
    id: 'exp_4',
    amountMinor: 142000, // ₹1,420
    categoryId: 'utilities',
    spentOn: DateTime(2026, 10, 2, 11, 00),
    merchantNote: 'BESCOM Electricity',
    paymentMethod: 'Auto-debit',
  ),
  Expense(
    id: 'exp_5',
    amountMinor: 64900, // ₹649
    categoryId: 'entertainment',
    spentOn: DateTime(2026, 10, 1, 14, 20),
    merchantNote: 'Netflix India Sub',
    paymentMethod: 'Card',
    cardId: 'hdfc_millennia',
  ),
  Expense(
    id: 'exp_6',
    amountMinor: 2200000, // ₹22,000
    categoryId: 'rent',
    spentOn: DateTime(2026, 10, 1, 10, 00),
    merchantNote: 'October Rent',
    paymentMethod: 'Net Banking',
  ),
  // Additional expenses to reach exact category totals:
  // Food & Dining needed: 18,450 - 450 = 18,000 (total Swiggy is 9 orders, ₹3,850)
  Expense(
    id: 'exp_7',
    amountMinor: 340000, // ₹3,400 (8 previous Swiggy orders)
    categoryId: 'food',
    spentOn: DateTime(2026, 10, 3, 13, 00),
    merchantNote: 'Swiggy Orders (8)',
    paymentMethod: 'UPI',
  ),
  Expense(
    id: 'exp_8',
    amountMinor: 1460000, // ₹14,600 (remaining Food & Dining)
    categoryId: 'food',
    spentOn: DateTime(2026, 10, 2, 21, 00),
    merchantNote: 'Dining & Cafes',
    paymentMethod: 'Card',
    cardId: 'hdfc_millennia',
  ),
  // Groceries needed: 6,400 - 1,840 = 4,560
  Expense(
    id: 'exp_9',
    amountMinor: 456000, // ₹4,560
    categoryId: 'groceries',
    spentOn: DateTime(2026, 10, 2, 16, 00),
    merchantNote: 'Instamart & Local Market',
    paymentMethod: 'UPI',
  ),
  // Others needed: 7,380 - (280 + 1,420 + 649 = 2,349) = 5,031
  Expense(
    id: 'exp_10',
    amountMinor: 503100, // ₹5,031
    categoryId: 'shopping',
    spentOn: DateTime(2026, 10, 2, 18, 30),
    merchantNote: 'Amazon Shopping & Misc',
    paymentMethod: 'Card',
    cardId: 'icici_amazon_pay',
  ),
];

/// Notifier managing cards.
class CardsNotifier extends Notifier<List<CreditCard>> {
  @override
  List<CreditCard> build() => initialCards;

  void addCard(CreditCard card) {
    state = [...state, card];
  }

  void toggleReminder(String cardId) {
    state = [
      for (final card in state)
        if (card.id == cardId)
          card.copyWith(isReminderEnabled: !card.isReminderEnabled)
        else
          card,
    ];
  }

  void markLastStatementPaid(String cardId) {
    state = [
      for (final card in state)
        if (card.id == cardId)
          card.copyWith(isLastStatementPaid: true)
        else
          card,
    ];
  }
}

final cardsProvider = NotifierProvider<CardsNotifier, List<CreditCard>>(
  CardsNotifier.new,
);

/// Notifier managing expenses.
class ExpensesNotifier extends Notifier<List<Expense>> {
  @override
  List<Expense> build() => initialExpenses;

  void addExpense(Expense expense) {
    state = [expense, ...state];
  }
}

final expensesProvider = NotifierProvider<ExpensesNotifier, List<Expense>>(
  ExpensesNotifier.new,
);

/// Derived: Total spending for the active month (October 2026).
final totalSpentMonthProvider = Provider<int>((ref) {
  final expenses = ref.watch(expensesProvider);
  return expenses.fold<int>(0, (sum, item) => sum + item.amountMinor);
});

/// Category breakdown item.
class CategorySpend {
  const CategorySpend({
    required this.categoryId,
    required this.name,
    required this.amountMinor,
  });

  final String categoryId;
  final String name;
  final int amountMinor;
}

/// Derived: Breakdown for 4 main categories (Rent, Food & Dining, Groceries, Others).
final categorySpendBreakdownProvider = Provider<List<CategorySpend>>((ref) {
  final expenses = ref.watch(expensesProvider);

  int rent = 0;
  int food = 0;
  int groceries = 0;
  int others = 0;

  for (final exp in expenses) {
    switch (exp.categoryId) {
      case 'rent':
        rent += exp.amountMinor;
      case 'food':
        food += exp.amountMinor;
      case 'groceries':
        groceries += exp.amountMinor;
      default:
        others += exp.amountMinor;
    }
  }

  return [
    CategorySpend(categoryId: 'rent', name: 'Rent', amountMinor: rent),
    CategorySpend(categoryId: 'food', name: 'Food & Dining', amountMinor: food),
    CategorySpend(categoryId: 'groceries', name: 'Groceries', amountMinor: groceries),
    CategorySpend(categoryId: 'others', name: 'Others', amountMinor: others),
  ];
});

/// Derived: Top 5 recent expenses sorted descending by spentOn.
final recentExpensesProvider = Provider<List<Expense>>((ref) {
  final expenses = [...ref.watch(expensesProvider)];
  expenses.sort((a, b) => b.spentOn.compareTo(a.spentOn));
  return expenses.take(5).toList();
});

class CardDueDismissedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void dismiss() => state = true;
  void reset() => state = false;
}

/// Dismissed state for the credit card due card on dashboard.
final cardDueDismissedProvider =
    NotifierProvider<CardDueDismissedNotifier, bool>(
  CardDueDismissedNotifier.new,
);
