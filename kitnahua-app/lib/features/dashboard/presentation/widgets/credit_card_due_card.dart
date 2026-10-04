import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_radii.dart';
import '../../../../core/utils/money_formatter.dart';
import '../../../../core/widgets/icon_tile.dart';
import '../../data/dashboard_providers.dart';

/// Card alerting user about upcoming credit card payment due.
class CreditCardDueCard extends ConsumerWidget {
  const CreditCardDueCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDismissed = ref.watch(cardDueDismissedProvider);
    final cards = ref.watch(cardsProvider);

    final hdfcCard = cards.firstWhere(
      (c) => c.id == 'hdfc_millennia',
      orElse: () => cards.first,
    );

    if (isDismissed || hdfcCard.isLastStatementPaid) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.10),
        borderRadius: AppRadii.rowBorderRadius,
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.30),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top Row: IconTile + Text details + Close Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTile(
                size: 36.0,
                borderRadius: 12.0,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.20),
                icon: Icons.credit_card,
                iconSize: 18.0,
                iconColor: theme.colorScheme.primary,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HDFC Millennia payment due in 3 days',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 11.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          const TextSpan(text: '7 Oct · '),
                          TextSpan(
                            text: MoneyFormatter.formatPaise(
                              hdfcCard.lastStatementAmountMinor,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const TextSpan(text: ' tracked last cycle'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  ref.read(cardDueDismissedProvider.notifier).dismiss();
                },
                icon: const Icon(Icons.close, size: 16.0),
                constraints: const BoxConstraints(
                  minWidth: 48.0,
                  minHeight: 48.0,
                ),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // Divider
          Divider(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
            height: 1.0,
            thickness: 1.0,
          ),
          const SizedBox(height: 10.0),

          // Bottom Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Statement generated on 16 Sep',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              FilledButton.icon(
                onPressed: () {
                  ref
                      .read(cardsProvider.notifier)
                      .markLastStatementPaid('hdfc_millennia');
                },
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(0, 36.0),
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  tapTargetSize: MaterialTapTargetSize.padded,
                ),
                icon: const Icon(Icons.check_circle_outline, size: 14.0),
                label: const Text(
                  'Mark as paid',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
