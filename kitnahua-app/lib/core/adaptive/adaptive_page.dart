import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'platform_info.dart';

/// An adaptive page that provides:
/// - iOS: [CupertinoPageRoute] with interactive swipe-back gesture.
/// - Android: Standard [MaterialPageRoute].
class AdaptivePage<T> extends Page<T> {
  const AdaptivePage({
    required this.child,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    if (isIOS) {
      return CupertinoPageRoute<T>(settings: this, builder: (context) => child);
    }
    return MaterialPageRoute<T>(settings: this, builder: (context) => child);
  }
}

/// Helper function to create an [AdaptivePage].
Page<T> buildAdaptivePage<T>({
  required Widget child,
  PlatformInfo? platformInfo,
  LocalKey? key,
  String? name,
}) {
  return AdaptivePage<T>(key: key, name: name, child: child);
}
