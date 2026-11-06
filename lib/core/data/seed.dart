import 'seed_topics.dart';
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

// Colores (hiragana).
const _hColors = 'あか:aka:Rojo あお:ao:Azul きいろ:kiiro:Amarillo みどり:midori:Verde '
    'くろ:kuro:Negro しろ:shiro:Blanco はいいろ:haiiro:Gris ちゃいろ:chairo:Café '
    'むらさき:murasaki:Morado ももいろ:momoiro:Rosado だいだいいろ:daidaiiro:Naranja '
    'みずいろ:mizuiro:Celeste きんいろ:kiniro:Dorado ぎんいろ:giniro:Plateado '
    'こんいろ:koniro:Azul marino はだいろ:hadairo:Color piel きみどり:kimidori:Verde lima '
    'あいいろ:aiiro:Índigo';

// Colores (katakana, palabras de origen extranjero).
const _kColors = 'レッド:reddo:Rojo ブルー:buruu:Azul イエロー:ieroo:Amarillo '
    'グリーン:guriin:Verde ブラック:burakku:Negro ホワイト:howaito:Blanco グレー:guree:Gris '
    'ブラウン:buraun:Café パープル:paapuru:Morado ピンク:pinku:Rosado '
    'オレンジ:orenji:Naranja ゴールド:goorudo:Dorado シルバー:shirubaa:Plateado '
    'ベージュ:beeju:Beige ネイビー:neibii:Azul marino ターコイズ:taakoizu:Turquesa '
    'ラベンダー:rabendaa:Lavanda クリーム:kuriimu:Crema';

// Profesiones (hiragana: palabras japonesas escritas sin kanji).
const _hJobs = 'けいさつかん:keisatsukan:Policía しょうぼうし:shouboushi:Bombero '
    'べんごし:bengoshi:Abogado しょうにかい:shounikai:Pediatra いしゃ:isha:Médico '
    'かんごし:kangoshi:Enfermero はいしゃ:haisha:Dentista せんせい:sensei:Maestro '
    'さいばんかん:saibankan:Juez やくざいし:yakuzaishi:Farmacéutico '
    'じゅうい:juui:Veterinario かいけいし:kaikeishi:Contador '
    'ぎんこういん:ginkouin:Empleado de banco かいしゃいん:kaishain:Empleado de oficina '
    'てんいん:tenin:Vendedor うんてんしゅ:untenshu:Conductor ひこうし:hikoushi:Piloto '
    'ちょうりし:chourishi:Cocinero さかなや:sakanaya:Pescadero だいく:daiku:Carpintero '
    'でんきこう:denkikou:Electricista せいびし:seibishi:Mecánico '
    'けんちくか:kenchikuka:Arquitecto かしゅ:kashu:Cantante がか:gaka:Pintor '
    'さっか:sakka:Escritor きしゃ:kisha:Periodista のうか:nouka:Agricultor '
    'りょうし:ryoushi:Pescador かがくしゃ:kagakusha:Científico';

// Profesiones (katakana, palabras de origen extranjero).
const _kJobs = 'プログラマー:puroguramaa:Programador エンジニア:enjinia:Ingeniero '
    'デザイナー:dezainaa:Diseñador ナース:naasu:Enfermero ドクター:dokutaa:Doctor '
    'パイロット:pairotto:Piloto シェフ:shefu:Chef コック:kokku:Cocinero '
    'ウェイター:ueitaa:Mesero ウェイトレス:ueitoresu:Mesera バーテンダー:baatendaa:Bartender '
    'パティシエ:patishie:Pastelero カメラマン:kameraman:Fotógrafo '
    'ミュージシャン:myuujishan:Músico ピアニスト:pianisuto:Pianista '
    'ギタリスト:gitarisuto:Guitarrista ダンサー:dansaa:Bailarín モデル:moderu:Modelo '
    'アーティスト:aatisuto:Artista ジャーナリスト:jaanarisuto:Periodista '
    'アナウンサー:anaunsaa:Locutor マネージャー:maneejaa:Gerente '
    'コンサルタント:konsarutanto:Consultor セールスマン:seerusuman:Vendedor '
    'ガードマン:gaadoman:Guardia de seguridad ドライバー:doraibaa:Conductor '
    'スタイリスト:sutairisuto:Estilista カウンセラー:kaunseraa:Consejero '
    'アスリート:asuriito:Atleta コーチ:koochi:Entrenador';

