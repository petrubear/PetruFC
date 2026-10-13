import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../core/data/providers.dart';
import '../../core/layout/breakpoints.dart';
import '../../core/widgets/ui_kit.dart';
import 'quiz_engine.dart';

class ModeSetupScreen extends StatelessWidget {
  const ModeSetupScreen(
      {super.key, required this.moduleId, required this.kind, this.groupId});
  final String moduleId, kind;
  final String? groupId;

  bool get _isKana => kind == 'kana';

  @override
  Widget build(BuildContext context) {
    final expanded = isExpanded(context);
    final modes = QuizMode.values.where((m) => m.kind == kind).toList();
    final title = _isKana ? 'Flashcards' : 'Práctica';
    final back = RoundIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        label: 'Volver',
        size: expanded ? 48 : 44,
        onTap: () => context.pop());
    final heading = Text(title,
        style: TextStyle(fontSize: expanded ? 38 : 32, fontWeight: FontWeight.w700));

    if (expanded) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 24, 40, 40),
            child: Column(
              children: [
                Row(children: [back, const SizedBox(width: 18), heading]),
                const SizedBox(height: 28),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isKana) ...[
                        Expanded(child: SingleChildScrollView(child: _SetList(moduleId))),
                        const SizedBox(width: 32),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionLabel('MODO'),
                            const SizedBox(height: 12),
                            for (var i = 0; i < modes.length; i++) ...[
                              Expanded(
                                  child: _ModeTile(moduleId, modes[i],
                                      groupId: groupId, primary: i == 0, tall: true)),
                              if (i < modes.length - 1) const SizedBox(height: 14),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              back,
              const SizedBox(height: 22),
              heading,
              const SizedBox(height: 22),
              if (_isKana) ...[_SetList(moduleId), const SizedBox(height: 22)],
              const SectionLabel('MODO'),
              const SizedBox(height: 12),
              for (var i = 0; i < modes.length; i++) ...[
                _ModeTile(moduleId, modes[i],
                    groupId: groupId, primary: i == 0, tall: false),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SetList extends ConsumerWidget {
  const _SetList(this.moduleId);
  final String moduleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(groupsProvider((moduleId, 'kana'))).valueOrNull ?? [];
    final active = ref.watch(activeGroupsProvider(moduleId)).valueOrNull ?? {};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel('QUÉ QUIERES PRACTICAR'),
        const SizedBox(height: 12),
        for (final g in groups) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
                color: Pt.surface0, borderRadius: BorderRadius.circular(22)),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(g.subtitle,
                          style: const TextStyle(fontSize: 13, color: Pt.subtext)),
                    ],
                  ),
                ),
                Switch(
                  value: active.contains(g.id),
                  onChanged: (_) =>
                      ref.read(activeGroupsProvider(moduleId).notifier).toggle(g.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile(this.moduleId, this.mode,
      {required this.groupId, required this.primary, required this.tall});
  final String moduleId;
  final String? groupId;
  final QuizMode mode;
  final bool primary, tall;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? Pt.crust : Pt.text;
    final badge = Text(mode.badge(moduleId),
        style: TextStyle(
            fontFamily: Pt.kana,
            fontWeight: FontWeight.w700,
            fontSize: tall ? 56 : 26,
            color: primary ? Pt.crust : Pt.flamingo));
    final label = Text(mode.label(moduleId),
        style: TextStyle(
            fontSize: tall ? 24 : 19, fontWeight: FontWeight.w700, color: fg));
    return Material(
      color: primary ? Pt.flamingo : Pt.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tall ? 32 : 26),
        side: primary ? BorderSide.none : const BorderSide(color: Pt.surface1),
      ),
      child: InkWell(
        customBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(tall ? 32 : 26)),
        onTap: () => context.push(
            '/m/$moduleId/play/${mode.name}${groupId == null ? '' : '?group=$groupId'}'),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: tall ? 28 : 22, vertical: tall ? 28 : 20),
          child: tall
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [FittedBox(fit: BoxFit.scaleDown, child: badge), label],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Flexible(child: label), badge],
                ),
        ),
      ),
    );
  }
}
