import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/activity/activity_tracker.dart';
import '../../core/data/app_settings.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/feedback/feedback.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import '../practice/stroke_board.dart';
import 'kana_strokes.dart';

class _LearnData {
  const _LearnData(this.items, this.start);
  final List<Item> items;
  final int start;
}

/// Los kana en el orden de la Referencia (basicos, dakuten, combinados) y donde se quedo el usuario.
final _learnDataProvider = FutureProvider.autoDispose.family<_LearnData, String>((ref, module) async {
  final repo = ref.read(repoProvider);
  final ids = ['${module}_basic', '${module}_dakuten', '${module}_combined'];
  final items = await repo.items(module, ids);
  items.sort((a, b) {
    final g = ids.indexOf(a.groupId).compareTo(ids.indexOf(b.groupId));
    return g != 0 ? g : a.id.compareTo(b.id);
  });
  final saved = int.tryParse((await repo.allSettings())['learn_index:$module'] ?? '') ?? 0;
  return _LearnData(items, saved.clamp(0, items.length - 1));
});

const _groupNames = {'basic': 'Básicos', 'dakuten': 'Dakuten y handakuten', 'combined': 'Combinados'};

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _anim = AnimationController(vsync: this);
  int? _i;
  int _strokeCount = 1;
  bool _guide = true;
  List<List<Offset>> _strokes = [];

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  void _play() {
    _anim
      ..duration = Duration(milliseconds: 650 * _strokeCount + 250)
      ..forward(from: 0);
  }

  void _go(int to, _LearnData d) {
    if (to < 0 || to >= d.items.length) return;
    buzz(ref.read(settingsProvider).valueOrNull?.haptics ?? true, Buzz.soft);
    setState(() {
      _i = to;
      _strokes = [];
    });
    ref.read(repoProvider).saveSetting('learn_index:${widget.moduleId}', '$to');
    WidgetsBinding.instance.addPostFrameCallback((_) => _play());
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(_learnDataProvider(widget.moduleId));
    final glyphs = ref.watch(kanaStrokesProvider);
    return ActivityScope(
      child: Scaffold(
        body: SafeArea(
          child: switch ((data, glyphs)) {
            (AsyncData(value: final d), AsyncData(value: final g)) => _body(d, g),
            (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
              Center(child: Text('$error')),
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
      ),
    );
  }

  Widget _body(_LearnData d, Map<String, KanaGlyph> all) {
    final first = _i == null;
    final i = _i ??= d.start;
    final item = d.items[i];
    final parts = [for (final r in item.japanese.runes) all[String.fromCharCode(r)]]
        .whereType<KanaGlyph>()
        .toList();
    _strokeCount = parts.fold(0, (n, g) => n + g.paths.length).clamp(1, 99);
    if (first) WidgetsBinding.instance.addPostFrameCallback((_) => _play());

    final expanded = isExpanded(context);
    final group = _groupNames[item.groupId.split('_').last] ?? '';
    final speak = item.audioText ?? item.japanese;

    final top = Row(
      children: [
        RoundIconButton(
          icon: Icons.close_rounded,
          label: 'Cerrar',
          size: expanded ? 48 : 44,
          onTap: () => context.pop(),
        ),
        Expanded(
          child: Text(
            'APRENDER · ${i + 1}/${d.items.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Pt.subtext,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.4,
            ),
          ),
        ),
        SizedBox(width: expanded ? 48 : 44),
      ],
    );
    final title = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(group, style: const TextStyle(fontSize: 14, color: Pt.subtext)),
            Text(
              item.reading,
              style: TextStyle(
                fontSize: expanded ? 84 : 72,
                fontWeight: FontWeight.w700,
                height: 1.05,
                color: Pt.flamingo,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        SpeakerButton(text: speak),
      ],
    );
    final board = AnimatedBuilder(
      animation: _anim,
      builder: (context, _) => Stack(
        children: [
          Positioned.fill(
            child: StrokeBoard(
              strokes: _strokes,
              underlay: GuidePainter(
                parts,
                showGuide: _guide,
                progress: _anim.isAnimating ? _anim.value * _strokeCount : null,
              ),
              onStart: (p) => setState(() => _strokes = [..._strokes, [p]]),
              onMove: (p) => setState(() => _strokes.last.add(p)),
            ),
          ),
          Positioned(
            right: 12,
            top: 12,
            child: Row(
              children: [
                RoundIconButton(
                  icon: _guide ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                  label: _guide ? 'Ocultar guía' : 'Mostrar guía',
                  size: 44,
                  onTap: () => setState(() => _guide = !_guide),
                ),
                const SizedBox(width: 8),
                RoundIconButton(
                  icon: Icons.play_arrow_rounded,
                  label: 'Ver trazos',
                  size: 44,
                  bg: Pt.flamingo,
                  fg: Pt.crust,
                  onTap: _play,
                ),
              ],
            ),
          ),
        ],
      ),
    );
    final controls = Row(
      children: [
        Expanded(
          child: PillButton(
            'Anterior',
            onTap: i == 0 ? null : () => _go(i - 1, d),
            bg: Pt.surface0,
            fg: Pt.text,
            border: Pt.surface1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PillButton(
            'Borrar',
            onTap: () => setState(() => _strokes = []),
            bg: Pt.surface0,
            fg: Pt.text,
            border: Pt.surface1,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: PillButton('Siguiente', onTap: i + 1 >= d.items.length ? null : () => _go(i + 1, d)),
        ),
      ],
    );

    if (expanded) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
        child: Column(
          children: [
            top,
            const SizedBox(height: 28),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [title, const Spacer(), controls],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(child: board),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      child: Column(
        children: [
          top,
          const SizedBox(height: 14),
          title,
          const SizedBox(height: 16),
          Expanded(child: board),
          const SizedBox(height: 18),
          controls,
        ],
      ),
    );
  }
}
