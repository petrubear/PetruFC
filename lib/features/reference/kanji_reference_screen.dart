import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/l10n/group_names.dart';
import '../../core/l10n/language.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/mastery.dart';
import '../../core/widgets/ui_kit.dart';
import 'kanji_detail_sheet.dart';

final _kanjiProvider = FutureProvider.family<List<(ItemGroup, List<Item>)>, String>((ref, moduleId) async {
  final repo = ref.read(repoProvider);
  final groups = await repo.groups(moduleId, 'kanji');
  final items = await repo.items(moduleId, groups.map((g) => g.id));
  return [
    for (final g in groups) (g, [for (final i in items) if (i.groupId == g.id) i]),
  ];
});

class KanjiReferenceScreen extends ConsumerWidget {
  const KanjiReferenceScreen({super.key, required this.moduleId});
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final data = ref.watch(_kanjiProvider(moduleId));
    final stats = ref.watch(statsProvider).valueOrNull ?? {};
    final pad = expanded ? 40.0 : 24.0;
    return Scaffold(
      body: SafeArea(
        child: data.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (sections) {
            final all = sections.expand((s) => s.$2).toList();
            final mastered = all.where((i) => Mastery.of(stats[i.id]) == Mastery.mastered).length;
            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(pad, expanded ? 24 : 12, pad, 0),
                  sliver: SliverList.list(children: [
                    Row(children: [
                      RoundIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          label: context.l10n.back,
                          size: expanded ? 48 : 44,
                          onTap: () => context.pop()),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(context.l10n.referenceTitle,
                                style: TextStyle(
                                    fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700)),
                            Text(context.l10n.referenceCounts(all.length, mastered),
                                style: TextStyle(fontSize: 14, color: context.pt.subtext)),
                          ],
                        ),
                      ),
                    ]),
                    const SizedBox(height: 14),
                    const MasteryLegend(),
                  ]),
                ),
                for (final (group, items) in sections) ...[
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(pad, 24, pad, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(children: [
                        Text(groupName(context.l10n, group),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                        const SizedBox(width: 10),
                        Text('${items.length}',
                            style: TextStyle(fontSize: 14, color: context.pt.subtext)),
                      ]),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(pad, 0, pad, 32),
                    sliver: SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: expanded ? 104 : 84,
                        mainAxisExtent: expanded ? 96 : 84,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (_, i) => _KanjiTile(items[i], stats[items[i].id]),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _KanjiTile extends StatelessWidget {
  const _KanjiTile(this.item, this.stat);
  final Item item;
  final ReviewStat? stat;

  @override
  Widget build(BuildContext context) {
    final m = Mastery.of(stat);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.pt.shape.small),
      side: BorderSide(color: m.borderOf(context.pt)),
    );
    return Semantics(
      button: true,
      label: '${item.japanese} ${item.meaning(context.lang) ?? ''}',
      child: Material(
        color: m.bgOf(context.pt),
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: () => showKanjiDetail(context, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.japanese,
                    style: const TextStyle(
                        fontFamily: Pt.kana, fontWeight: FontWeight.w700, fontSize: 30, height: 1.1)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(item.meaning(context.lang) ?? '',
                      maxLines: 1, style: TextStyle(fontSize: 11, color: context.pt.subtext)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
