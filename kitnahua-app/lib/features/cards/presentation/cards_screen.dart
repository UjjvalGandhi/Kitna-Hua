import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/money_formatter.dart';
import '../../../core/widgets/app_surface_card.dart';
import '../../../core/widgets/dashed_add_button.dart';
import '../../../core/widgets/icon_tile.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../dashboard/data/dashboard_providers.dart';
import '../domain/credit_card.dart';
import 'add_card_sheet.dart';

/// Cards tab displaying saved credit cards and cycle trackers.
class CardsScreen extends ConsumerWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cards = ref.watch(cardsProvider);
    final now = ref.watch(clockProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Content scrolls under top bar
          Positioned.fill(
            child: cards.isEmpty
                ? _buildEmptyState(context)
                : ListView(
                    padding: const EdgeInsets.fromLTRB(20.0, 56.0, 20.0, 96.0),
                    children: [
                      const InfoNote(
                        icon: Icons.info_outline,
                        text:
                            'Track billing cycles offline. Amounts represent expenses logged in Kitna Hua for that cycle.',
                      ),
                      const SizedBox(height: 12.0),
                      for (final card in cards) ...[
                        _buildCardItem(context, ref, card, now),
                        const SizedBox(height: 12.0),
                      ],
                      DashedAddButton(
                        label: 'Add another card',
                        onTap: () => AddCardSheet.show(context),
                      ),
                    ],
                  ),
          ),

          // Pinned Adaptive Top Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AdaptiveTopBar(
              title: 'Credit Cards',
              actions: [
                IconButton(
                  onPressed: () => AddCardSheet.show(context),
                  icon: const Icon(Icons.add, size: 22.0),
                  constraints: const BoxConstraints(
                    minWidth: 48.0,
                    minHeight: 48.0,
                  ),
                  color: theme.colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem(
    BuildContext context,
    WidgetRef ref,
    CreditCard card,
    DateTime now,
  ) {
    final theme = Theme.of(context);
    final cycle = card.cycleInfo(now);
    final cycleRangeStr = DateHelpers.formatCycleRange(cycle.start, cycle.end);
    final dueStr = DateFormat('d MMM').format(cycle.dueDate);
    final daysUntilDue = DateHelpers.daysBetween(now, cycle.dueDate);
    final nextBillDate = DateTime(now.year, now.month + 1, card.billDay);
    final nextBillStr = DateFormat('d MMM').format(nextBillDate);

    return AppSurfaceCard(
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.60),
        width: 1.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: IconTile 40 + Name / Masked + Edit button
          Row(
            children: [
              IconTile(
                size: 40.0,
                borderRadius: 16.0,
                backgroundColor: Color(card.colorHex),
                icon: Icons.credit_card,
                iconSize: 20.0,
                iconColor: Colors.white,
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.nickname,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (card.maskedNumber.isNotEmpty) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        card.maskedNumber,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11.0,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, size: 18.0),
                constraints: const BoxConstraints(
                  minWidth: 48.0,
                  minHeight: 48.0,
                ),
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          const SizedBox(height: 12.0),

          // Inner box
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: AppRadii.rowBorderRadius,
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.40),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current billing cycle ($cycleRangeStr)',
                  style: TextStyle(
                    fontSize: 11.0,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      MoneyFormatter.formatPaise(card.currentCycleAmountMinor),
                      style: theme.textTheme.headlineSmall
                          ?.withTabularFigures
                          .copyWith(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Expanded(
                      child: Text(
                        ' tracked this cycle',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),

          // Bottom cycle status & reminder toggle row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Due $dueStr · in $daysUntilDue days',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2.0),
                    Text(
                      'Bill generates $nextBillStr',
                      style: TextStyle(
                        fontSize: 11.0,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Reminder',
                    style: TextStyle(
                      fontSize: 11.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  AdaptiveSwitch(
                    value: card.isReminderEnabled,
                    onChanged: (val) {
                      ref.read(cardsProvider.notifier).toggleReminder(card.id);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTile(
            size: 64.0,
            borderRadius: 24.0,
            backgroundColor: theme.colorScheme.surfaceContainer,
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
              width: 1.0,
            ),
            icon: Icons.credit_card_off_outlined,
            iconSize: 30.0,
            iconColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16.0),
          Text(
            'No credit cards added yet',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            'Add your credit cards to track billing cycles and receive offline due date reminders.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.0,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: AppRadii.rowBorderRadius,
            ),
            child: Column(
              children: [
                _buildEmptyBullet(
                  theme,
                  Icons.notifications_outlined,
                  'Due date reminder 1, 3, or 5 days before',
                ),
                const SizedBox(height: 10.0),
                _buildEmptyBullet(
                  theme,
                  Icons.lock_outline,
                  'No card number, CVV or expiry ever requested',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          PrimaryActionButton(
            label: 'Add your first card',
            icon: Icons.add,
            onPressed: () => AddCardSheet.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyBullet(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.0, color: theme.colorScheme.primary),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.0,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
