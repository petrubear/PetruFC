import 'package:drift/drift.dart';

import 'database.dart';

const _hBasic =
    'あ:a い:i う:u え:e お:o か:ka き:ki く:ku け:ke こ:ko さ:sa し:shi す:su せ:se そ:so '
    'た:ta ち:chi つ:tsu て:te と:to な:na に:ni ぬ:nu ね:ne の:no は:ha ひ:hi ふ:fu へ:he ほ:ho '
    'ま:ma み:mi む:mu め:me も:mo や:ya ゆ:yu よ:yo ら:ra り:ri る:ru れ:re ろ:ro わ:wa を:wo ん:n';

const _hDakuten =
    'が:ga ぎ:gi ぐ:gu げ:ge ご:go ざ:za じ:ji ず:zu ぜ:ze ぞ:zo だ:da ぢ:di づ:du で:de ど:do '
    'ば:ba び:bi ぶ:bu べ:be ぼ:bo ぱ:pa ぴ:pi ぷ:pu ぺ:pe ぽ:po';

const _hCombined =
    'きゃ:kya きゅ:kyu きょ:kyo しゃ:sha しゅ:shu しょ:sho ちゃ:cha ちゅ:chu ちょ:cho '
    'にゃ:nya にゅ:nyu にょ:nyo ひゃ:hya ひゅ:hyu ひょ:hyo みゃ:mya みゅ:myu みょ:myo '
    'りゃ:rya りゅ:ryu りょ:ryo ぎゃ:gya ぎゅ:gyu ぎょ:gyo じゃ:ja じゅ:ju じょ:jo '
    'びゃ:bya びゅ:byu びょ:byo ぴゃ:pya ぴゅ:pyu ぴょ:pyo';

// japones:romaji:espanol (partes del cuerpo, del cabello a los pies)
const _hBody = 'かみ:kami:Cabello あたま:atama:Cabeza かお:kao:Cara ひたい:hitai:Frente '
    'まゆげ:mayuge:Ceja め:me:Ojo みみ:mimi:Oreja はな:hana:Nariz ほお:hoo:Mejilla '
    'くち:kuchi:Boca くちびる:kuchibiru:Labio は:ha:Diente した:shita:Lengua '
    'あご:ago:Mentón くび:kubi:Cuello のど:nodo:Garganta かた:kata:Hombro '
    'うで:ude:Brazo ひじ:hiji:Codo て:te:Mano ゆび:yubi:Dedo つめ:tsume:Uña '
    'むね:mune:Pecho せなか:senaka:Espalda おなか:onaka:Barriga こし:koshi:Cintura '
    'あし:ashi:Pierna o pie ひざ:hiza:Rodilla かかと:kakato:Talón '
    'つまさき:tsumasaki:Punta del pie';

// Organos y partes internas del cuerpo.
const _hOrgans = 'しんぞう:shinzou:Corazón のう:nou:Cerebro はい:hai:Pulmones い:i:Estómago '
    'かんぞう:kanzou:Hígado じんぞう:jinzou:Riñón ちょう:chou:Intestino '
    'しょうちょう:shouchou:Intestino delgado だいちょう:daichou:Intestino grueso '
    'しょくどう:shokudou:Esófago きかん:kikan:Tráquea ぼうこう:boukou:Vejiga '
    'たんのう:tannou:Vesícula biliar すいぞう:suizou:Páncreas ひぞう:hizou:Bazo '
    'ひふ:hifu:Piel ほね:hone:Hueso きんにく:kinniku:Músculo ち:chi:Sangre '
    'けっかん:kekkan:Vaso sanguíneo かんせつ:kansetsu:Articulación '
    'せぼね:sebone:Columna ずがいこつ:zugaikotsu:Cráneo ろっこつ:rokkotsu:Costilla '
    'しきゅう:shikyuu:Útero ぜんりつせん:zenritsusen:Próstata '
    'じょうみゃく:joumyaku:Vena どうみゃく:doumyaku:Arteria しんけい:shinkei:Nervio '
    'せきずい:sekizui:Médula espinal';

