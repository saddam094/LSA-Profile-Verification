import 'dart:async';

class FrictionTracker {
  FrictionTracker({
    required this.threshold,
    required this.onFriction,
  });

  final Duration threshold;
  final void Function(Duration duration) onFriction;

  Timer? _timer;
  DateTime? _startedAt;
  bool _eventReported = false;

  void userInteracted() {
    _timer?.cancel();
    _startedAt = DateTime.now();
    _eventReported = false;

    _timer = Timer(threshold, () {
      if (_startedAt == null || _eventReported) return;

      _eventReported = true;
      final duration = DateTime.now().difference(_startedAt!);
      onFriction(duration);
    });
  }

  void dispose() {
    _timer?.cancel();
  }
}
