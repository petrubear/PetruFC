import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/activity/activity_tracker.dart';
import '../core/feedback/feedback.dart';
import '../core/widgets/mascot.dart';
import '../core/data/app_settings.dart';
import 'router.dart';
import 'style.dart';
import 'study_observer.dart';
import 'theme.dart';
import '../core/l10n/language.dart';

class PetruApp extends ConsumerWidget {
  const PetruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(activityTrackerProvider);
    final style = AppStyle.fromId(
        ref.watch(settingsProvider.select((s) => s.valueOrNull?.styleId)));
    StudyObserver.currentUri = () {
      final last = router.routerDelegate.currentConfiguration.last;
      return last is ImperativeRouteMatch
          ? last.matches.uri.toString()
          : router.routerDelegate.currentConfiguration.uri.toString();
    };
    StudyObserver.onVisit = (uri) => ref.read(settingsProvider.notifier).setLastRoute(uri);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      themeMode: ThemeMode.system,
      theme: buildTheme(style, Brightness.light),
      darkTheme: buildTheme(style, Brightness.dark),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
              ),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => tracker.touch(),
          onPointerMove: (_) => tracker.touch(),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (child != null) child,
              const GoalCelebrationOverlay(),
              const MascotPrecache(),
            ],
          ),
        ),
      ),
    );
  }
}
