import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/home/module_menu.dart';
import '../features/practice/practice_screen.dart';
import '../features/quiz/mode_setup_screen.dart';
import '../features/quiz/quiz_engine.dart';
import '../features/quiz/quiz_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => const HomeScreen(),
      routes: [
        GoRoute(
          path: 'm/:module',
          builder: (c, s) => ModuleMenuScreen(moduleId: s.pathParameters['module']!),
          routes: [
            GoRoute(
              path: 'flashcards',
              builder: (c, s) => ModeSetupScreen(
                  moduleId: s.pathParameters['module']!, kind: 'kana'),
            ),
            GoRoute(
              path: 'vocabulary',
              builder: (c, s) => ModeSetupScreen(
                  moduleId: s.pathParameters['module']!, kind: 'word'),
            ),
            GoRoute(
              path: 'play/:mode',
              builder: (c, s) => QuizScreen(
                moduleId: s.pathParameters['module']!,
                mode: QuizMode.values.byName(s.pathParameters['mode']!),
              ),
            ),
            GoRoute(
              path: 'practice',
              builder: (c, s) =>
                  PracticeScreen(moduleId: s.pathParameters['module']!),
            ),
          ],
        ),
      ],
    ),
  ],
);