// Sushi y lo que lo acompana (hiragana).
const _hSushi = 'すし:sushi:Sushi さしみ:sashimi:Sashimi にぎりずし:nigirizushi:Sushi nigiri '
    'まきずし:makizushi:Sushi en rollo ちらしずし:chirashizushi:Sushi chirashi '
    'いなりずし:inarizushi:Sushi inari てんぷら:tenpura:Tempura えび:ebi:Camarón '
    'さけ:sake:Salmón まぐろ:maguro:Atún とろ:toro:Atún graso たまご:tamago:Huevo '
    'いか:ika:Calamar たこ:tako:Pulpo うに:uni:Erizo de mar いくら:ikura:Huevas de salmón '
    'あなご:anago:Anguila de mar うなぎ:unagi:Anguila de río かに:kani:Cangrejo '
    'たい:tai:Besugo ほたて:hotate:Vieira あじ:aji:Jurel さば:saba:Caballa '
    'のり:nori:Alga nori ごはん:gohan:Arroz しょうゆ:shouyu:Salsa de soya '
    'わさび:wasabi:Wasabi がり:gari:Jengibre encurtido おちゃ:ocha:Té '
    'みそしる:misoshiru:Sopa de miso';

// Sushi y lo que lo acompana (katakana).
const _kSushi = 'スシ:sushi:Sushi サシミ:sashimi:Sashimi エビ:ebi:Camarón '
    'テンプラ:tenpura:Tempura サーモン:saamon:Salmón ツナ:tsuna:Atún マグロ:maguro:Atún '
    'トロ:toro:Atún graso イカ:ika:Calamar タコ:tako:Pulpo ウニ:uni:Erizo de mar '
    'イクラ:ikura:Huevas de salmón アナゴ:anago:Anguila de mar ウナギ:unagi:Anguila de río '
    'カニ:kani:Cangrejo ホタテ:hotate:Vieira アボカド:abokado:Aguacate '
    'キュウリ:kyuuri:Pepino タマゴ:tamago:Huevo ネギ:negi:Cebollín ワサビ:wasabi:Wasabi '
    'ガリ:gari:Jengibre encurtido ノリ:nori:Alga nori ソース:soosu:Salsa '
    'マヨネーズ:mayoneezu:Mayonesa ビール:biiru:Cerveza ドリンク:dorinku:Bebida '
    'サラダ:sarada:Ensalada デザート:dezaato:Postre '
    'カリフォルニアロール:kariforuniarooru:Rollo California';

// Ropa (hiragana: palabras japonesas).
const _hClothes = 'ふく:fuku:Ropa ようふく:youfuku:Ropa occidental わふく:wafuku:Ropa japonesa '
    'きもの:kimono:Kimono ゆかた:yukata:Yukata おび:obi:Faja obi はかま:hakama:Hakama '
    'したぎ:shitagi:Ropa interior うわぎ:uwagi:Chaqueta ねまき:nemaki:Pijama '
    'せいふく:seifuku:Uniforme みずぎ:mizugi:Traje de baño くつ:kutsu:Zapatos '
    'くつした:kutsushita:Calcetines たび:tabi:Calcetín tabi ぞうり:zouri:Sandalia zori '
    'げた:geta:Sandalia geta ぼうし:boushi:Sombrero てぶくろ:tebukuro:Guantes '
    'えりまき:erimaki:Bufanda めがね:megane:Lentes ゆびわ:yubiwa:Anillo '
    'かばん:kaban:Bolso さいふ:saifu:Billetera うでどけい:udedokei:Reloj de pulsera';

// Ropa (katakana, palabras de origen extranjero).
const _kClothes = 'シャツ:shatsu:Camisa ティーシャツ:tiishatsu:Camiseta ポロシャツ:poroshatsu:Polo '
    'ブラウス:burausu:Blusa ドレス:doresu:Vestido ワンピース:wanpiisu:Vestido de una pieza '
    'スカート:sukaato:Falda ズボン:zubon:Pantalón パンツ:pantsu:Pantalones '
    'ジーンズ:jiinzu:Jeans ショートパンツ:shootopantsu:Pantalón corto セーター:seetaa:Suéter '
    'カーディガン:kaadigan:Cárdigan パーカー:paakaa:Sudadera con capucha '
    'ジャケット:jaketto:Chaqueta コート:kooto:Abrigo スーツ:suutsu:Traje '
    'ネクタイ:nekutai:Corbata ベルト:beruto:Cinturón ベスト:besuto:Chaleco '
    'パジャマ:pajama:Pijama エプロン:epuron:Delantal マフラー:mafuraa:Bufanda '
    'スカーフ:sukaafu:Pañuelo de cuello ソックス:sokkusu:Calcetines '
    'ストッキング:sutokkingu:Medias ブーツ:buutsu:Botas サンダル:sandaru:Sandalias '
    'スニーカー:sunikaa:Zapatillas ハイヒール:haihiiru:Tacones ネックレス:nekkuresu:Collar '
    'ハンカチ:hankachi:Pañuelo de mano';

