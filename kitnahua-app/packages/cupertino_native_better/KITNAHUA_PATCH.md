# Local patch to cupertino_native_better 1.6.0

Upstream: https://pub.dev/packages/cupertino_native_better (MIT, see LICENSE).
Vendored because 1.6.0 (latest) always changes the tab selection without
animation when the index comes from Flutter, so the iOS 26 Liquid Glass pill
jumps instead of morphing.

Changes (search for `[kitnahua patch]`):
- `lib/components/tab_bar.dart`: new `CNTabBar.animateSelectionChanges`
  (default `false`); user-driven `currentIndex` changes send
  `setSelectedIndex` with `animated`.
- `ios/.../Views/CupertinoTabBarPlatformView.swift`: `setSelectedIndex`
  skips `UIView.performWithoutAnimation` when `animated` is true.

Internal resyncs (post-create settle, modal recreate) still pass no flag and
keep the original no-animation behaviour.

To upgrade: replace this folder with the new release and re-apply the two
changes, or drop the patch if upstream adds animated selection.
