import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/dashed_add_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/selectable_option_tile.dart';
import '../../cards/presentation/add_card_sheet.dart';
import '../../dashboard/data/dashboard_providers.dart';

/// Selection result for payment method.
class PaymentMethodSelection {
  const PaymentMethodSelection({
    required this.method,
    this.cardId,
    this.displayLabel,
  });

  final String method; // 'UPI', 'Card', 'Cash', 'Net Banking', 'Auto-debit'
  final String? cardId;
  final String? displayLabel;
}

/// Bottom sheet for selecting payment method or credit card.
class PaymentMethodSheet extends ConsumerWidget {
  const PaymentMethodSheet({
    super.key,
    required this.currentMethod,
    this.currentCardId,
  });

  final String currentMethod;
  final String? currentCardId;

  static Future<PaymentMethodSelection?> show({
    required BuildContext context,
    required String currentMethod,
    String? currentCardId,
  }) {
    return showModalBottomSheet<PaymentMethodSelection>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodSheet(
        currentMethod: currentMethod,
        currentCardId: currentCardId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cards = ref.watch(cardsProvider);
    final now = ref.watch(clockProvider);

    return AdaptiveSheet(
      title: 'Select Payment Method',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section 1: Credit cards
          const SectionHeader(
            title: 'Credit Cards (Cycle Reminders)',
          ),
          const SizedBox(height: 8.0),

          for (final card in cards) ...[
            Builder(
              builder: (context) {
                final cycle = card.cycleInfo(now);
                final cycleEndStr = DateFormat('d MMM').format(cycle.end);
                final dueStr = DateFormat('d MMM').format(cycle.dueDate);
                final isSelected =
                    currentMethod == 'Card' && currentCardId == card.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SelectableOptionTile(
                    title: card.shortTitle,
                    subtitle: 'Cycle ends $cycleEndStr · Due $dueStr',
                    isSelected: isSelected,
                    onTap: () {
                      Navigator.of(context).pop(
                        PaymentMethodSelection(
                          method: 'Card',
                          cardId: card.id,
                          displayLabel: card.shortTitle,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],

          // Dashed Add Button for new card
          DashedAddButton(
            label: 'Add credit card',
            onTap: () async {
              final newCard = await AddCardSheet.show(context);
              if (newCard != null && context.mounted) {
                Navigator.of(context).pop(
                  PaymentMethodSelection(
                    method: 'Card',
                    cardId: newCard.id,
                    displayLabel: newCard.shortTitle,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 16.0),

          // Divider
          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            height: 1.0,
            thickness: 1.0,
          ),
          const SizedBox(height: 16.0),

          // Section 2: Other payment methods
          const SectionHeader(
            title: 'Other Payment Methods',
          ),
          const SizedBox(height: 10.0),

          // 2x2 grid
          Row(
            children: [
              Expanded(
                child: _buildOtherTile(
                  context,
                  label: 'UPI',
                  icon: Icons.qr_code_2,
                  isSelected: currentMethod == 'UPI',
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildOtherTile(
                  context,
                  label: 'Cash',
                  icon: Icons.payments_outlined,
                  isSelected: currentMethod == 'Cash',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: _buildOtherTile(
                  context,
                  label: 'Net Banking',
                  icon: Icons.account_balance_outlined,
                  isSelected: currentMethod == 'Net Banking',
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: _buildOtherTile(
                  context,
                  label: 'Auto-debit',
                  icon: Icons.sync_outlined,
                  isSelected: currentMethod == 'Auto-debit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherTile(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pop(
          PaymentMethodSelection(
            method: label,
            displayLabel: label,
          ),
        );
      },
      borderRadius: AppRadii.rowBorderRadius,
      child: Container(
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.10)
              : theme.colorScheme.surfaceContainer,
          borderRadius: AppRadii.rowBorderRadius,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.0,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