// Objetos de la casa (hiragana: palabras japonesas).
const _hHome = 'れいぞうこ:reizouko:Refrigeradora だいどころ:daidokoro:Cocina へや:heya:Habitación '
    'いえ:ie:Casa げんかん:genkan:Entrada まど:mado:Ventana かべ:kabe:Pared ゆか:yuka:Piso '
    'てんじょう:tenjou:Techo やね:yane:Tejado にわ:niwa:Jardín かいだん:kaidan:Escalera '
    'ふろ:furo:Bañera つくえ:tsukue:Escritorio いす:isu:Silla たな:tana:Estante '
    'ほんだな:hondana:Librero ふとん:futon:Futón まくら:makura:Almohada '
    'かがみ:kagami:Espejo とけい:tokei:Reloj でんわ:denwa:Teléfono '
    'せんたくき:sentakuki:Lavadora そうじき:soujiki:Aspiradora ほうき:houki:Escoba '
    'かぎ:kagi:Llave さら:sara:Plato ちゃわん:chawan:Tazón なべ:nabe:Olla '
    'やかん:yakan:Tetera はし:hashi:Palillos せっけん:sekken:Jabón';

// Objetos de la casa (katakana, palabras de origen extranjero).
const _kHome = 'テレビ:terebi:Televisión ラジオ:rajio:Radio エアコン:eakon:Aire acondicionado '
    'ヒーター:hiitaa:Calefactor ソファー:sofaa:Sofá ベッド:beddo:Cama テーブル:teeburu:Mesa '
    'カーテン:kaaten:Cortina カーペット:kaapetto:Alfombra クッション:kusshon:Cojín '
    'ブランケット:burankketto:Manta シーツ:shiitsu:Sábana ハンガー:hangaa:Percha '
    'クローゼット:kuroozetto:Clóset ドア:doa:Puerta ベランダ:beranda:Balcón '
    'キッチン:kicchin:Cocina リビング:ribingu:Sala トイレ:toire:Baño シャワー:shawaa:Ducha '
    'タオル:taoru:Toalla ランプ:ranpu:Lámpara ライト:raito:Luz パソコン:pasokon:Computadora '
    'コンロ:konro:Hornilla オーブン:oobun:Horno トースター:toosutaa:Tostadora '
    'ミキサー:mikisaa:Licuadora ドライヤー:doraiyaa:Secador de cabello '
    'アイロン:airon:Plancha エレベーター:erebeetaa:Ascensor コップ:koppu:Vaso';

// Instrumentos musicales (hiragana: palabras japonesas).
const _hMusic = 'がっき:gakki:Instrumento musical ふえ:fue:Flauta たいこ:taiko:Tambor '
    'こと:koto:Koto しゃみせん:shamisen:Shamisen しゃくはち:shakuhachi:Shakuhachi '
    'びわ:biwa:Biwa かね:kane:Campana すず:suzu:Cascabel ほらがい:horagai:Caracola '
    'おんがく:ongaku:Música うた:uta:Canción がくふ:gakufu:Partitura おんぷ:onpu:Nota musical';

// Instrumentos musicales (katakana, palabras de origen extranjero).
const _kMusic = 'ピアノ:piano:Piano ギター:gitaa:Guitarra ベース:beesu:Bajo ドラム:doramu:Batería '
    'バイオリン:baiorin:Violín ビオラ:biora:Viola チェロ:chero:Chelo '
    'コントラバス:kontorabasu:Contrabajo ハープ:haapu:Arpa フルート:furuuto:Flauta '
    'ピッコロ:pikkoro:Flautín クラリネット:kurarinetto:Clarinete オーボエ:ooboe:Oboe '
    'ファゴット:fagotto:Fagot サックス:sakkusu:Saxofón トランペット:toranpetto:Trompeta '
    'トロンボーン:toronboon:Trombón ホルン:horun:Corno チューバ:chuuba:Tuba '
    'オルガン:orugan:Órgano アコーディオン:akoodion:Acordeón ハーモニカ:haamonika:Armónica '
    'ウクレレ:ukurere:Ukelele マンドリン:mandorin:Mandolina バンジョー:banjoo:Banjo '
    'キーボード:kiiboodo:Teclado シンセサイザー:shinsesaizaa:Sintetizador '
    'タンバリン:tanbarin:Pandereta カスタネット:kasutanetto:Castañuelas '
    'トライアングル:toraianguru:Triángulo シンバル:shinbaru:Platillos '
    'マラカス:marakasu:Maracas リコーダー:rikoodaa:Flauta dulce オカリナ:okarina:Ocarina';

