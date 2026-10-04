import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/adaptive/adaptive.dart';
import '../features/add_expense/presentation/add_expense_screen.dart';
import '../features/budgets/presentation/budgets_placeholder_screen.dart';
import '../features/cards/presentation/cards_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/expenses_placeholder_screen.dart';
import '../features/insights/presentation/insights_screen.dart';
import '../features/settings/presentation/settings_placeholder_screen.dart';
import 'app_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Main application router configuration using go_router.
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  observers: [CNTabBarRouteObserver()],
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home (Dashboard)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              pageBuilder: (context, state) =>
                  const AdaptivePage(child: DashboardScreen()),
            ),
          ],
        ),

        // Tab 1: Expenses
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/expenses',
              pageBuilder: (context, state) =>
                  const AdaptivePage(child: ExpensesScreen()),
            ),
          ],
        ),

        // Tab 2: Budgets
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/budgets',
              pageBuilder: (context, state) =>
                  const AdaptivePage(child: BudgetsScreen()),
            ),
          ],
        ),

        // Tab 3: Insights
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/insights',
              pageBuilder: (context, state) =>
                  const AdaptivePage(child: InsightsScreen()),
            ),
          ],
        ),

        // Tab 4: Cards
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cards',
              pageBuilder: (context, state) =>
                  const AdaptivePage(child: CardsScreen()),
            ),
          ],
        ),
      ],
    ),

    // Fullscreen modals / routes
    GoRoute(
      path: '/add-expense',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          const AdaptivePage(child: AddExpenseScreen()),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          const AdaptivePage(child: SettingsScreen()),
    ),
  ],
);
