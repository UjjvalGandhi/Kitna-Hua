import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/adaptive/adaptive.dart';
import '../../../core/widgets/app_surface_card.dart';

/// Settings screen with user profile and accessibility options.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final platformInfo = ref.watch(platformInfoProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Scrollable settings items
          Positioned.fill(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20.0, 68.0, 20.0, 40.0),
              children: [
                AppSurfaceCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          'UG',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ujjval Gandhi',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Local Offline Mode',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                AppSurfaceCard(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(Icons.currency_rupee),
                        title: Text('Currency'),
                        trailing: Text('INR (₹)'),
                      ),
                      const Divider(height: 1.0),
                      const ListTile(
                        leading: Icon(Icons.notifications_outlined),
                        title: Text('Card Reminders'),
                        trailing: Text('Enabled'),
                      ),
                      const Divider(height: 1.0),
                      ListTile(
                        leading: const Icon(Icons.accessibility_new_outlined),
                        title: const Text('Reduce Transparency'),
                        subtitle: const Text('Forces solid surfaceContainer'),
                        trailing: AdaptiveSwitch(
                          value: platformInfo.reduceTransparency,
                          onChanged: (val) {
                            ref
                                .read(platformInfoProvider.notifier)
                                .setReduceTransparency(val);
                          },
                        ),
                      ),
                      const Divider(height: 1.0),
                      const ListTile(
                        leading: Icon(Icons.info_outline),
                        title: Text('About Kitna Hua'),
                        trailing: Text('v0.1.0'),
                      ),
                    ],
                  ),
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
              title: 'Settings',
            ),
          ),
        ],
      ),
    );
  }
}
