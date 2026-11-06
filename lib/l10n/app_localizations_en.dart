// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Petru FC';

  @override
  String get back => 'Back';

  @override
  String get close => 'Close';

  @override
  String get settings => 'Settings';

  @override
  String get listenPronunciation => 'Listen to pronunciation';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get erase => 'Clear';

  @override
  String get viewSummary => 'See summary';

  @override
  String get open => 'Open';

  @override
  String get play => 'Play';

  @override
  String get ttsNoVoice =>
      'Japanese voice missing. Install it in Settings > Text-to-speech output.';

  @override
  String get ttsFailed => 'Could not play the audio.';

  @override
  String get summaryTitle => 'Round complete!';

  @override
  String get summaryCorrectLabel => 'correct';

  @override
  String get summaryBestCombo => 'Best combo';

  @override
  String get summaryAccuracy => 'Accuracy';

  @override
  String get summaryAgain => 'Another round';

  @override
  String get summaryExit => 'Exit';

  @override
  String get masteryUnseen => 'Unseen';

  @override
  String get masteryWeak => 'Missed';

  @override
  String get masteryLearning => 'Learning';

  @override
  String get masteryMastered => 'Mastered';

  @override
  String masteredToast(String chars) {
    return '$chars mastered!';
  }

  @override
  String get goalCelebrationTitle => 'Daily goal reached!';

  @override
  String get goalCelebrationBody => 'You did it, keep going if you like';

  @override
  String get homeTagline => 'Study Japanese at your own pace';

  @override
  String get comingSoon => 'COMING SOON';

  @override
  String get moduleBlurb => 'Flashcards, practice and vocabulary';

  @override
  String get goalTodayLabel => 'TODAY\'S GOAL';

  @override
  String get goalReached => 'Goal reached!';

  @override
  String goalMinutesLeft(int left) {
    return '$left min to go';
  }

  @override
  String goalOfMinutes(int goal) {
    return 'of $goal min of practice';
  }

  @override
  String get mascotGoalDone => 'Goal reached! You gave it your all today';

  @override
  String get mascotHello => 'Hi! Let\'s start with a few minutes of Japanese';

  @override
  String mascotKeepGoing(int left) {
    return 'You\'re doing great, $left min to go';
  }

  @override
  String get menuReference => 'Reference';

  @override
  String get menuReferenceSub => 'Character chart';

  @override
  String get menuLearn => 'Learn';

  @override
  String get menuLearnSub => 'Stroke by stroke';

  @override
  String get menuPractice => 'Practice';

  @override
  String get menuPracticeSub => 'Draw with your finger';

  @override
  String get menuFlashcards => 'Flashcards';

  @override
  String get menuFlashcardsSub => 'Recognize each character';

  @override
  String get menuVocabulary => 'Vocabulary';

  @override
  String get menuVocabularySub => 'Words by topic';

  @override
  String get menuGames => 'Games';

  @override
  String get menuGamesSub => 'Memory and more';

  @override
  String get groupBasic => 'Basic';

  @override
  String get groupDakuten => 'Dakuten and handakuten';

  @override
  String get groupCombined => 'Combined';

  @override
  String get groupBody => 'Body parts';

  @override
  String get groupFood => 'Food and drinks';

  @override
  String get groupOrgans => 'Body organs';

  @override
  String get groupColors => 'Colors';

  @override
  String get groupJobs => 'Jobs';

  @override
  String get groupSushi => 'Sushi and sides';

  @override
  String get groupClothes => 'Clothes';

  @override
  String get groupHome => 'Home objects';

  @override
  String get groupMusic => 'Musical instruments';

  @override
  String get groupNames => 'Famous names';

  @override
  String get groupFruits => 'Fruits';

  @override
  String get groupVeggies => 'Vegetables';

  @override
  String get groupTravel => 'Travel and luggage';

  @override
  String get groupMedicine => 'Basic medicine';

  @override
  String get groupComputing => 'Computing and programming';

  @override
  String get groupAi => 'Artificial intelligence';

  @override
  String groupKanaSubtitle(int count, String examples) {
    return '$count characters · $examples';
  }

  @override
  String groupWordsSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
    );
    return '$_temp0';
  }

  @override
  String groupNamesSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count names',
      one: '1 name',
    );
    return '$_temp0';
  }

  @override
  String get referenceTitle => 'Reference';

  @override
  String referenceCounts(int total, int mastered) {
    return '$total characters · $mastered mastered';
  }

  @override
  String get vocabularyTitle => 'Vocabulary';

  @override
  String vocabReferenceHeading(String name) {
    return 'Reference · $name';
  }

  @override
  String vocabCounts(int count, int mastered) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '1 word',
    );
    return '$_temp0 · $mastered mastered';
  }

  @override
  String get vocabMenuReferenceSub => 'Words and meanings';

  @override
  String get vocabMenuPracticeSub => 'Pick the right answer';

  @override
  String get wordSearchName => 'Word search';

  @override
  String get wordSearchSub => 'Find the words';

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
    return '$script → English';
  }

  @override
  String modeMeaningToWord(String script) {
    return 'English → $script';
  }

  @override
  String get setupFlashcards => 'Flashcards';

  @override
  String get setupPractice => 'Practice';

  @override
  String get setupWhatToPractice => 'WHAT DO YOU WANT TO PRACTICE';

  @override
  String get multiSelect => 'Multiple selection';

  @override
  String get multiSelectSub => '9 characters in 3 blocks of 3';

  @override
  String comboBang(int n) {
    return 'Combo x$n!';
  }

  @override
  String get masteredBang => 'Mastered!';

  @override
  String get modeSectionLabel => 'MODE';

  @override
  String get practiceTag => 'PRACTICE · STROKES';

  @override
  String practiceDrawPrompt(String script) {
    return 'Draw the $script for';
  }

  @override
  String get practiceCheck => 'Check';

  @override
  String get practiceHowDidYouDo => 'How did you do?';

  @override
  String get practiceReview => 'Review';

  @override
  String get practiceGotIt => 'Got it';

  @override
  String get practiceYourStroke => 'YOUR STROKES';

  @override
  String get practiceCompare => 'Compare the order and shape of the strokes';

  @override
  String get verdictGreat => 'Very good';

  @override
  String get verdictClose => 'Almost, check the shape';

  @override
  String get verdictReview => 'Review the strokes';

  @override
  String similarity(int pct, String label) {
    return '$pct% match · $label';
  }

  @override
  String learnTag(int i, int n) {
    return 'LEARN · $i/$n';
  }

  @override
  String get hideGuide => 'Hide guide';

  @override
  String get showGuide => 'Show guide';

  @override
  String get viewStrokes => 'Show strokes';

  @override
  String get gamesTitle => 'Games';

  @override
  String gamesTitleModule(String module) {
    return 'Games · $module';
  }

  @override
  String get memoryName => 'Memory';

  @override
  String get memorySub => 'Find the pairs';

  @override
  String get buildName => 'Build the word';

  @override
  String get buildSub => 'Put the characters in order';

  @override
  String get memoryTag => 'MEMORY';

  @override
  String get buildTag => 'BUILD THE WORD';

  @override
  String get wordSearchTag => 'WORD SEARCH';

  @override
  String get gameKindCharacters => 'Characters';

  @override
  String get gameKindVocabulary => 'Vocabulary';

  @override
  String get gameSection => 'SECTION';

  @override
  String get newWordSearch => 'New search';

  @override
  String findLabel(int found, int total) {
    return 'FIND · $found/$total';
  }

  @override
  String get foundAll => 'You found them all!';

  @override
  String get settingsDailyGoal => 'DAILY GOAL';

  @override
  String settingsGoalMinutes(int n) {
    return '$n minutes a day';
  }

  @override
  String get settingsGoalHint =>
      'The ring on Home fills with your practice time.';

  @override
  String settingsGoalSlider(int n) {
    return '$n min';
  }

  @override
  String get settingsRoundSize => 'ROUND SIZE';

  @override
  String settingsCards(int n) {
    return '$n cards';
  }

  @override
  String get settingsRoundHint =>
      'How many cards each Flashcards and Practice round has.';

  @override
  String get settingsFeedback => 'FEEDBACK';

  @override
  String get settingsVibration => 'Vibration';

  @override
  String get settingsVibrationSub => 'On correct answers, combos and mastery';

  @override
  String get settingsEffects => 'Celebrations and animations';

  @override
  String get settingsEffectsSub => 'Confetti when you finish rounds and goals';

  @override
  String get settingsMascot => 'Show mascot';

  @override
  String get settingsMascotSub => 'The cat that keeps you company and cheers';

  @override
  String settingsVersion(String v) {
    return 'Version $v';
  }

  @override
  String get settingsCredit =>
      'Stroke order data: KanjiVG (CC BY-SA 3.0), kanjivg.tagaini.net';

  @override
  String get practiceCorrect => 'CORRECT';

  @override
  String get settingsSound => 'Shamisen sounds';

  @override
  String get settingsSoundSub => 'Soft plucks on taps, answers and goals';

  @override
  String get soundOnLabel => 'Sound on';

  @override
  String get soundOffLabel => 'Sound off';

  @override
  String get continueTitle => 'Continue where you left off';

  @override
  String get continueStart => 'Start studying';

  @override
  String get greetMorning => 'おはよう';

  @override
  String get greetDay => 'こんにちは';

  @override
  String get greetEvening => 'こんばんは';

  @override
  String minOfGoal(int goal) {
    return 'of $goal min';
  }

  @override
  String get modulesLabel => 'Modules';

  @override
  String get comingSoonShort => 'SOON';
}