// Nombres famosos en katakana (nombre y apellido separados por ・): cientificos, musicos y artistas.
const _kNames = 'アイザック・ニュートン:aizakkunyuuton:Isaac Newton '
    'アルベルト・アインシュタイン:arubarutoainshutain:Albert Einstein '
    'ガリレオ・ガリレイ:garireogariree:Galileo Galilei '
    'ニコラウス・コペルニクス:nikorausukoperunikusu:Nicolás Copérnico '
    'ヨハネス・ケプラー:yohanesukepuraa:Johannes Kepler チャールズ・ダーウィン:chaaruzudaawin:Charles Darwin '
    'グレゴール・メンデル:guregoorumenderu:Gregor Mendel ルイ・パスツール:ruipasutsuuru:Louis Pasteur '
    'マリー・キュリー:mariikyurii:Marie Curie ニールス・ボーア:niirusubooa:Niels Bohr '
    'ベルナー・ハイゼンベルク:berunaahaizenberuku:Werner Heisenberg '
    'エルビン・シュレディンガー:erubinshuredingaa:Erwin Schrödinger '
    'マックス・プランク:makkusupurankku:Max Planck マイケル・ファラデー:maikerufaradee:Michael Faraday '
    'ジェームズ・マクスウェル:jeemuzumakusuweru:James Maxwell '
    'スティーブン・ホーキング:sutiibunhookingu:Stephen Hawking ニコラ・テスラ:nikoratesura:Nikola Tesla '
    'トーマス・エジソン:toomasuejison:Thomas Edison イワン・パブロフ:iwanpaburofu:Iván Pavlov '
    'ドミトリ・メンデレーエフ:dorimitorimendereefu:Dmitri Mendeléyev '
    'アントワーヌ・ラボアジエ:antowaanuraboajie:Antoine Lavoisier '
    'エドウィン・ハッブル:edowinhabburu:Edwin Hubble カール・ガウス:kaarugausu:Carl Gauss '
    'レオンハルト・オイラー:reonharutooiraa:Leonhard Euler '
    'ゴットフリート・ライプニッツ:gottofuriitoraipunittsu:Gottfried Leibniz ピタゴラス:pitagorasu:Pitágoras '
    'アルキメデス:arukimedesu:Arquímedes ジークムント・フロイト:jiikumuntofuroito:Sigmund Freud '
    'リチャード・ファインマン:richaadofainman:Richard Feynman エンリコ・フェルミ:enrikoferumi:Enrico Fermi '
    'アーネスト・ラザフォード:aanesutorazafoodo:Ernest Rutherford '
    'ウィルヘルム・レントゲン:uiruherumurentogen:Wilhelm Röntgen '
    'エドワード・ジェンナー:edowaadojennaa:Edward Jenner アルフレッド・ノーベル:arufureddonooberu:Alfred Nobel '
    'カール・リンネ:kaarurinne:Carlos Linneo アレッサンドロ・ボルタ:aressandoroboruta:Alessandro Volta '
    'アンドレ・アンペール:andoreanpeeru:André-Marie Ampère '
    'ヨハン・セバスチャン・バッハ:yohansebasuchanbahha:Johann Sebastian Bach '
    'ヴォルフガング・モーツァルト:borufugangumootsuaruto:Wolfgang Mozart '
    'ルートヴィヒ・ヴァン・ベートーベン:ruutovihibanbeetooben:Ludwig van Beethoven '
    'ヨハネス・ブラームス:yohanesuburaamusu:Johannes Brahms '
    'フランツ・シューベルト:furantsushuuberuto:Franz Schubert '
    'ロベルト・シューマン:robertoshuuman:Robert Schumann '
    'フレデリック・ショパン:furederikkushopan:Frédéric Chopin フランツ・リスト:furantsurisuto:Franz Liszt '
    'フェリックス・メンデルスゾーン:ferikkususumenderusuzoon:Felix Mendelssohn '
    'リヒャルト・ワーグナー:rihyarutowaagunaa:Richard Wagner ジュゼッペ・ベルディ:juzeppeberudi:Giuseppe Verdi '
    'ゲオルク・ヘンデル:georukuhenderu:Georg Händel ヨーゼフ・ハイドン:yoozefuhaidon:Joseph Haydn '
    'アントニオ・ビバルディ:antoniobibarudi:Antonio Vivaldi '
    'ピョートル・チャイコフスキー:pyootorucahaikofusukii:Piotr Chaikovski '
    'セルゲイ・ラフマニノフ:serugeirafumaninofu:Sergei Rajmáninov '
    'イーゴリ・ストラビンスキー:iigorisutorabinsukii:Ígor Stravinski '
    'モデスト・ムソルグスキー:modesutomusorugusukii:Modest Músorgski '
    'クロード・ドビュッシー:kuroododobyusshii:Claude Debussy モーリス・ラベル:mooirusuraberu:Maurice Ravel '
    'エリック・サティ:erikkusati:Erik Satie ジョルジュ・ビゼー:jorujubizee:Georges Bizet '
    'アントニン・ドボルザーク:antonindoboruzaaku:Antonín Dvořák '
    'エドヴァルド・グリーグ:edovarudoguriigu:Edvard Grieg ジャン・シベリウス:janshiberiusu:Jean Sibelius '
    'グスタフ・マーラー:gusutafumaaraa:Gustav Mahler アントン・ブルックナー:antonburukkunaa:Anton Bruckner '
    'ニコロ・パガニーニ:nikoropaganiini:Niccolò Paganini ジャコモ・プッチーニ:jakomopucchiini:Giacomo Puccini '
    'ジョアキーノ・ロッシーニ:joakiinorosshiini:Gioachino Rossini '
    'セルゲイ・プロコフィエフ:serugeipurokofiefu:Serguéi Prokófiev '
    'ベーラ・バルトーク:beerabarutooku:Béla Bartók ジョージ・ガーシュウィン:jioogigaashuwin:George Gershwin '
    'パブロ・ピカソ:paburupikaso:Pablo Picasso サルバドール・ダリ:sarubadoorudari:Salvador Dalí '
    'クロード・モネ:kuroodomone:Claude Monet レンブラント・ファン・レイン:renburantofanrein:Rembrandt '
    'ミケランジェロ・ブオナローティ:mikeranjerobuonarooti:Miguel Ángel '
    'ウィリアム・シェークスピア:uiriamushiikusupia:William Shakespeare '
    'ミゲル・デ・セルバンテス:migerudeserubantesu:Miguel de Cervantes '
    'ナポレオン・ボナパルト:naporeonbonaparuto:Napoleón Bonaparte '
    'クリストファー・コロンブス:kurisutofaakoronbusu:Cristóbal Colón';

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

