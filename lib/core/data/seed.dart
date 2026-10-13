import 'package:drift/drift.dart';

import 'database.dart';

const _basic =
    'あ:a い:i う:u え:e お:o か:ka き:ki く:ku け:ke こ:ko さ:sa し:shi す:su せ:se そ:so '
    'た:ta ち:chi つ:tsu て:te と:to な:na に:ni ぬ:nu ね:ne の:no は:ha ひ:hi ふ:fu へ:he ほ:ho '
    'ま:ma み:mi む:mu め:me も:mo や:ya ゆ:yu よ:yo ら:ra り:ri る:ru れ:re ろ:ro わ:wa を:wo ん:n';

const _dakuten =
    'が:ga ぎ:gi ぐ:gu げ:ge ご:go ざ:za じ:ji ず:zu ぜ:ze ぞ:zo だ:da ぢ:di づ:du で:de ど:do '
    'ば:ba び:bi ぶ:bu べ:be ぼ:bo ぱ:pa ぴ:pi ぷ:pu ぺ:pe ぽ:po';

const _combined =
    'きゃ:kya きゅ:kyu きょ:kyo しゃ:sha しゅ:shu しょ:sho ちゃ:cha ちゅ:chu ちょ:cho '
    'にゃ:nya にゅ:nyu にょ:nyo ひゃ:hya ひゅ:hyu ひょ:hyo みゃ:mya みゅ:myu みょ:myo '
    'りゃ:rya りゅ:ryu りょ:ryo ぎゃ:gya ぎゅ:gyu ぎょ:gyo じゃ:ja じゅ:ju じょ:jo '
    'びゃ:bya びゅ:byu びょ:byo ぴゃ:pya ぴゅ:pyu ぴょ:pyo';

// japones:romaji:espanol (partes del cuerpo, del cabello a los pies)
const _body = 'かみ:kami:Cabello あたま:atama:Cabeza かお:kao:Cara ひたい:hitai:Frente '
    'まゆげ:mayuge:Ceja め:me:Ojo みみ:mimi:Oreja はな:hana:Nariz ほお:hoo:Mejilla '
    'くち:kuchi:Boca くちびる:kuchibiru:Labio は:ha:Diente した:shita:Lengua '
    'あご:ago:Mentón くび:kubi:Cuello のど:nodo:Garganta かた:kata:Hombro '
    'うで:ude:Brazo ひじ:hiji:Codo て:te:Mano ゆび:yubi:Dedo つめ:tsume:Uña '
    'むね:mune:Pecho せなか:senaka:Espalda おなか:onaka:Barriga こし:koshi:Cintura '
    'あし:ashi:Pierna o pie ひざ:hiza:Rodilla かかと:kakato:Talón '
    'つまさき:tsumasaki:Punta del pie';

List<ItemsCompanion> _kana(String group, String data) => [
      for (final p in data.split(' '))
        ItemsCompanion.insert(
          moduleId: 'hiragana',
          groupId: group,
          kind: 'kana',
          japanese: p.split(':')[0],
          reading: p.split(':')[1],
        ),
    ];

// El espanol puede tener espacios ("Pierna o pie"): cada entrada termina donde
// empieza la siguiente (japones:romaji:).
List<ItemsCompanion> _words(String data) {
  final entries =
      RegExp(r'([^\s:]+):([a-z]+):(.+?)(?=\s[^\s:]+:[a-z]+:|$)').allMatches(data);
  return [
    for (final m in entries)
      ItemsCompanion.insert(
        moduleId: 'hiragana',
        groupId: 'hiragana_body',
        kind: 'word',
        japanese: m.group(1)!,
        reading: m.group(2)!,
        meaningEs: Value(m.group(3)),
      ),
  ];
}

Future<void> seedDatabase(AppDatabase db) async {
  final kana = [
    ..._kana('hiragana_basic', _basic),
    ..._kana('hiragana_dakuten', _dakuten),
    ..._kana('hiragana_combined', _combined),
  ];
  assert(
    kana.map((c) => c.reading.value).toSet().length == kana.length,
    'reading duplicado en los kana',
  );
  final words = _words(_body);
  assert(words.length == 30, 'se esperaban 30 palabras, hay ${words.length}');

  await db.batch((b) {
    b.insertAll(db.modules, [
      ModulesCompanion.insert(
          id: 'hiragana', name: 'Hiragana', glyph: 'あ', sortOrder: 0, enabled: true),
      ModulesCompanion.insert(
          id: 'katakana', name: 'Katakana', glyph: 'ア', sortOrder: 1, enabled: false),
      ModulesCompanion.insert(
          id: 'kanji', name: 'Kanji', glyph: '字', sortOrder: 2, enabled: false),
    ]);
    b.insertAll(db.itemGroups, [
      ItemGroupsCompanion.insert(
          id: 'hiragana_basic',
          moduleId: 'hiragana',
          kind: 'kana',
          name: 'Básicos',
          subtitle: '46 caracteres · あ い う え お',
          sortOrder: 0),
      ItemGroupsCompanion.insert(
          id: 'hiragana_dakuten',
          moduleId: 'hiragana',
          kind: 'kana',
          name: 'Dakuten y handakuten',
          subtitle: '25 caracteres · が ざ ぱ',
          sortOrder: 1),
      ItemGroupsCompanion.insert(
          id: 'hiragana_combined',
          moduleId: 'hiragana',
          kind: 'kana',
          name: 'Combinados',
          subtitle: '33 caracteres · きゃ しゅ ちょ',
          sortOrder: 2),
      ItemGroupsCompanion.insert(
          id: 'hiragana_body',
          moduleId: 'hiragana',
          kind: 'word',
          name: 'Cuerpo',
          subtitle: '30 palabras',
          sortOrder: 3),
    ]);
    b.insertAll(db.items, [...kana, ...words]);
    b.insert(
        db.settings,
        SettingsCompanion.insert(
            key: 'active_groups:hiragana', value: 'hiragana_basic'));
  });
}
