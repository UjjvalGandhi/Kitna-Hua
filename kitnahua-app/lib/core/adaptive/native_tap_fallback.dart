import 'package:flutter/widgets.dart';

/// Native Liquid Glass controls (UiKitView) can drop very short taps — a quick
/// click or flick never reaches UIKit's gesture recognisers. This widget
/// watches raw pointers over such a control without joining the gesture arena,
/// so the native control still gets every touch (press effect, drag lens) and
/// [onTap] reports taps the native side may have missed.
///
/// Pair it with [TapDeduper] so a tap seen by both sides runs once.
class NativeTapFallback extends StatefulWidget {
  const NativeTapFallback({
    super.key,
    required this.onTap,
    required this.child,
  });

  /// Called with the local position of a completed tap (little movement).
  final ValueChanged<Offset> onTap;
  final Widget child;

  /// Movement beyond this is a drag, which the native control handles.
  static const double tapSlop = 12.0;

  @override
  State<NativeTapFallback> createState() => _NativeTapFallbackState();
}

class _NativeTapFallbackState extends State<NativeTapFallback> {
  int? _pointer;
  Offset? _downPosition;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        if (_pointer != null) return;
        _pointer = event.pointer;
        _downPosition = event.localPosition;
      },
      onPointerMove: (event) {
        if (event.pointer != _pointer || _downPosition == null) return;
        if ((event.localPosition - _downPosition!).distance >
            NativeTapFallback.tapSlop) {
          _downPosition = null; // became a drag
        }
      },
      onPointerUp: (event) {
        if (event.pointer != _pointer) return;
        final down = _downPosition;
        _pointer = null;
        _downPosition = null;
        if (down != null) widget.onTap(event.localPosition);
      },
      onPointerCancel: (event) {
        if (event.pointer != _pointer) return;
        _pointer = null;
        _downPosition = null;
      },
      child: widget.child,
    );
  }
}

/// Runs an action once when the native control and [NativeTapFallback] both
/// report the same tap within [window].
class TapDeduper {
  TapDeduper({
    this.window = const Duration(milliseconds: 500),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final Duration window;
  final DateTime Function() _now;
  Object? _lastKey;
  DateTime? _lastAt;

  /// Runs [action] unless the same [key] ran within [window].
  void run(Object key, VoidCallback action) {
    final now = _now();
    final last = _lastAt;
    if (key == _lastKey && last != null && now.difference(last) < window) {
      return;
    }
    _lastKey = key;
    _lastAt = now;
    action();
  }
}
