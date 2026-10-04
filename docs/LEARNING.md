# Kitna Hua — Learning Notes

## Design rules (All Future Steps)
- `design/mockups.html` is the source of truth. Read only the needed section:
  - Tokens: lines 75–232
  - Notifications: lines 238–330
  - Dashboard: lines 333–508
  - Payment method sheet: lines 690–805
  - Add card sheet: lines 918–1031
  - Permission explainer: lines 1149–1226
  - Cards screen: lines 1304–1510
  - Insights: lines 1511–1632
  - Read the **LIGHT version only**; build dark mode from tokens.
- **Bottom nav tabs**: Home, Expenses, Budgets, Insights, Cards. Settings opens from the avatar on Home.
- **Dashboard structure**: The dashboard KEEPS the Category Spend donut card (donut + top 3 + "Others"), placed between the Total card and the credit card due card.
- **Unmocked screens**: For screens not explicitly rendered in the mockup (Login, Onboarding, Expenses list, Category detail, Budgets, Settings, Recap), reuse the same components and tokens; no new visual styles.
- **Parity verification**: At the end of each screen step, include a "Mockup parity" table in chat: `element | mockup | built | match ✅/❌`. Fix every ❌ before stopping.

---

## Step 1: Design Tokens, Theme & Money Formatter

### What was built
- **Core Tokens**: Spacing (`AppSpacing`), Radii (`AppRadii`), Elevation (`AppElevation`), and Material 3 Color definitions (`AppColors`) in `kitnahua-app/lib/core/theme/`.
- **M3 Theme & Extension**: Light/Dark `ThemeData` (`AppTheme`) with Inter typography and custom `ThemeExtension<AppThemeExtension>` for the 8 category colors with light and dark tints in `kitnahua-app/lib/core/theme/app_theme_extension.dart`.
- **Indian Money Formatter**: Minor-units (paise) integer formatter with Indian digit grouping (`₹1,23,450`), tabular figures support, and paise rounding in `kitnahua-app/lib/core/utils/money_formatter.dart`.
- **Unit Tests**: Full test suite verifying `₹0`, `₹450`, `₹1,23,450`, paise rounding, and theme category mapping in `kitnahua-app/test/core/utils/money_formatter_test.dart` and `kitnahua-app/test/core/theme/app_theme_test.dart`.

### Riverpod concept introduced: The Foundation & Immutable State
- **What it is**: In Riverpod, state is held outside of the widget tree in pure, immutable data structures and exposed through typed *Providers*. Before writing stateful business logic, you build a foundation of deterministic, pure domain utilities (like our `MoneyFormatter` and theme tokens).
- **Why it's used here**: In financial apps, floating-point math causes rounding bugs (e.g. `0.1 + 0.2 = 0.30000000000000004`). By standardizing on `int minorUnits` (paise) and pure formatting functions, our upcoming Riverpod providers can process ledger balances deterministically without side effects.
- **Mental Model**: Think of Riverpod like a clean electrical grid. Providers are power stations producing data, while widgets are appliances plugging into sockets (`ref.watch`). Pure functions and tokens are the standard wiring and voltage specs.

### Data flow
`Raw integer paise (int) → MoneyFormatter.format() → Text widget (tabular nums)`

### ref.watch vs ref.read vs ref.listen
- **Step 1 Context**: In Step 1, we set up pure utilities and Flutter `ThemeExtension`.
- **`ref.watch`**: Used inside widget `build()` or inside other providers to continuously observe a value and rebuild whenever it changes.
- **`ref.read`**: Used inside button callbacks (e.g. `onPressed: () => ref.read(...)`) to take a snapshot of a provider without subscribing to future rebuilds.
- **`ref.listen`**: Used inside widget `build()` or `initState` to run side effects (like showing a SnackBar or navigating) when a provider changes.

### One common mistake with this concept
Using `double` for currency calculations or formatting numbers with ad-hoc string manipulation inside widgets instead of relying on a centralized, tested integer-minor-unit formatter.

### Try it yourself
Open `kitnahua-app/lib/core/utils/money_formatter.dart` and change `showPaise: true` in `_MoneyRow` in `kitnahua-app/lib/main.dart` to see how paise decimals render alongside whole rupees.

