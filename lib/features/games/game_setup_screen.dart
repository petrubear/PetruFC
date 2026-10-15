import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../quiz/mode_setup_screen.dart';

const _titles = {
  'memory': 'Memorama',
  'build': 'Arma la palabra',
  'wordsearch': 'Sopa de letras',
};

/// "¿Que quieres practicar?": caracteres (los sets activos del modulo) o una
/// seccion de vocabulario. Se recuerda la ultima eleccion de cada modulo.
class GameSetupScreen extends ConsumerStatefulWidget {
  const GameSetupScreen({super.key, required this.moduleId, required this.game});
  final String moduleId, game;

  @override
  ConsumerState<GameSetupScreen> createState() => _GameSetupState();
}

class _GameSetupState extends ConsumerState<GameSetupScreen> {
  String _kind = 'kana';
  String? _group;

  String get _kindKey => 'games_kind:${widget.moduleId}';
  String get _groupKey => 'games_word:${widget.moduleId}';

  @override
  void initState() {
    super.initState();
    ref.read(repoProvider).allSettings().then((m) {
      if (!mounted) return;
      setState(() {
        _kind = m[_kindKey] == 'word' ? 'word' : 'kana';
        _group = m[_groupKey];
      });
    });
  }

  void _setKind(String v) {
    setState(() => _kind = v);
    ref.read(repoProvider).saveSetting(_kindKey, v);
  }

  void _setGroup(String v) {
    setState(() => _group = v);
    ref.read(repoProvider).saveSetting(_groupKey, v);
  }

  @override
  Widget build(BuildContext context) {
    final expanded = isExpanded(context);
    final supportsKana = widget.game == 'memory';
    final kind = supportsKana ? _kind : 'word';
    final groups = ref.watch(groupsProvider((widget.moduleId, 'word'))).valueOrNull ?? <ItemGroup>[];
    final group = groups.any((g) => g.id == _group) ? _group : groups.firstOrNull?.id;

    Widget kindButton(String id, String label) => Expanded(
          child: PillButton(label,
              onTap: () => _setKind(id),
              bg: kind == id ? Pt.flamingo : Pt.surface0,
              fg: kind == id ? Pt.crust : Pt.text,
              border: kind == id ? null : Pt.surface1),
        );

    void play() {
      final m = widget.moduleId;
      if (widget.game == 'wordsearch') {
        context.push('/m/$m/vocabulary/$group/wordsearch');
      } else {
        context.push('/m/$m/games/${widget.game}/play?kind=$kind${kind == 'word' ? '&group=$group' : ''}');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: EdgeInsets.fromLTRB(expanded ? 40 : 24, 12, expanded ? 40 : 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      label: 'Volver',
                      size: expanded ? 48 : 44,
                      onTap: () => context.pop()),
                  const SizedBox(height: 22),
                  Text(_titles[widget.game] ?? '',
                      style: TextStyle(fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        if (supportsKana) ...[
                          Row(children: [
                            kindButton('kana', 'Caracteres'),
                            const SizedBox(width: 12),
                            kindButton('word', 'Vocabulario'),
                          ]),
                          const SizedBox(height: 20),
                        ],
                        if (kind == 'kana')
                          SetList(widget.moduleId, showMultiSelect: false)
                        else ...[
                          const SectionLabel('SECCIÓN'),
                          const SizedBox(height: 12),
                          for (final g in groups) ...[
                            _SectionTile(g, selected: g.id == group, onTap: () => _setGroup(g.id)),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: PillButton('Jugar', onTap: kind == 'word' && group == null ? null : play),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile(this.g, {required this.selected, required this.onTap});
  final ItemGroup g;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Pt.surface1 : Pt.surface0,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: selected ? Pt.flamingo : Pt.surface1, width: selected ? 2 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    Text(g.subtitle, style: const TextStyle(fontSize: 13, color: Pt.subtext)),
                  ],
                ),
              ),
              Icon(selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: selected ? Pt.flamingo : Pt.subtext),
            ],
          ),
        ),
      );
}
