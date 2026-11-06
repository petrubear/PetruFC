import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import '../../core/audio/tts_service.dart';
import '../../core/data/database.dart';
import '../../core/data/providers.dart';
import '../../core/l10n/language.dart';
import '../../core/widgets/ui_kit.dart';

/// Detalle de un kanji: significado, lecturas on y kun, trazos y grado.
void showKanjiDetail(BuildContext context, Item item) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.pt.surface0,
    constraints: const BoxConstraints(maxWidth: 560),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(context.pt.shape.large)),
    ),
    builder: (_) => _KanjiDetailSheet(item),
  );
}

class _KanjiDetailSheet extends ConsumerWidget {
  const _KanjiDetailSheet(this.item);
  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final d = ref.watch(kanjiDetailsProvider).valueOrNull?[item.id];
    Widget readings(String title, String raw) => Padding(
          padding: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionLabel(title),
              const SizedBox(height: 6),
              Text(raw.isEmpty ? l.kanjiNoReadings : raw.replaceAll('、', '   '),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, height: 1.4)),
            ],
          ),
        );
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(item.japanese, style: context.pt.display(96, color: context.pt.flamingo)),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.meaning(context.lang) ?? '',
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      d == null
                          ? ''
                          : '${l.kanjiStrokeCount(d.strokeCount)} · ${l.kanjiGradeLabel(d.grade)}',
                      style: TextStyle(fontSize: 14, color: context.pt.subtext),
                    ),
                  ],
                ),
              ),
              RoundIconButton(
                icon: Icons.volume_up_rounded,
                label: l.kanjiListen,
                onTap: () async {
                  final error = await ref.read(ttsProvider).speak(item.audioText ?? item.japanese);
                  if (error != null && context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error.message(l))));
                  }
                },
              ),
            ],
          ),
          readings(l.kanjiOnReadings, d?.onReadings ?? ''),
          readings(l.kanjiKunReadings, d?.kunReadings ?? ''),
        ],
      ),
    );
  }
}
