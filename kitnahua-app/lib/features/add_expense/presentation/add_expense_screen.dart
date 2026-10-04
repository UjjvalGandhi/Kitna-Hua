import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/inline_input_decoration.dart';
import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_theme_extension.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../categories/data/categories_data.dart';
import '../../dashboard/data/dashboard_providers.dart';
import '../../expenses/domain/expense.dart';
import 'payment_method_sheet.dart';
import 'widgets/numeric_keypad.dart';

/// Full-screen entry for adding a new expense.
class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  final _aiPromptController = TextEditingController();
  final _merchantController = TextEditingController(text: 'Swiggy Dinner');

  String _amountString = '450';
  String _selectedCategoryId = 'food';
  String _paymentMethod = 'UPI';
  String? _cardId;
  String _paymentDisplay = 'UPI';
  late DateTime _spentOn;

  bool _isAiParsed = true;
  bool _isParsing = false;

  late AnimationController _cursorController;

  @override
  void initState() {
    super.initState();
    _spentOn = ref.read(clockProvider);
    _cursorController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _aiPromptController.dispose();
    _merchantController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  int get _amountPaise {
    final parsed = double.tryParse(_amountString) ?? 0.0;
    return (parsed * 100).round();
  }

  void _onDigit(String digit) {
    setState(() {
      if (_amountString == '0') {
        _amountString = digit;
      } else {
        if (_amountString.contains('.')) {
          final parts = _amountString.split('.');
          if (parts[1].length < 2) {
            _amountString += digit;
          }
        } else {
          if (_amountString.length < 7) {
            _amountString += digit;
          }
        }
      }
    });
  }

  void _onDot() {
    setState(() {
      if (!_amountString.contains('.')) {
        _amountString = '$_amountString.';
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountString.length > 1) {
        _amountString = _amountString.substring(0, _amountString.length - 1);
      } else {
        _amountString = '0';
      }
    });
  }

  Future<void> _handleParse() async {
    final query = _aiPromptController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isParsing = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    // Quick regex parser
    final amountMatch = RegExp(r'\d+').firstMatch(query);
    if (amountMatch != null) {
      _amountString = amountMatch.group(0)!;
    }

    final lower = query.toLowerCase();
    if (lower.contains('swiggy') ||
        lower.contains('dinner') ||
        lower.contains('food') ||
        lower.contains('zomato')) {
      _selectedCategoryId = 'food';
      _merchantController.text = 'Swiggy Dinner';
      _paymentMethod = 'UPI';
      _paymentDisplay = 'UPI';
    } else if (lower.contains('uber') ||
        lower.contains('ola') ||
        lower.contains('cab')) {
      _selectedCategoryId = 'transport';
      _merchantController.text = 'Uber Ride';
    } else if (lower.contains('bigbasket') ||
        lower.contains('grocery') ||
        lower.contains('blinkit')) {
      _selectedCategoryId = 'groceries';
      _merchantController.text = 'Grocery Order';
    } else {
      _merchantController.text = query.replaceAll(RegExp(r'\d+'), '').trim();
    }

    setState(() {
      _isParsing = false;
      _isAiParsed = true;
    });
  }

  void _saveExpense() {
    final exp = Expense(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      amountMinor: _amountPaise,
      categoryId: _selectedCategoryId,
      spentOn: _spentOn,
      merchantNote: _merchantController.text.trim().isEmpty
          ? 'Expense'
          : _merchantController.text.trim(),
      paymentMethod: _paymentMethod,
      cardId: _cardId,
      source: _isAiParsed ? 'ai' : 'manual',
    );

    AdaptiveHaptics.lightImpact();
    ref.read(expensesProvider.notifier).addExpense(exp);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final now = ref.watch(clockProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            AdaptiveTopBar(
              title: 'Add Expense',
              leading: AdaptiveBarButton(
                tooltip: 'Close',
                icon: Icons.close_rounded,
                onPressed: () => context.pop(),
              ),
            ),

            // Scrollable fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  // AI Smart Entry Bar
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: AppRadii.rowBorderRadius,
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.25,
                        ),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 18.0,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            controller: _aiPromptController,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: inlineInputDecoration(
                              hintText: 'Type: 450 swiggy dinner',
                              hintStyle: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            onSubmitted: (_) => _handleParse(),
                          ),
                        ),
                        SizedBox(
                          height: 32.0,
                          child: FilledButton(
                            onPressed: _isParsing ? null : _handleParse,
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              minimumSize: const Size(48.0, 32.0),
                              tapTargetSize: MaterialTapTargetSize.padded,
                            ),
                            child: _isParsing
                                ? SizedBox(
                                    width: 14.0,
                                    height: 14.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                  )
                                : const Text(
                                    'Parse',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),

                  // Amount block
                  Column(
                    children: [
                      Text(
                        'AMOUNT (INR)',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            _amountString,
                            style: theme
                                .textTheme
                                .displaySmall
                                ?.withTabularFigures
                                .copyWith(
                                  fontSize: 44.0,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface,
                                ),
                          ),
                          FadeTransition(
                            opacity: _cursorController,
                            child: Container(
                              width: 2.5,
                              height: 36.0,
                              margin: const EdgeInsets.only(left: 4.0),
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14.0),

                  // Category label & wrap
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: [
                      for (final cat in CategoriesData.all.take(5))
                        _buildCategoryChip(cat, appColors),
                      _buildMoreChip(),
                    ],
                  ),
                  const SizedBox(height: 12.0),

                  // Merchant/Note row
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: AppRadii.rowBorderRadius,
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.40,
                        ),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 20.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Merchant / Note',
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (_isAiParsed) ...[
                                    const SizedBox(width: 4.0),
                                    Icon(
                                      Icons.auto_awesome,
                                      size: 11.0,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ],
                                ],
                              ),
                              TextField(
                                controller: _merchantController,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                                decoration: inlineInputDecoration(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  // Date & Payment Method 2-column row
                  Row(
                    children: [
                      // Date Field
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainer,
                            borderRadius: AppRadii.rowBorderRadius,
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.40),
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 16.0,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    Text(
                                      DateHelpers.formatDayWithDate(
                                        _spentOn,
                                        now,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Payment Method Field (opens C3)
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final res = await PaymentMethodSheet.show(
                              context: context,
                              currentMethod: _paymentMethod,
                              currentCardId: _cardId,
                            );
                            if (res != null) {
                              setState(() {
                                _paymentMethod = res.method;
                                _cardId = res.cardId;
                                _paymentDisplay =
                                    res.displayLabel ?? res.method;
                              });
                            }
                          },
                          borderRadius: AppRadii.rowBorderRadius,
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainer,
                              borderRadius: AppRadii.rowBorderRadius,
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.40),
                                width: 1.0,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet_outlined,
                                  size: 16.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Payment Mode',
                                        style: TextStyle(
                                          fontSize: 11.0,
                                          color: theme
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                      ),
                                      Text(
                                        _paymentDisplay,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  size: 16.0,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Pinned Keypad & Save Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 4.0, 20.0, 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NumericKeypad(
                    onDigit: _onDigit,
                    onDot: _onDot,
                    onBackspace: _onBackspace,
                  ),
                  const SizedBox(height: 12.0),
                  PrimaryActionButton(
                    label:
                        'Save Expense (${MoneyFormatter.formatPaise(_amountPaise)})',
                    icon: Icons.check,
                    onPressed: _amountPaise > 0 ? _saveExpense : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(dynamic category, AppThemeExtension appColors) {
    final isSelected = _selectedCategoryId == category.id;
    final catColor = appColors.colorForCategory(category.name);

    return InkWell(
      onTap: () => setState(() => _selectedCategoryId = category.id),
      borderRadius: BorderRadius.circular(999.0),
      child: Container(
        height: 36.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? catColor
              : Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(999.0),
          border: isSelected
              ? null
              : Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.outlineVariant.withValues(alpha: 0.50),
                  width: 1.0,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 14.0,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
            ),
            const SizedBox(width: 6.0),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoreChip() {
    return Container(
      height: 36.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(999.0),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.50),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.more_horiz,
            size: 16.0,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4.0),
          Text(
            'More',
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
