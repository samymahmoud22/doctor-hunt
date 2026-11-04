import 'dart:async';
import 'package:flutter/foundation.dart';

/// A lightweight, reusable debouncer utility.
///
/// Delays execution of an action until a specified [delay] has passed
/// without any new calls. If a new action is requested before the
/// duration elapses, the previous timer is cancelled and restarted.
class Debouncer {
  /// The duration to wait before executing the scheduled callback.
  final Duration delay;

  Timer? _timer;

  /// Creates a [Debouncer] with the specified [delay] (defaults to 300ms).
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Schedules [action] to run after [delay].
  /// Cancels any currently pending action.
  void run(VoidCallback action) {
    cancel();
    _timer = Timer(delay, () {
      _timer = null;
      action();
    });
  }

  /// Callable shortcut for [run].
  void call(VoidCallback action) => run(action);

  /// Cancels any currently pending action.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Whether an action is currently pending execution.
  bool get isRunning => _timer?.isActive ?? false;

  /// Alias for [isRunning].
  bool get isActive => isRunning;

  /// Cleans up any resources held by the debouncer.
  void dispose() {
    cancel();
  }
}

