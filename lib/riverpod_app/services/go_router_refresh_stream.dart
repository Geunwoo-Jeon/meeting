import 'dart:async';
import 'package:flutter/foundation.dart';

/// A ChangeNotifier that listens to a Stream and notified GoRouter to refresh routing.
///
/// This is useful when using [GoRouter]'s `refeshListenable` parameter
/// to trigger redirection or rebuilding based on external stream changes.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
