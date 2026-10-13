import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/audio/tts_service.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';

// Posicion de cada kana en la tabla, por romaji (null = hueco).
class _Section {
  const _Section(this.title, this.cols, this.labels, this.rows);
  final String title;
  final List<String> cols;
  final List<String> labels;
  final List<List<String?>> rows;
  int get count => rows.expand((r) => r).whereType<String>().length;
}

const _vowels = ['a', 'i', 'u', 'e', 'o'];
const _ya = ['ya', 'yu', 'yo'];

const _basic = _Section('Básicos', _vowels, [
  '', 'k', 's', 't', 'n', 'h', 'm', 'y', 'r', 'w', 'n'
], [
  ['a', 'i', 'u', 'e', 'o'],
  ['ka', 'ki', 'ku', 'ke', 'ko'],
  ['sa', 'shi', 'su', 'se', 'so'],
  ['ta', 'chi', 'tsu', 'te', 'to'],
  ['na', 'ni', 'nu', 'ne', 'no'],
  ['ha', 'hi', 'fu', 'he', 'ho'],
  ['ma', 'mi', 'mu', 'me', 'mo'],
  ['ya', null, 'yu', null, 'yo'],
  ['ra', 'ri', 'ru', 're', 'ro'],
  ['wa', null, null, null, 'wo'],
  ['n', null, null, null, null],
]);

const _dakuten = _Section('Dakuten y handakuten', _vowels, [
  'g', 'z', 'd', 'b', 'p'
], [
  ['ga', 'gi', 'gu', 'ge', 'go'],
  ['za', 'ji', 'zu', 'ze', 'zo'],
  ['da', 'di', 'du', 'de', 'do'],
  ['ba', 'bi', 'bu', 'be', 'bo'],
  ['pa', 'pi', 'pu', 'pe', 'po'],
]);

const _combined = _Section('Combinados', _ya, [
  'ky', 'sh', 'ch', 'ny', 'hy', 'my', 'ry', 'gy', 'j', 'by', 'py'
], [
  ['kya', 'kyu', 'kyo'],
  ['sha', 'shu', 'sho'],
  ['cha', 'chu', 'cho'],
  ['nya', 'nyu', 'nyo'],
  ['hya', 'hyu', 'hyo'],
  ['mya', 'myu', 'myo'],
  ['rya', 'ryu', 'ryo'],
  ['gya', 'gyu', 'gyo'],
  ['ja', 'ju', 'jo'],
  ['bya', 'byu', 'byo'],
  ['pya', 'pyu', 'pyo'],
]);

final _byReadingProvider =
    FutureProvider.family<Map<String, Item>, String>((ref, moduleId) async {
  final repo = ref.read(repoProvider);
  final ids = (await repo.groups(moduleId, 'kana')).map((g) => g.id);
  return {for (final i in await repo.items(moduleId, ids)) i.reading: i};
});

class ReferenceScreen extends ConsumerWidget {
  const ReferenceScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final items = ref.watch(_byReadingProvider(moduleId));
    final back = RoundIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        label: 'Volver',
        size: expanded ? 48 : 44,
        onTap: () => context.pop());
    final heading = Text('Referencia',
        style: TextStyle(fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700));
    final total = _basic.count + _dakuten.count + _combined.count;
    final subtitle = Text('$total caracteres · toca uno para escucharlo',
        style: const TextStyle(fontSize: 14, color: Pt.subtext));

    return Scaffold(
      body: SafeArea(
        child: items.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (map) {
            Widget table(_Section s) => _Table(s, map, expanded: expanded);
            if (expanded) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(40, 24, 40, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      back,
                      const SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [heading, subtitle],
                      ),
                    ]),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: 40),
                                  child: table(_basic))),
                          const SizedBox(width: 32),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Column(children: [
                                table(_dakuten),
                                const SizedBox(height: 28),
                                table(_combined),
                              ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              children: [
                Align(alignment: Alignment.centerLeft, child: back),
                const SizedBox(height: 20),
                heading,
                const SizedBox(height: 4),
                subtitle,
                const SizedBox(height: 24),
                table(_basic),
                const SizedBox(height: 28),
                table(_dakuten),
                const SizedBox(height: 28),
                table(_combined),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Table extends StatelessWidget {
  const _Table(this.section, this.items, {required this.expanded});
  final _Section section;
  final Map<String, Item> items;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    const gap = 6.0;
    final cellH = expanded ? 76.0 : 64.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(section.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(width: 10),
            Text('${section.count}',
                style: const TextStyle(fontSize: 14, color: Pt.subtext)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(width: 30),
            for (final c in section.cols)
              Expanded(
                child: Center(
                  child: Text(c,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                          color: Pt.flamingo)),
                ),
              ),
          ],
        ),
        const SizedBox(height: gap),
        for (var r = 0; r < section.rows.length; r++)
          Padding(
            padding: const EdgeInsets.only(bottom: gap),
            child: SizedBox(
              height: cellH,
              child: Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(section.labels[r],
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            color: Pt.flamingo)),
                  ),
                  for (var c = 0; c < section.cols.length; c++) ...[
                    if (c > 0) const SizedBox(width: gap),
                    Expanded(child: _cell(section.rows[r][c])),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _cell(String? reading) {
    final item = reading == null ? null : items[reading];
    if (item == null) return const SizedBox();
    return _KanaCell(item);
  }
}

class _KanaCell extends ConsumerWidget {
  const _KanaCell(this.item);
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        color: Pt.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Pt.surface1),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          onTap: () async {
            final error =
                await ref.read(ttsProvider).speak(item.audioText ?? item.japanese);
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(item.japanese,
                  style: const TextStyle(
                      fontFamily: Pt.kana,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      height: 1.1)),
              Text(item.reading,
                  style: const TextStyle(fontSize: 11, color: Pt.subtext)),
            ],
          ),
        ),
      );
}