const _kBasic =
    'ア:a イ:i ウ:u エ:e オ:o カ:ka キ:ki ク:ku ケ:ke コ:ko サ:sa シ:shi ス:su セ:se ソ:so '
    'タ:ta チ:chi ツ:tsu テ:te ト:to ナ:na ニ:ni ヌ:nu ネ:ne ノ:no ハ:ha ヒ:hi フ:fu ヘ:he ホ:ho '
    'マ:ma ミ:mi ム:mu メ:me モ:mo ヤ:ya ユ:yu ヨ:yo ラ:ra リ:ri ル:ru レ:re ロ:ro ワ:wa ヲ:wo ン:n';

const _kDakuten =
    'ガ:ga ギ:gi グ:gu ゲ:ge ゴ:go ザ:za ジ:ji ズ:zu ゼ:ze ゾ:zo ダ:da ヂ:di ヅ:du デ:de ド:do '
    'バ:ba ビ:bi ブ:bu ベ:be ボ:bo パ:pa ピ:pi プ:pu ペ:pe ポ:po';

const _kCombined =
    'キャ:kya キュ:kyu キョ:kyo シャ:sha シュ:shu ショ:sho チャ:cha チュ:chu チョ:cho '
    'ニャ:nya ニュ:nyu ニョ:nyo ヒャ:hya ヒュ:hyu ヒョ:hyo ミャ:mya ミュ:myu ミョ:myo '
    'リャ:rya リュ:ryu リョ:ryo ギャ:gya ギュ:gyu ギョ:gyo ジャ:ja ジュ:ju ジョ:jo '
    'ビャ:bya ビュ:byu ビョ:byo ピャ:pya ピュ:pyu ピョ:pyo';

// Palabras de origen extranjero (solo katakana): comida y bebida.
const _kFood = 'コーヒー:koohii:Café ジュース:juusu:Jugo ミルク:miruku:Leche ビール:biiru:Cerveza '
    'ワイン:wain:Vino コーラ:koora:Cola アイス:aisu:Helado ケーキ:keeki:Pastel '
    'パン:pan:Pan バター:bataa:Mantequilla チーズ:chiizu:Queso サラダ:sarada:Ensalada '
    'スープ:suupu:Sopa ステーキ:suteeki:Bistec ハンバーガー:hanbaagaa:Hamburguesa '
    'ピザ:piza:Pizza パスタ:pasuta:Pasta カレー:karee:Curry ラーメン:raamen:Ramen '
    'サンドイッチ:sandoicchi:Sándwich ハム:hamu:Jamón ソーセージ:sooseeji:Salchicha '
    'チョコレート:chokoreeto:Chocolate クッキー:kukkii:Galleta ポテト:poteto:Papa '
    'トマト:tomato:Tomate バナナ:banana:Plátano レモン:remon:Limón メロン:meron:Melón '
    'ソース:soosu:Salsa';

List<ItemsCompanion> _kana(String module, String group, String data) => [
      for (final p in data.split(' '))
        ItemsCompanion.insert(
          moduleId: module,
          groupId: group,
          kind: 'kana',
          japanese: p.split(':')[0],
          reading: p.split(':')[1],
        ),
    ];

// El espanol puede tener espacios ("Pierna o pie"): cada entrada termina donde
// empieza la siguiente (japones:romaji:).
List<ItemsCompanion> _words(String module, String group, String data) {
  final entries =
      RegExp(r'([^\s:]+):([a-z]+):(.+?)(?=\s[^\s:]+:[a-z]+:|$)').allMatches(data);
  return [
    for (final m in entries)
      ItemsCompanion.insert(
        moduleId: module,
        groupId: group,
        kind: 'word',
        japanese: m.group(1)!,
        reading: m.group(2)!,
        meaningEs: Value(m.group(3)),
      ),
  ];
}

ItemGroupsCompanion _group(
        String module, String id, String kind, String name, String subtitle, int order) =>
    ItemGroupsCompanion.insert(
        id: id, moduleId: module, kind: kind, name: name, subtitle: subtitle, sortOrder: order);