---

## Step 1.5: Mockup Parity Alignment

### What changed
1. **Color Token Corrections**: Swapped `outline` and `outlineVariant` in `AppColors` (light outline `#6F7976` is darker than outlineVariant `#BFC9C5`; dark outline `#899390` is darker than outlineVariant `#3F4947`). Completed full `ColorScheme` definitions with `surfaceContainerLowest`, `surfaceContainerHighest`, and transparent `surfaceTint`.
2. **Typography Full Scale**: All 15 text styles populated using bundled `assets/fonts/Inter-*.ttf` with `GoogleFonts.config.allowRuntimeFetching = false`. Minimum text size is strictly 11sp.
3. **Component Theme Presets**:
   - `CardTheme`: radius 24 (`AppRadii.card`), elevation 0, 1px `outlineVariant` border at 50% opacity.
   - `NavigationBarTheme`: height 64, surfaceContainer background, indicator at 15% opacity, 11sp labels.
   - `BottomSheetTheme` / `DialogTheme`: radius 24, drag handle enabled.
   - `InputDecorationTheme`: filled with surfaceContainer, radius 12, borderless idle state, 1.5px primary focused border.
4. **AppRadii Component Aliases**: Added `card=24`, `row=16`, `iconTile=12`, `input=12`, `chip=full`, `pill=full`, `sheet=24`.
5. **AppThemeExtension Tokens**: Added `categoryTint(color)` (15% light / 20% dark), `successContainer`, `warningContainer`, and edge-to-edge transparent `SystemUiOverlayStyle`.
6. **Token Gallery Preview**: Recreated `design/mockups.html` Design Tokens section with live Light/Dark toggle in `main.dart`.

### Why ThemeData/ThemeExtension makes screens match automatically
By codifying every radius, border, elevation, category tint, and color role into `ThemeData` and `AppThemeExtension`, individual screen widgets do not need ad-hoc styling. A simple `Card()`, `TextField()`, `NavigationBar`, or `context.appColors.categoryTint()` naturally and automatically renders with pixel-perfect mockup parity in both light and dark modes without manual overrides.

---

## Step 2: Full UI Implementation & Mockup Parity

### What was built
1. **App Shell & Router**: `go_router` `StatefulShellRoute` with 5 navigation tabs: Home (Dashboard), Expenses, Budgets, Insights, and Cards, styled with M3 height 64, surfaceContainer, 15% pill indicator, and 11sp labels.
2. **Shared Widget Library** (`lib/core/widgets/`):
   - `AppSurfaceCard`: surfaceContainer, radius 24, padding 16, outlineVariant 50% border.
   - `ExpenseRowTile`: 36x36 IconTile with dynamic category tint, merchant title, category subtitle, right-aligned tabular amount, and payment badge.
   - `SectionHeader`: uppercase tracking 0.8 with trailing action.
   - `StatusPill`: pill radius, sync status icon + copy.
   - `MetricBadge`: success, category, and neutral pill/rounded variants.
   - `BudgetProgressBar`: height 10, dynamic warning (>=80%) and error (>=100%) colors.
   - `AppBottomSheet`: top radius 28, visible drag handle, header with close action.
   - `SelectableOptionTile`: selectable card/method radio tile.
   - `DashedAddButton`: CustomPainter dashed 1px primary border.
   - `PrimaryActionButton`: height 48, radius 16, primary background.
   - `InfoNote`: callout container with 16px primary icon and line height 1.5.
   - `MonthSelector`: plain and pill variants with dropdown icon.
