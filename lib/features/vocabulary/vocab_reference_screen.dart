import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/audio/tts_service.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';

final _wordsProvider = FutureProvider.family<List<Item>, (String, String)>(
    (ref, k) => ref.read(repoProvider).items(k.$1, [k.$2]));

class VocabReferenceScreen extends ConsumerWidget {
  const VocabReferenceScreen({super.key, required this.moduleId, required this.groupId});
  final String moduleId, groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = isExpanded(context);
    final words = ref.watch(_wordsProvider((moduleId, groupId)));
    final groups = ref.watch(groupsProvider((moduleId, 'word'))).valueOrNull ?? [];
    final name = groups.where((g) => g.id == groupId).firstOrNull?.name ?? '';
    final back = RoundIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        label: 'Volver',
        size: expanded ? 48 : 44,
        onTap: () => context.pop());
    return Scaffold(
      body: SafeArea(
        child: words.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) {
            final heading = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Referencia · $name',
                    style: TextStyle(
                        fontSize: expanded ? 32 : 26, fontWeight: FontWeight.w700)),
                Text('${list.length} palabras · toca una para escucharla',
                    style: const TextStyle(fontSize: 14, color: Pt.subtext)),
              ],
            );
            final top = Row(children: [
              back,
              const SizedBox(width: 18),
              Expanded(child: heading),
            ]);
            final pad = expanded ? 40.0 : 24.0;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(pad, expanded ? 24 : 12, pad, 20),
                  child: top,
                ),
                Expanded(
                  child: expanded
                      ? GridView.builder(
                          padding: EdgeInsets.fromLTRB(pad, 0, pad, 40),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 88,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 14,
                          ),
                          itemCount: list.length,
                          itemBuilder: (_, i) => _WordRow(list[i]),
                        )
                      : ListView.separated(
                          padding: EdgeInsets.fromLTRB(pad, 0, pad, 32),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) => SizedBox(height: 76, child: _WordRow(list[i])),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _WordRow extends ConsumerWidget {
  const _WordRow(this.item);
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        color: Pt.surface0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Pt.surface1),
        ),
        child: InkWell(
          customBorder:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          onTap: () async {
            final error =
                await ref.read(ttsProvider).speak(item.audioText ?? item.japanese);
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(item.japanese,
                        style: const TextStyle(
                            fontFamily: Pt.kana,
                            fontWeight: FontWeight.w700,
                            fontSize: 34)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
                  child: Text(item.meaningEs ?? '',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
                const Icon(Icons.volume_up_rounded, color: Pt.subtext, size: 22),
              ],
            ),
          ),
        ),
      );
}
