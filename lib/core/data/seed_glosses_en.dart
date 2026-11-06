import 'seed_glosses_en_a.dart';
import 'seed_glosses_en_b.dart';
import 'seed_glosses_en_c.dart';
import 'seed_glosses_en_d.dart';
import 'seed_glosses_en_e.dart';
import 'seed_glosses_en_f.dart';
import 'seed_glosses_en_g.dart';

/// Todos los glosarios en ingles: grupo -> palabra japonesa -> significado.
const allGlossesEn = <String, Map<String, String>>{
  ...glossesEnA,
  ...glossesEnB,
  ...glossesEnC,
  ...glossesEnD,
  ...glossesEnE,
  ...glossesEnF,
  ...glossesEnG,
};

String? glossEn(String groupId, String japanese) => allGlossesEn[groupId]?[japanese];
