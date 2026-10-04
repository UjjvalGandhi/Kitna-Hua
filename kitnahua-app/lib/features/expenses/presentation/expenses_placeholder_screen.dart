import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/expense_row_tile.dart';
import '../../categories/data/categories_data.dart';
import '../../dashboard/data/dashboard_providers.dart';

/// Screen listing all expenses.
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = context.appColors;
    final expenses = ref.watch(expensesProvider);
    final cards = ref.watch(cardsProvider);

    return AdaptiveScrollPage(
      title: 'Expenses',
      hasAddButton: true,
      children: [
        for (final exp in expenses) ...[
          _buildRow(exp, cards, appColors),
          const SizedBox(height: 8.0),
        ],
      ],
    );
  }

  Widget _buildRow(
    dynamic exp,
    List<dynamic> cards,
    AppThemeExtension appColors,
  ) {
    final cat = CategoriesData.findById(exp.categoryId);
    final catColor = appColors.colorForCategory(cat.name);
    final isCard = exp.paymentMethod == 'Card';
    String paymentLabel = exp.paymentMethod;

    if (isCard && exp.cardId != null) {
      for (final c in cards) {
        if (c.id == exp.cardId) {
          paymentLabel = c.shortTitle;
          break;
        }
      }
    }

    return ExpenseRowTile(
      title: exp.merchantNote,
      categoryName: cat.name,
      categoryIcon: cat.icon,
      categoryColor: catColor,
      amountMinor: exp.amountMinor,
      paymentLabel: paymentLabel,
      isCardPayment: isCard,
    );
  }
}
