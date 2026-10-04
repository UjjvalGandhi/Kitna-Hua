import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platform_info.dart';

/// Adaptive haptic feedback utilities.
///
/// Ensures haptic vibrations conform to platform guidelines:
/// - iOS: Provides light impact on tab changes, keypad presses, and save actions.
/// - Android: No-op unless explicitly configured, avoiding unwanted motor rumble.
class AdaptiveHaptics {
  const AdaptiveHaptics._();

  /// Trigger light impact haptic on iOS.
  static Future<void> lightImpact([PlatformInfo? info]) async {
    final isIOS = info?.isIOS ?? (defaultTargetPlatform == TargetPlatform.iOS);
    if (isIOS) {
      await HapticFeedback.lightImpact();
    }
  }
}
