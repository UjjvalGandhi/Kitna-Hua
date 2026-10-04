import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/widgets/expense_row_tile.dart';
import '../../../core/widgets/section_header.dart';
import '../../categories/data/categories_data.dart';
import '../data/dashboard_providers.dart';
import 'widgets/category_spend_card.dart';
import 'widgets/credit_card_due_card.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/total_spent_card.dart';

/// Dashboard (Home) Screen.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appColors = context.appColors;
    final recentExpenses = ref.watch(recentExpensesProvider);
    final cards = ref.watch(cardsProvider);

    return AdaptiveScrollPage(
      title: 'October 2026',
      largeTitle: const DashboardMonthTitle(monthYearText: 'October 2026'),
      leading: const DashboardAvatarButton(),
      actions: const [DashboardSyncButton()],
      hasAddButton: true,
      children: [
        const TotalSpentCard(),
        const SizedBox(height: 12.0),
        const CategorySpendCard(),
        const SizedBox(height: 12.0),
        const CreditCardDueCard(),
        const SizedBox(height: 20.0),
        SectionHeader(
          title: 'Recent Expenses',
          actionLabel: 'View all',
          fontSize: 12.0,
          onAction: () => context.go('/expenses'),
        ),
        const SizedBox(height: 8.0),
        for (final exp in recentExpenses) ...[
          _buildExpenseTile(exp, cards, appColors),
          const SizedBox(height: 8.0),
        ],
      ],
    );
  }

  Widget _buildExpenseTile(
    dynamic exp,
    List<dynamic> cards,
    AppThemeExtension appColors,
  ) {
    final category = CategoriesData.findById(exp.categoryId);
    final categoryColor = appColors.colorForCategory(category.name);

    final bool isCard = exp.paymentMethod == 'Card';
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
      categoryName: category.name,
      categoryIcon: category.icon,
      categoryColor: categoryColor,
      amountMinor: exp.amountMinor,
      paymentLabel: paymentLabel,
      isCardPayment: isCard,
    );
  }
}