3. **Screens Implemented**:
   - **C1 Dashboard (Home)**: Top bar with avatar, month selector, pending sync pill; Total spend card with budget progress bar; Category Spend donut chart (`fl_chart`); Credit card payment due card with "Mark as paid" action; Recent expenses list; Extended FAB ("Add Expense").
   - **C2 Add Expense**: Natural-language AI parsing input ("450 swiggy dinner"), amount block with animated cursor, 2-row category chip selector, merchant/note editor, 2-column Date/Payment pickers, custom 3x4 numeric keypad, and live save button.
   - **C3 Payment Method Sheet**: Credit cards with calculated billing cycles & reminders, dashed add button, and 2x2 grid for UPI, Cash, Net Banking, and Auto-debit.
   - **C4 Add Credit Card Sheet**: Nickname input, optional last 4 digits, 1–31 day grid pickers for bill day and due day, reminder selector chips (1/3/5 days before), and offline security info note.
   - **C5 Notification Permission Dialog**: Permission explainer dialog with 56px icon tile, 3 bulleted assurances, and Allow / Not now actions.
   - **C6 Cards Tab**: Billing cycle tracking cards with cycle dates, tracked spend, due dates, reminder switch, and illustrated empty state.
   - **C7 Insights Tab**: Monthly AI briefing summary card, 4 monthly insight cards (Dining Spend Down, Rent 41%, Grocery 65%, Top Merchant Swiggy), and footnote.

### Riverpod Concepts Used
- **`clockProvider` override**: Deterministic simulation reference (`DateTime(2026, 10, 4)`) used across all cycle and relative date computations instead of uncontrolled `DateTime.now()`.
- **Derived Providers (`Provider<T>`)**: `totalSpentMonthProvider`, `categorySpendBreakdownProvider`, and `recentExpensesProvider` automatically derive totals from raw ledger expenses without duplicating state.
- **`Notifier<T>`**: `CardsNotifier` and `ExpensesNotifier` manage immutable collection state and business actions (`addCard`, `toggleReminder`, `markLastStatementPaid`, `addExpense`).
- **`AsyncNotifier<T>`**: `InsightsNotifier` models loading skeleton, refreshed computations, and error/retry states for financial analysis.

### Data Flow
`clockProvider + expensesProvider → derived Providers (Totals / Categories) → UI (ref.watch) → Notifier actions (ref.read)`

### ref.watch vs ref.read vs ref.listen
- **`ref.watch`**: Subscribes the widget to reactive state (e.g. `final total = ref.watch(totalSpentMonthProvider);`). Whenever expenses change, total recalculates and UI updates.
- **`ref.read`**: Executes actions inside callbacks without re-triggering builds (e.g. `ref.read(cardsProvider.notifier).markLastStatementPaid('hdfc_millennia')`).
- **`ref.listen`**: Listens for state transitions to trigger one-shot effects (e.g. dialogs or snackbars).

### Common Mistake
Re-computing derived state (like total sum or category breakdown) inside widget `build()` methods instead of delegating to derived providers (`Provider<T>`). Putting calculations in derived providers ensures memoization and prevents unnecessary rebuilds.

### Try It Yourself
Tap "+ Add Expense" from the Dashboard, type "450 swiggy dinner" into the AI Smart Entry bar, and tap "Parse". Notice how the amount, category, and merchant note are automatically extracted and selected!

---

## Step 3: iOS Liquid Glass & Adaptive Architecture (Part B2)

### What was built
1. **Core Adaptive Architecture (`lib/core/adaptive/`)**:
   - `PlatformInfo`: Immutable platform configuration containing `isIOS`, `iosMajorVersion`, and `reduceTransparency`. Exposes helper getters `isIOS26OrLater`, `useLiquidGlass`, and `isAndroid`.
   - `PlatformInfoNotifier`: Auto-detects host platform and iOS major version (auto-initialized via `PlatformVersion`). Subscribes to `WidgetsBindingObserver` to react instantly when the user changes accessibility settings (like Reduce Transparency / High Contrast) in iOS Settings at runtime.
   - `GlassSurface`: Reusable glass surface wrapping `CupertinoLiquidGlass` with blur sigma 20, 1px highlight border (`Color(0x59FFFFFF)` light / `Color(0x26FFFFFF)` dark), and subtle shadow. When Reduce Transparency is ON (or running on Android/iOS < 26), cleanly falls back to solid `surfaceContainer`.
   - `AdaptiveTabScaffold`: Android renders the Material 3 `NavigationBar` with 5 pill destinations; iOS 26+ renders the native Liquid Glass floating capsule (`CNTabBar`) with native SF Symbols (`house`, `list.bullet.rectangle`, `chart.pie`, `sparkles`, `creditcard`); iOS < 26 or Reduce Transparency renders solid `CupertinoTabBar`.
   - `AdaptiveTopBar`: Collapsing / pinned glass top bar on iOS allowing scrollable content to pass underneath; solid Material header on Android.
   - `AdaptiveSheet`: iOS renders translucent glass bottom sheet with grabber and detents; Android renders Material 3 sheet with radius 28.
   - `AdaptiveDialog`: iOS renders centered Liquid Glass card; Android renders Material dialog.
   - `AdaptiveAddButton`: iOS renders 20% primary-tinted glass circular "+" button floating above the tab bar; Android renders extended FAB "Add Expense".
   - `AdaptiveSwitch` & `AdaptiveSegmented`: iOS renders `CupertinoSwitch` with primary tint and `CupertinoSlidingSegmentedControl`; Android renders Material `Switch` and segmented button chips.
   - `AdaptivePage`: Provides native iOS swipe-back interactive gesture (`CupertinoPageRoute`) on iOS and standard `MaterialPageRoute` on Android.
   - `AdaptiveHaptics`: Triggers `HapticFeedback.lightImpact()` on tab switches, keypad keypresses, and Save actions on iOS.
