import '../data/database.dart';
import 'language.dart';

String _suffix(ItemGroup g) => g.id.substring(g.moduleId.length + 1);

/// Nombre del grupo en el idioma actual (si no se conoce, el guardado en la base).
String groupName(AppLocalizations l, ItemGroup g) => switch (_suffix(g)) {
      'basic' => l.groupBasic,
      'dakuten' => l.groupDakuten,
      'combined' => l.groupCombined,
      'words' => g.moduleId == 'hiragana' ? l.groupBody : l.groupFood,
      'organs' => l.groupOrgans,
      'colors' => l.groupColors,
      'jobs' => l.groupJobs,
      'sushi' => l.groupSushi,
      'clothes' => l.groupClothes,
      'home' => l.groupHome,
      'music' => l.groupMusic,
      'names' => l.groupNames,
      'fruits' => l.groupFruits,
      'veggies' => l.groupVeggies,
      'travel' => l.groupTravel,
      'medicine' => l.groupMedicine,
      'computing' => l.groupComputing,
      'ai' => l.groupAi,
      'g1' => l.groupGrade1,
      'numbers' => l.groupNumbers,
      'nature' => l.groupNature,
      'body_people' => l.groupBodyPeople,
      'school' => l.groupSchool,
      'time' => l.groupTimeDays,
      'animals_colors' => l.groupAnimalsColors,
      _ => g.name,
    };

final _kanaSub = RegExp(r'^(\d+) caracteres · (.*)$');
final _wordsSub = RegExp(r'^(\d+) (palabras|nombres)$');

/// Subtitulo del grupo ("46 caracteres · あ い う", "30 palabras") en el idioma actual.
String groupSubtitle(AppLocalizations l, ItemGroup g) {
  final k = _kanaSub.firstMatch(g.subtitle);
  if (k != null) return l.groupKanaSubtitle(int.parse(k.group(1)!), k.group(2)!);
  final w = _wordsSub.firstMatch(g.subtitle);
  if (w != null) {
    final n = int.parse(w.group(1)!);
    return w.group(2) == 'nombres' ? l.groupNamesSubtitle(n) : l.groupWordsSubtitle(n);
  }
  return g.subtitle;
}
