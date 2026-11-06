// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Petru FC';

  @override
  String get back => 'Volver';

  @override
  String get close => 'Cerrar';

  @override
  String get settings => 'Configuración';

  @override
  String get listenPronunciation => 'Escuchar pronunciación';

  @override
  String get next => 'Siguiente';

  @override
  String get previous => 'Anterior';

  @override
  String get erase => 'Borrar';

  @override
  String get viewSummary => 'Ver resumen';

  @override
  String get open => 'Entrar';

  @override
  String get play => 'Jugar';

  @override
  String get ttsNoVoice =>
      'Falta la voz japonesa. Instálala en Ajustes > Salida de texto a voz.';

  @override
  String get ttsFailed => 'No se pudo reproducir el audio.';

  @override
  String get summaryTitle => '¡Ronda completa!';

  @override
  String get summaryCorrectLabel => 'aciertos';

  @override
  String get summaryBestCombo => 'Mejor combo';

  @override
  String get summaryAccuracy => 'Precisión';

  @override
  String get summaryAgain => 'Otra ronda';

  @override
  String get summaryExit => 'Salir';

  @override
  String get masteryUnseen => 'Sin ver';

  @override
  String get masteryWeak => 'Fallado';

  @override
  String get masteryLearning => 'Aprendiendo';

  @override
  String get masteryMastered => 'Dominado';

  @override
  String masteredToast(String chars) {
    return '¡$chars dominado!';
  }

  @override
  String get goalCelebrationTitle => '¡Meta del día cumplida!';

  @override
  String get goalCelebrationBody => 'Lo lograste, sigue si quieres';

  @override
  String get homeTagline => 'Estudia japonés a tu ritmo';

  @override
  String get comingSoon => 'PRÓXIMAMENTE';

  @override
  String get moduleBlurb => 'Flashcards, práctica y vocabulario';

  @override
  String get goalTodayLabel => 'META DE HOY';

  @override
  String get goalReached => '¡Meta cumplida!';

  @override
  String goalMinutesLeft(int left) {
    return 'Te faltan $left min';
  }

  @override
  String goalOfMinutes(int goal) {
    return 'de $goal min de práctica';
  }

  @override
  String get mascotGoalDone => '¡Meta cumplida! Hoy lo diste todo';

  @override
  String get mascotHello => '¡Hola! Empecemos con unos minutos de japonés';

  @override
  String mascotKeepGoing(int left) {
    return 'Vas muy bien, te faltan $left min';
  }

  @override
  String get menuReference => 'Referencia';

  @override
  String get menuReferenceSub => 'Tabla de caracteres';

  @override
  String get menuLearn => 'Aprender';

  @override
  String get menuLearnSub => 'Trazo paso a paso';

  @override
  String get menuPractice => 'Práctica';

  @override
  String get menuPracticeSub => 'Dibuja con el dedo';

  @override
  String get menuFlashcards => 'Flashcards';

  @override
  String get menuFlashcardsSub => 'Reconoce cada carácter';

  @override
  String get menuVocabulary => 'Vocabulario';

  @override
  String get menuVocabularySub => 'Palabras por tema';

  @override
  String get menuGames => 'Juegos';

  @override
  String get menuGamesSub => 'Memorama y más';

  @override
  String get groupBasic => 'Básicos';

  @override
  String get groupDakuten => 'Dakuten y handakuten';

  @override
  String get groupCombined => 'Combinados';

  @override
  String get groupBody => 'Partes del cuerpo';

  @override
  String get groupFood => 'Comida y bebida';

  @override
  String get groupOrgans => 'Órganos del cuerpo';

  @override
  String get groupColors => 'Colores';

  @override
  String get groupJobs => 'Profesiones';

  @override
  String get groupSushi => 'Sushi y acompañantes';

  @override
  String get groupClothes => 'Ropa';

  @override
  String get groupHome => 'Objetos de casa';

  @override
  String get groupMusic => 'Instrumentos musicales';

  @override
  String get groupNames => 'Nombres famosos';

  @override
  String get groupFruits => 'Frutas';

  @override
  String get groupVeggies => 'Verduras';

  @override
  String get groupTravel => 'Viajes y equipaje';

  @override
  String get groupMedicine => 'Medicina básica';

  @override
  String get groupComputing => 'Computación y programación';

  @override
  String get groupAi => 'Inteligencia artificial';

  @override
  String groupKanaSubtitle(int count, String examples) {
    return '$count caracteres · $examples';
  }

  @override
  String groupWordsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '1 palabra',
    );
    return '$_temp0';
  }

  @override
  String groupNamesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nombres',
      one: '1 nombre',
    );
    return '$_temp0';
  }

  @override
  String get referenceTitle => 'Referencia';

  @override
  String referenceCounts(int total, int mastered) {
    return '$total caracteres · $mastered dominados';
  }

  @override
  String get vocabularyTitle => 'Vocabulario';

  @override
  String vocabReferenceHeading(String name) {
    return 'Referencia · $name';
  }

  @override
  String vocabCounts(int count, int mastered) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '1 palabra',
    );
    return '$_temp0 · $mastered dominadas';
  }

  @override
  String get vocabMenuReferenceSub => 'Palabras y significados';

  @override
  String get vocabMenuPracticeSub => 'Elige la respuesta correcta';

  @override
  String get wordSearchName => 'Sopa de letras';

  @override
  String get wordSearchSub => 'Encuentra las palabras';

  @override
  String modeKanaToRomaji(String script) {
    return '$script → Romaji';
  }

  @override
  String modeRomajiToKana(String script) {
    return 'Romaji → $script';
  }

  @override
  String modeScriptSwap(String from, String to) {
    return '$from → $to';
  }

  @override
  String modeWordToMeaning(String script) {
    return '$script → Español';
  }

  @override
  String modeMeaningToWord(String script) {
    return 'Español → $script';
  }

  @override
  String get setupFlashcards => 'Flashcards';

  @override
  String get setupPractice => 'Práctica';

  @override
  String get setupWhatToPractice => 'QUÉ QUIERES PRACTICAR';

  @override
  String get multiSelect => 'Selección múltiple';

  @override
  String get multiSelectSub => '9 caracteres en 3 bloques de 3';

  @override
  String comboBang(int n) {
    return '¡Combo x$n!';
  }

  @override
  String get masteredBang => '¡Dominado!';

  @override
  String get modeSectionLabel => 'MODO';

  @override
  String get practiceTag => 'PRÁCTICA · TRAZO';

  @override
  String practiceDrawPrompt(String script) {
    return 'Dibuja el $script de';
  }

  @override
  String get practiceCheck => 'Check';

  @override
  String get practiceHowDidYouDo => '¿Cómo te fue?';

  @override
  String get practiceReview => 'Repasar';

  @override
  String get practiceGotIt => 'Lo logré';

  @override
  String get practiceYourStroke => 'TU TRAZO';

  @override
  String get practiceCompare => 'Compara el orden y la forma de los trazos';

  @override
  String get verdictGreat => 'Muy bien';

  @override
  String get verdictClose => 'Casi, revisa la forma';

  @override
  String get verdictReview => 'Repasa los trazos';

  @override
  String similarity(int pct, String label) {
    return '$pct% de parecido · $label';
  }

  @override
  String learnTag(int i, int n) {
    return 'APRENDER · $i/$n';
  }

  @override
  String get hideGuide => 'Ocultar guía';

  @override
  String get showGuide => 'Mostrar guía';

  @override
  String get viewStrokes => 'Ver trazos';

  @override
  String get gamesTitle => 'Juegos';

  @override
  String gamesTitleModule(String module) {
    return 'Juegos · $module';
  }

  @override
  String get memoryName => 'Memorama';

  @override
  String get memorySub => 'Encuentra los pares';

  @override
  String get buildName => 'Arma la palabra';

  @override
  String get buildSub => 'Ordena los caracteres';

  @override
  String get memoryTag => 'MEMORAMA';

  @override
  String get buildTag => 'ARMA LA PALABRA';

  @override
  String get wordSearchTag => 'SOPA DE LETRAS';

  @override
  String get gameKindCharacters => 'Caracteres';

  @override
  String get gameKindVocabulary => 'Vocabulario';

  @override
  String get gameSection => 'SECCIÓN';

  @override
  String get newWordSearch => 'Nueva sopa';

  @override
  String findLabel(int found, int total) {
    return 'ENCUENTRA · $found/$total';
  }

  @override
  String get foundAll => '¡Las encontraste todas!';

  @override
  String get settingsDailyGoal => 'META DIARIA';

  @override
  String settingsGoalMinutes(int n) {
    return '$n minutos al día';
  }

  @override
  String get settingsGoalHint =>
      'El anillo de Inicio se llena con tu tiempo de práctica.';

  @override
  String settingsGoalSlider(int n) {
    return '$n min';
  }

  @override
  String get settingsRoundSize => 'TAMAÑO DE LA RONDA';

  @override
  String settingsCards(int n) {
    return '$n tarjetas';
  }

  @override
  String get settingsRoundHint =>
      'Cuántas tarjetas tiene cada ronda de Flashcards y Práctica.';

  @override
  String get settingsFeedback => 'SENSACIONES';

  @override
  String get settingsVibration => 'Vibración';

  @override
  String get settingsVibrationSub => 'Al acertar, en combos y al dominar';

  @override
  String get settingsEffects => 'Festejos y animaciones';

  @override
  String get settingsEffectsSub => 'Confeti al completar rondas y metas';

  @override
  String get settingsMascot => 'Mostrar mascota';

  @override
  String get settingsMascotSub => 'El gato que te acompaña y festeja';

  @override
  String settingsVersion(String v) {
    return 'Versión $v';
  }

  @override
  String get settingsCredit =>
      'Orden de trazos: KanjiVG (CC BY-SA 3.0), kanjivg.tagaini.net';

  @override
  String get practiceCorrect => 'CORRECTO';

  @override
  String get settingsSound => 'Sonidos de shamisen';

  @override
  String get settingsSoundSub =>
      'Notas suaves al tocar, responder y cumplir metas';

  @override
  String get soundOnLabel => 'Sonido activado';

  @override
  String get soundOffLabel => 'Sonido desactivado';

  @override
  String get continueTitle => 'Continúa donde quedaste';

  @override
  String get continueStart => 'Empezar a estudiar';

  @override
  String get greetMorning => 'おはよう';

  @override
  String get greetDay => 'こんにちは';

  @override
  String get greetEvening => 'こんばんは';

  @override
  String minOfGoal(int goal) {
    return 'de $goal min';
  }

  @override
  String get modulesLabel => 'Módulos';

  @override
  String get comingSoonShort => 'PRONTO';
}