2. **Glass Tokens (`AppThemeExtension`)**:
   - Added `glassTint` (55% light / 45% dark surface), `primaryGlassTint` (20% primary), `glassBlurSigma` (20.0), `glassBorderColor` (35% white light / 15% white dark), and `glassShadow`.
3. **Screen Parity & Isolation**:
   - Screens (`DashboardScreen`, `CardsScreen`, `InsightsScreen`, `ExpensesScreen`, `BudgetsScreen`, `AddExpenseScreen`, `SettingsScreen`) contain **zero platform checks**. All platform adaptations are encapsulated inside `core/adaptive/`.

### Why a Provider (`PlatformInfo`) makes platform behavior testable
- **Problem with `Platform.isIOS`**: Hardcoded checks like `Platform.isIOS` or `Theme.of(context).platform` in widget trees cannot be altered dynamically in widget tests running on a development Mac/Linux machine without manipulating global engine overrides that leak across test suites.
- **The Riverpod Solution**: By wrapping platform identification into an immutable `PlatformInfo` class exposed via `platformInfoProvider`:
  ```dart
  final platformInfoProvider = NotifierProvider<PlatformInfoNotifier, PlatformInfo>(...);
  ```
  Any widget test can effortlessly simulate Android, iOS 26, iOS 17, or accessibility modes simply by supplying an override in `ProviderScope`:
  ```dart
  ProviderScope(
    overrides: [
      platformInfoProvider.overrideWith(() => _StaticPlatformInfoNotifier(
        const PlatformInfo(isIOS: true, iosMajorVersion: 26, reduceTransparency: true),
      )),
    ],
    child: ...
  )
  ```
  This makes 100% of our cross-platform and accessibility branches unit- and widget-testable in automated CI pipelines.

### `ref.watch` for Reacting to Accessibility Changes
- In iOS, users can toggle **Settings → Accessibility → Display & Text Size → Reduce Transparency** at any time while the app is in the background or split-screen.
- Our `PlatformInfoNotifier` registers an observer on `WidgetsBinding.instance.platformDispatcher`:
  ```dart
  @override
  void didChangeAccessibilityFeatures() {
    final updated = binding.platformDispatcher.accessibilityFeatures.highContrast;
    state = state.copyWith(reduceTransparency: updated);
  }
  ```
- Because every adaptive component (`GlassSurface`, `AdaptiveTabScaffold`, `AdaptiveAddButton`, `AdaptiveTopBar`, `AdaptiveSheet`, `AdaptiveDialog`) watches the provider using `ref.watch(platformInfoProvider)`, any change to the system accessibility setting immediately and synchronously rebuilds all glass surfaces into solid `surfaceContainer` surfaces without requiring an application restart.

### Apple HIG Glass Compliance Rules
- **Glass ONLY on navigation and control layers**: Tab bars, top bars, modal sheets, dialogs, floating action buttons, and segmented pickers.
- **Content stays SOLID**: All cards, expense tiles, category breakdowns, and keypad buttons remain opaque and crisp for readability and 4.5:1 contrast compliance.
- **Scroll Underneath**: Content scrolls under translucent bars using `extendBody: true` on scaffolds and floating headers, allowing the blur to be appreciated as elements pass underneath.