// Cada modulo kana agrega sus grupos, items y set activo por defecto.
void _addScript(
  Batch b,
  AppDatabase db, {
  required String module,
  required String basic,
  required String dakuten,
  required String combined,
  required String words,
  required String wordsGroupName,
  required String basicExample,
  required String dakutenExample,
  required String combinedExample,
  required int wordsCount,
}) {
  final kana = [
    ..._kana(module, '${module}_basic', basic),
    ..._kana(module, '${module}_dakuten', dakuten),
    ..._kana(module, '${module}_combined', combined),
  ];
  assert(
    kana.map((c) => c.reading.value).toSet().length == kana.length,
    'reading duplicado en los kana de $module',
  );
  final wordRows = _words(module, '${module}_words', words);
  assert(wordRows.length == wordsCount,
      'se esperaban $wordsCount palabras en $module, hay ${wordRows.length}');
  b.insertAll(db.itemGroups, [
    _group(module, '${module}_basic', 'kana', 'Básicos',
        '46 caracteres · $basicExample', 0),
    _group(module, '${module}_dakuten', 'kana', 'Dakuten y handakuten',
        '25 caracteres · $dakutenExample', 1),
    _group(module, '${module}_combined', 'kana', 'Combinados',
        '33 caracteres · $combinedExample', 2),
    _group(module, '${module}_words', 'word', wordsGroupName, '$wordsCount palabras', 3),
  ]);
  b.insertAll(db.items, [...kana, ...wordRows]);
  b.insert(db.settings,
      SettingsCompanion.insert(key: 'active_groups:$module', value: '${module}_basic'));
}

void _addHiragana(Batch b, AppDatabase db) => _addScript(b, db,
    module: 'hiragana',
    basic: _hBasic,
    dakuten: _hDakuten,
    combined: _hCombined,
    words: _hBody,
    wordsGroupName: 'Partes del cuerpo',
    basicExample: 'あ い う え お',
    dakutenExample: 'が ざ ぱ',
    combinedExample: 'きゃ しゅ ちょ',
    wordsCount: 30);

void _addHiraganaOrgans(Batch b, AppDatabase db) {
  final rows = _words('hiragana', 'hiragana_organs', _hOrgans);
  assert(rows.length == 30, 'se esperaban 30 organos, hay ${rows.length}');
  b.insert(db.itemGroups,
      _group('hiragana', 'hiragana_organs', 'word', 'Órganos del cuerpo', '30 palabras', 4));
  b.insertAll(db.items, rows);
}

void _addKatakana(Batch b, AppDatabase db) => _addScript(b, db,
    module: 'katakana',
    basic: _kBasic,
    dakuten: _kDakuten,
    combined: _kCombined,
    words: _kFood,
    wordsGroupName: 'Comida y bebida',
    basicExample: 'ア イ ウ エ オ',
    dakutenExample: 'ガ ザ パ',
    combinedExample: 'キャ シュ チョ',
    wordsCount: 30);

Future<void> seedDatabase(AppDatabase db) => db.batch((b) {
      b.insertAll(db.modules, [
        ModulesCompanion.insert(
            id: 'hiragana', name: 'Hiragana', glyph: 'あ', sortOrder: 0, enabled: true),
        ModulesCompanion.insert(
            id: 'katakana', name: 'Katakana', glyph: 'ア', sortOrder: 1, enabled: true),
        ModulesCompanion.insert(
            id: 'kanji', name: 'Kanji', glyph: '字', sortOrder: 2, enabled: false),
      ]);
      _addHiragana(b, db);
      _addHiraganaOrgans(b, db);
      _addKatakana(b, db);
    });

/// Esquema v3: activa Katakana en bases creadas antes de que existiera.
Future<void> upgradeToV3(AppDatabase db) async {
  await db.customStatement("UPDATE modules SET enabled = 1 WHERE id = 'katakana'");
  await db.batch((b) => _addKatakana(b, db));
}

/// Esquema v4: seccion "Organos del cuerpo" en Hiragana.
Future<void> upgradeToV4(AppDatabase db) => db.batch((b) => _addHiraganaOrgans(b, db));
