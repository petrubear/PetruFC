import 'package:go_router/go_router.dart';

import '../features/games/build_word_game.dart';
import '../features/games/game_common.dart';
import '../features/games/game_setup_screen.dart';
import '../features/games/games_menu.dart';
import '../features/games/memory_game.dart';
import '../features/home/home_screen.dart';
import '../features/home/module_menu.dart';
import '../features/learn/learn_screen.dart';
import '../features/practice/practice_screen.dart';
import '../features/quiz/mode_setup_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/quiz/quiz_engine.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/reference/reference_screen.dart';
import '../features/vocabulary/vocab_menus.dart';
import '../features/vocabulary/vocab_reference_screen.dart';
import '../features/vocabulary/word_search_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (c, s) => const HomeScreen(),
      routes: [
        GoRoute(path: 'settings', builder: (c, s) => const SettingsScreen()),
        GoRoute(
          path: 'm/:module',
          builder: (c, s) =>
              ModuleMenuScreen(moduleId: s.pathParameters['module']!),
          routes: [
            GoRoute(
              path: 'flashcards',
              builder: (c, s) => ModeSetupScreen(
                moduleId: s.pathParameters['module']!,
                kind: 'kana',
              ),
            ),
            GoRoute(
              path: 'vocabulary',
              builder: (c, s) =>
                  VocabSectionsScreen(moduleId: s.pathParameters['module']!),
              routes: [
                GoRoute(
                  path: ':group',
                  builder: (c, s) => VocabSectionMenuScreen(
                    moduleId: s.pathParameters['module']!,
                    groupId: s.pathParameters['group']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'reference',
                      builder: (c, s) => VocabReferenceScreen(
                        moduleId: s.pathParameters['module']!,
                        groupId: s.pathParameters['group']!,
                      ),
                    ),
                    GoRoute(
                      path: 'wordsearch',
                      builder: (c, s) => WordSearchScreen(
                        moduleId: s.pathParameters['module']!,
                        groupId: s.pathParameters['group']!,
                      ),
                    ),
                    GoRoute(
                      path: 'practice',
                      builder: (c, s) => ModeSetupScreen(
                        moduleId: s.pathParameters['module']!,
                        kind: 'word',
                        groupId: s.pathParameters['group']!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'play/:mode',
              builder: (c, s) => QuizScreen(
                moduleId: s.pathParameters['module']!,
                mode: QuizMode.values.byName(s.pathParameters['mode']!),
                groupId: s.uri.queryParameters['group'],
              ),
            ),
            GoRoute(
              path: 'games',
              builder: (c, s) =>
                  GamesMenuScreen(moduleId: s.pathParameters['module']!),
              routes: [
                GoRoute(
                  path: ':game',
                  builder: (c, s) => GameSetupScreen(
                    moduleId: s.pathParameters['module']!,
                    game: s.pathParameters['game']!,
                  ),
                  routes: [
                    GoRoute(
                      path: 'play',
                      builder: (c, s) {
                        final GameArgs args = (
                          s.pathParameters['module']!,
                          s.uri.queryParameters['kind'] ?? 'kana',
                          s.uri.queryParameters['group'],
                        );
                        return s.pathParameters['game'] == 'build'
                            ? BuildWordScreen(args: args)
                            : MemoryScreen(args: args);
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: 'reference',
              builder: (c, s) =>
                  ReferenceScreen(moduleId: s.pathParameters['module']!),
            ),
            GoRoute(
              path: 'learn',
              builder: (c, s) =>
                  LearnScreen(moduleId: s.pathParameters['module']!),
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
