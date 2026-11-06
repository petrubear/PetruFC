import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/activity/activity_tracker.dart';
import '../core/feedback/feedback.dart';
import '../core/widgets/mascot.dart';
import 'router.dart';
import 'theme.dart';
import '../core/l10n/language.dart';

class PetruApp extends ConsumerWidget {
  const PetruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracker = ref.watch(activityTrackerProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: resolveAppLocale,
      themeMode: ThemeMode.system,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
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
