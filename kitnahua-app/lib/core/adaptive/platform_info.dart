import 'dart:io' show Platform;
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Platform detection and accessibility configuration.
///
/// Encapsulates platform identification (iOS vs Android), iOS major version
/// (e.g. 26 vs 17), and accessibility preferences (e.g. Reduce Transparency).
///
/// Designed to be fully testable and overridable via [platformInfoProvider].
@immutable
class PlatformInfo {
  const PlatformInfo({
    required this.isIOS,
    required this.iosMajorVersion,
    required this.reduceTransparency,
  });

  /// Whether the current target platform is iOS.
  final bool isIOS;

  /// The iOS major version (e.g. 26, 17). 0 on non-iOS platforms.
  final int iosMajorVersion;

  /// Whether the user has enabled "Reduce Transparency" in system settings.
  final bool reduceTransparency;

  /// Whether running on iOS 26 or later.
  bool get isIOS26OrLater => isIOS && iosMajorVersion >= 26;

  /// Whether Apple Liquid Glass effects should be active.
  ///
  /// Requires iOS 26+ and Reduce Transparency to be OFF.
  bool get useLiquidGlass => isIOS26OrLater && !reduceTransparency;

  /// Whether running on Android.
  bool get isAndroid => !isIOS;

  PlatformInfo copyWith({
    bool? isIOS,
    int? iosMajorVersion,
    bool? reduceTransparency,
  }) {
    return PlatformInfo(
      isIOS: isIOS ?? this.isIOS,
      iosMajorVersion: iosMajorVersion ?? this.iosMajorVersion,
      reduceTransparency: reduceTransparency ?? this.reduceTransparency,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformInfo &&
          runtimeType == other.runtimeType &&
          isIOS == other.isIOS &&
          iosMajorVersion == other.iosMajorVersion &&
          reduceTransparency == other.reduceTransparency;

  @override
  int get hashCode => Object.hash(isIOS, iosMajorVersion, reduceTransparency);

  @override
  String toString() =>
      'PlatformInfo(isIOS: $isIOS, iosMajorVersion: $iosMajorVersion, reduceTransparency: $reduceTransparency, useLiquidGlass: $useLiquidGlass)';
}

/// Observer to detect system accessibility changes at runtime.
class _AccessibilityObserver extends WidgetsBindingObserver {
  _AccessibilityObserver(this.onChanged);

  final VoidCallback onChanged;

  @override
  void didChangeAccessibilityFeatures() {
    onChanged();
  }
}

/// Riverpod Notifier for [PlatformInfo].
///
/// Automatically auto-detects host platform and listens to
/// accessibility feature changes in runtime. Can be overridden in tests.
class PlatformInfoNotifier extends Notifier<PlatformInfo> {
  _AccessibilityObserver? _observer;

  @override
  PlatformInfo build() {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    int iosMajor = 0;

    if (isIOS) {
      try {
        if (!kIsWeb && Platform.isIOS) {
          iosMajor = PlatformVersion.iosVersion ?? 26;
        } else {
          iosMajor = 26; // Default to modern iOS in simulator/test
        }
      } catch (_) {
        iosMajor = 26;
      }
    }

    final binding = WidgetsBinding.instance;
    final bool highContrast =
        binding.platformDispatcher.accessibilityFeatures.highContrast;

    // Register accessibility change listener
    _observer = _AccessibilityObserver(() {
      final updatedHighContrast =
          binding.platformDispatcher.accessibilityFeatures.highContrast;
      if (state.reduceTransparency != updatedHighContrast) {
        state = state.copyWith(reduceTransparency: updatedHighContrast);
      }
    });
    binding.addObserver(_observer!);

    ref.onDispose(() {
      if (_observer != null) {
        binding.removeObserver(_observer!);
        _observer = null;
      }
    });

    return PlatformInfo(
      isIOS: isIOS,
      iosMajorVersion: iosMajor,
      reduceTransparency: highContrast,
    );
  }

  /// Manually update reduceTransparency (useful for testing and toggle demo).
  void setReduceTransparency(bool value) {
    state = state.copyWith(reduceTransparency: value);
  }

  /// Manually override platform info parameters.
  void setPlatform({
    bool? isIOS,
    int? iosMajorVersion,
    bool? reduceTransparency,
  }) {
    state = state.copyWith(
      isIOS: isIOS,
      iosMajorVersion: iosMajorVersion,
      reduceTransparency: reduceTransparency,
    );
  }
}

/// Provider exposing the current [PlatformInfo].
final platformInfoProvider =
    NotifierProvider<PlatformInfoNotifier, PlatformInfo>(
      PlatformInfoNotifier.new,
    );
