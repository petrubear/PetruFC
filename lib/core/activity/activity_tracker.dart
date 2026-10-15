import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../data/repository.dart';

/// Cuenta el tiempo de estudio activo: solo mientras hay una pantalla de
/// estudio abierta, la app esta en primer plano y hubo un toque en los
/// ultimos 30 segundos.
class ActivityTracker with WidgetsBindingObserver {
  ActivityTracker(this._repo) {
    WidgetsBinding.instance.addObserver(this);
  }
  final StudyRepository _repo;
  static const _idle = Duration(seconds: 30);
  int _scopes = 0, _pending = 0;
  bool _resumed = true;
  DateTime _lastTouch = DateTime.now();
  Timer? _timer;

  void touch() => _lastTouch = DateTime.now();

  void enter() {
    _scopes++;
    touch();
    _timer ??= Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void leave() {
    if (--_scopes > 0) return;
    _scopes = 0;
    _timer?.cancel();
    _timer = null;
    _flush();
  }

  void _tick() {
    if (_resumed && DateTime.now().difference(_lastTouch) < _idle) {
      if (++_pending >= 5) _flush();
    }
  }

  void _flush() {
    if (_pending == 0) return;
    final n = _pending;
    _pending = 0;
    _repo.addSeconds(dayKey(DateTime.now()), n);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _resumed = state == AppLifecycleState.resumed;
    if (!_resumed) _flush();
  }

  void dispose() {
    _timer?.cancel();
    _flush();
    WidgetsBinding.instance.removeObserver(this);
  }
}

final activityTrackerProvider = Provider<ActivityTracker>((ref) {
  final t = ActivityTracker(ref.watch(repoProvider));
  ref.onDispose(t.dispose);
  return t;
});

/// Segundos por dia de los ultimos 7 dias (clave yyyy-MM-dd).
final recentActivityProvider = StreamProvider.autoDispose<Map<String, int>>((ref) {
  final since = dayKey(DateTime.now().subtract(const Duration(days: 6)));
  return ref.watch(repoProvider).watchActivitySince(since);
});

/// Envuelve una pantalla de estudio para que su tiempo cuente en la meta diaria.
class ActivityScope extends ConsumerStatefulWidget {
  const ActivityScope({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<ActivityScope> createState() => _ActivityScopeState();
}

class _ActivityScopeState extends ConsumerState<ActivityScope> {
  late final ActivityTracker _tracker;

  @override
  void initState() {
    super.initState();
    _tracker = ref.read(activityTrackerProvider)..enter();
  }

  @override
  void dispose() {
    _tracker.leave();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