void _addColors(Batch b, AppDatabase db) {
  for (final (module, data, order) in [
    ('hiragana', _hColors, 5),
    ('katakana', _kColors, 4),
  ]) {
    final id = '${module}_colors';
    final rows = _words(module, id, data);
    b.insert(db.itemGroups,
        _group(module, id, 'word', 'Colores', '${rows.length} palabras', order));
    b.insertAll(db.items, rows);
  }
}

void _addTopics(Batch b, AppDatabase db) {
  for (final (module, suffix, name, data, order) in [
    ('hiragana', 'jobs', 'Profesiones', _hJobs, 6),
    ('hiragana', 'sushi', 'Sushi y acompañantes', _hSushi, 7),
    ('katakana', 'jobs', 'Profesiones', _kJobs, 5),
    ('katakana', 'sushi', 'Sushi y acompañantes', _kSushi, 6),
  ]) {
    final id = '${module}_$suffix';
    final rows = _words(module, id, data);
    assert(rows.length == 30, 'se esperaban 30 palabras en $id, hay ${rows.length}');
    b.insert(db.itemGroups,
        _group(module, id, 'word', name, '${rows.length} palabras', order));
    b.insertAll(db.items, rows);
  }
}

void _addTopics2(Batch b, AppDatabase db) {
  for (final (module, suffix, name, data, order) in [
    ('hiragana', 'clothes', 'Ropa', _hClothes, 8),
    ('hiragana', 'home', 'Objetos de casa', _hHome, 9),
    ('hiragana', 'music', 'Instrumentos musicales', _hMusic, 10),
    ('katakana', 'clothes', 'Ropa', _kClothes, 7),
    ('katakana', 'home', 'Objetos de casa', _kHome, 8),
    ('katakana', 'music', 'Instrumentos musicales', _kMusic, 9),
  ]) {
    final id = '${module}_$suffix';
    final rows = _words(module, id, data);
    b.insert(db.itemGroups,
        _group(module, id, 'word', name, '${rows.length} palabras', order));
    b.insertAll(db.items, rows);
  }
}

