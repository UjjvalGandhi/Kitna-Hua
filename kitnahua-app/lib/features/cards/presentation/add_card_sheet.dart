import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/inline_input_decoration.dart';
import '../../../core/adaptive/adaptive.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/info_note.dart';
import '../../../core/widgets/primary_action_button.dart';
import '../../dashboard/data/dashboard_providers.dart';
import '../domain/credit_card.dart';
import 'notification_permission_dialog.dart';

/// Bottom sheet for adding a new credit card to track billing cycle and reminders.
class AddCardSheet extends ConsumerStatefulWidget {
  const AddCardSheet({super.key});

  static Future<CreditCard?> show(BuildContext context) {
    return showModalBottomSheet<CreditCard>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddCardSheet(),
    );
  }

  @override
  ConsumerState<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends ConsumerState<AddCardSheet> {
  final _nicknameController = TextEditingController();
  final _last4Controller = TextEditingController();

  int _billDay = 16;
  int _dueDay = 7;
  int _remindDaysBefore = 3;

  @override
  void dispose() {
    _nicknameController.dispose();
    _last4Controller.dispose();
    super.dispose();
  }

  Future<void> _pickDay(bool isBillDay) async {
    final currentDay = isBillDay ? _billDay : _dueDay;
    final picked = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBillDay ? 'Bill Generation Day' : 'Payment Due Day'),
        content: SizedBox(
          width: 280.0,
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              final day = index + 1;
              final isSel = day == currentDay;
              final theme = Theme.of(context);
              return InkWell(
                onTap: () => Navigator.of(context).pop(day),
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSel ? theme.colorScheme.primary : null,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    if (picked != null) {
      setState(() {
        if (isBillDay) {
          _billDay = picked;
        } else {
          _dueDay = picked;
        }
      });
    }
  }

  Future<void> _saveCard() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) return;

    // Show C5 Notification Permission primer first
    final allowed = await NotificationPermissionDialog.show(
      context,
      _remindDaysBefore,
    );

    if (!mounted) return;

    final newCard = CreditCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      nickname: nickname,
      last4: _last4Controller.text.trim().isEmpty
          ? null
          : _last4Controller.text.trim(),
      billDay: _billDay,
      dueDay: _dueDay,
      remindDaysBefore: _remindDaysBefore,
      isReminderEnabled: allowed ?? true,
      colorHex: 0xFF006A60,
    );

    ref.read(cardsProvider.notifier).addCard(newCard);
    Navigator.of(context).pop(newCard);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveSheet(
      title: 'Add Credit Card',
      subtitle: 'Enable bill cycle & payment due tracking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nickname Field
          _buildFieldLabel('Card Nickname'),
          const SizedBox(height: 6.0),
          _buildTextInput(
            controller: _nicknameController,
            hintText: 'e.g. HDFC Millennia',
          ),
          const SizedBox(height: 12.0),

          // Last 4 Digits
          _buildFieldLabel('Last 4 digits (optional)'),
          const SizedBox(height: 6.0),
          _buildTextInput(
            controller: _last4Controller,
            hintText: '4821',
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
          const SizedBox(height: 12.0),

          // Two columns: Bill Day & Due Day
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Bill Generation Day'),
                    const SizedBox(height: 6.0),
                    _buildDayPicker(
                      value: '${_billDay}th of month',
                      onTap: () => _pickDay(true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Payment Due Day'),
                    const SizedBox(height: 6.0),
                    _buildDayPicker(
                      value: '${_dueDay}th of month',
                      onTap: () => _pickDay(false),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Remind me before due date
          _buildFieldLabel('Remind me before due date'),
          const SizedBox(height: 8.0),
          AdaptiveSegmented<int>(
            groupValue: _remindDaysBefore,
            onValueChanged: (days) => setState(() => _remindDaysBefore = days),
            children: const {
              1: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('1 day before'),
              ),
              3: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('3 days before'),
              ),
              5: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('5 days before'),
              ),
            },
          ),
          const SizedBox(height: 16.0),

          // Info Note
          const InfoNote(
            icon: Icons.verified_user_outlined,
            text:
                'We only use these dates for reminders. No card details are stored.',
          ),
          const SizedBox(height: 16.0),

          // Save Button
          PrimaryActionButton(
            label: 'Save card & enable reminders',
            icon: Icons.notifications_active_outlined,
            onPressed: _saveCard,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: TextStyle(
        fontSize: 11.0,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 48.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: AppRadii.rowBorderRadius,
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.50),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        buildCounter: maxLength != null
            ? (_, {required currentLength, required isFocused, maxLength}) =>
                  null
            : null,
        style: TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurface,
        ),
        decoration: inlineInputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildDayPicker({required String value, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.rowBorderRadius,
      child: Container(
        height: 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: AppRadii.rowBorderRadius,
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.50),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
