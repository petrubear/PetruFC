import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/activity/activity_tracker.dart';
import '../core/feedback/feedback.dart';
import 'router.dart';
import 'theme.dart';

class PetruApp extends ConsumerWidget {
  const PetruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(activityTrackerProvider);
    return MaterialApp.router(
      title: 'Petru FC',
      theme: buildTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => tracker.touch(),
        onPointerMove: (_) => tracker.touch(),
        child: Stack(fit: StackFit.expand, children: [
          if (child != null) child,
          const GoalCelebrationOverlay(),
        ]),
      ),
    );
  }
}