void _addNames(Batch b, AppDatabase db) {
  final rows = _words('katakana', 'katakana_names', _kNames);
  b.insert(db.itemGroups,
      _group('katakana', 'katakana_names', 'word', 'Nombres famosos', '${rows.length} nombres', 10));
  b.insertAll(db.items, rows);
}

void _addMoreTopics(Batch b, AppDatabase db) {
  for (final (module, suffix, name, data, order) in [
    ('hiragana', 'fruits', 'Frutas', hFruits, 11),
    ('hiragana', 'veggies', 'Verduras', hVeggies, 12),
    ('hiragana', 'travel', 'Viajes y equipaje', hTravel, 13),
    ('hiragana', 'medicine', 'Medicina básica', hMedicine, 14),
    ('hiragana', 'ai', 'Inteligencia artificial', hAi, 15),
    ('katakana', 'fruits', 'Frutas', kFruits, 11),
    ('katakana', 'veggies', 'Verduras', kVeggies, 12),
    ('katakana', 'travel', 'Viajes y equipaje', kTravel, 13),
    ('katakana', 'medicine', 'Medicina básica', kMedicine, 14),
    ('katakana', 'computing', 'Computación y programación', kComputing, 15),
    ('katakana', 'ai', 'Inteligencia artificial', kAi, 16),
  ]) {
    final id = '${module}_$suffix';
    final rows = _words(module, id, data);
    b.insert(db.itemGroups,
        _group(module, id, 'word', name, '${rows.length} palabras', order));
    b.insertAll(db.items, rows);
  }
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
      _addColors(b, db);
      _addTopics(b, db);
      _addTopics2(b, db);
      _addNames(b, db);
      _addMoreTopics(b, db);
    });

/// Esquema v3: activa Katakana en bases creadas antes de que existiera.
Future<void> upgradeToV3(AppDatabase db) async {
  await db.customStatement("UPDATE modules SET enabled = 1 WHERE id = 'katakana'");
  await db.batch((b) => _addKatakana(b, db));
}

/// Esquema v4: seccion "Organos del cuerpo" en Hiragana.
Future<void> upgradeToV4(AppDatabase db) => db.batch((b) => _addHiraganaOrgans(b, db));

/// Esquema v5: seccion "Colores" en Hiragana y Katakana.
Future<void> upgradeToV5(AppDatabase db) => db.batch((b) => _addColors(b, db));

/// Esquema v7: secciones "Profesiones" y "Sushi y acompañantes" en Hiragana y Katakana.
Future<void> upgradeToV7(AppDatabase db) => db.batch((b) => _addTopics(b, db));

/// Esquema v8: secciones "Ropa", "Objetos de casa" e "Instrumentos musicales".
Future<void> upgradeToV8(AppDatabase db) => db.batch((b) => _addTopics2(b, db));

/// Esquema v9: seccion "Nombres famosos" en Katakana.
Future<void> upgradeToV9(AppDatabase db) => db.batch((b) => _addNames(b, db));

/// Esquema v10: "Nombres famosos" pasa de solo apellido a nombre y apellido.
Future<void> upgradeToV10(AppDatabase db) async {
  const ids = "(SELECT id FROM items WHERE group_id = 'katakana_names')";
  await db.customStatement('DELETE FROM review_stats WHERE item_id IN $ids');
  await db.customStatement("DELETE FROM items WHERE group_id = 'katakana_names'");
  await db.customStatement("DELETE FROM item_groups WHERE id = 'katakana_names'");
  await db.batch((b) => _addNames(b, db));
}

/// Esquema v11: frutas, verduras, viajes, medicina, computacion e inteligencia artificial.
Future<void> upgradeToV11(AppDatabase db) => db.batch((b) => _addMoreTopics(b, db));
