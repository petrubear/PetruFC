import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// App name
  ///
  /// In en, this message translates to:
  /// **'Petru FC'**
  String get appTitle;

  /// Back button tooltip
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Close button tooltip
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Settings title and tooltip
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Speaker button tooltip
  ///
  /// In en, this message translates to:
  /// **'Listen to pronunciation'**
  String get listenPronunciation;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Clear canvas button
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get erase;

  /// Finish round button
  ///
  /// In en, this message translates to:
  /// **'See summary'**
  String get viewSummary;

  /// Enter a module button
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// Start game button
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Shown when no Japanese TTS voice
  ///
  /// In en, this message translates to:
  /// **'Japanese voice missing. Install it in Settings > Text-to-speech output.'**
  String get ttsNoVoice;

  /// Shown when speech fails
  ///
  /// In en, this message translates to:
  /// **'Could not play the audio.'**
  String get ttsFailed;

  /// summaryTitle
  ///
  /// In en, this message translates to:
  /// **'Round complete!'**
  String get summaryTitle;

  /// Under the score, lowercase
  ///
  /// In en, this message translates to:
  /// **'correct'**
  String get summaryCorrectLabel;

  /// summaryBestCombo
  ///
  /// In en, this message translates to:
  /// **'Best combo'**
  String get summaryBestCombo;

  /// summaryAccuracy
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get summaryAccuracy;

  /// summaryAgain
  ///
  /// In en, this message translates to:
  /// **'Another round'**
  String get summaryAgain;

  /// summaryExit
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get summaryExit;

  /// masteryUnseen
  ///
  /// In en, this message translates to:
  /// **'Unseen'**
  String get masteryUnseen;

  /// masteryWeak
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get masteryWeak;

  /// masteryLearning
  ///
  /// In en, this message translates to:
  /// **'Learning'**
  String get masteryLearning;

  /// masteryMastered
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get masteryMastered;

  /// Snack bar when characters reach mastery
  ///
  /// In en, this message translates to:
  /// **'{chars} mastered!'**
  String masteredToast(String chars);

  /// goalCelebrationTitle
  ///
  /// In en, this message translates to:
  /// **'Daily goal reached!'**
  String get goalCelebrationTitle;

  /// goalCelebrationBody
  ///
  /// In en, this message translates to:
  /// **'You did it, keep going if you like'**
  String get goalCelebrationBody;

  /// homeTagline
  ///
  /// In en, this message translates to:
  /// **'Study Japanese at your own pace'**
  String get homeTagline;

  /// comingSoon
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
  String get comingSoon;

  /// moduleBlurb
  ///
  /// In en, this message translates to:
  /// **'Flashcards, practice and vocabulary'**
  String get moduleBlurb;

  /// goalTodayLabel
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S GOAL'**
  String get goalTodayLabel;

  /// goalReached
  ///
  /// In en, this message translates to:
  /// **'Goal reached!'**
  String get goalReached;

  /// goalMinutesLeft
  ///
  /// In en, this message translates to:
  /// **'{left} min to go'**
  String goalMinutesLeft(int left);

  /// goalOfMinutes
  ///
  /// In en, this message translates to:
  /// **'of {goal} min of practice'**
  String goalOfMinutes(int goal);

  /// mascotGoalDone
  ///
  /// In en, this message translates to:
  /// **'Goal reached! You gave it your all today'**
  String get mascotGoalDone;

  /// mascotHello
  ///
  /// In en, this message translates to:
  /// **'Hi! Let\'s start with a few minutes of Japanese'**
  String get mascotHello;

  /// mascotKeepGoing
  ///
  /// In en, this message translates to:
  /// **'You\'re doing great, {left} min to go'**
  String mascotKeepGoing(int left);

  /// menuReference
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get menuReference;

  /// menuReferenceSub
  ///
  /// In en, this message translates to:
  /// **'Character chart'**
  String get menuReferenceSub;

  /// menuLearn
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get menuLearn;

  /// menuLearnSub
  ///
  /// In en, this message translates to:
  /// **'Stroke by stroke'**
  String get menuLearnSub;

  /// menuPractice
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get menuPractice;

  /// menuPracticeSub
  ///
  /// In en, this message translates to:
  /// **'Draw with your finger'**
  String get menuPracticeSub;

  /// menuFlashcards
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get menuFlashcards;

  /// menuFlashcardsSub
  ///
  /// In en, this message translates to:
  /// **'Recognize each character'**
  String get menuFlashcardsSub;

  /// menuVocabulary
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get menuVocabulary;

  /// menuVocabularySub
  ///
  /// In en, this message translates to:
  /// **'Words by topic'**
  String get menuVocabularySub;

  /// menuGames
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get menuGames;

  /// menuGamesSub
  ///
  /// In en, this message translates to:
  /// **'Memory and more'**
  String get menuGamesSub;

  /// groupBasic
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get groupBasic;

  /// groupDakuten
  ///
  /// In en, this message translates to:
  /// **'Dakuten and handakuten'**
  String get groupDakuten;

  /// groupCombined
  ///
  /// In en, this message translates to:
  /// **'Combined'**
  String get groupCombined;

  /// groupBody
  ///
  /// In en, this message translates to:
  /// **'Body parts'**
  String get groupBody;

  /// groupFood
  ///
  /// In en, this message translates to:
  /// **'Food and drinks'**
  String get groupFood;

  /// groupOrgans
  ///
  /// In en, this message translates to:
  /// **'Body organs'**
  String get groupOrgans;

  /// groupColors
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get groupColors;

  /// groupJobs
  ///
  /// In en, this message translates to:
  /// **'Jobs'**
  String get groupJobs;

  /// groupSushi
  ///
  /// In en, this message translates to:
  /// **'Sushi and sides'**
  String get groupSushi;

  /// groupClothes
  ///
  /// In en, this message translates to:
  /// **'Clothes'**
  String get groupClothes;

  /// groupHome
  ///
  /// In en, this message translates to:
  /// **'Home objects'**
  String get groupHome;

  /// groupMusic
  ///
  /// In en, this message translates to:
  /// **'Musical instruments'**
  String get groupMusic;

  /// groupNames
  ///
  /// In en, this message translates to:
  /// **'Famous names'**
  String get groupNames;

  /// groupFruits
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get groupFruits;

  /// groupVeggies
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get groupVeggies;

  /// groupTravel
  ///
  /// In en, this message translates to:
  /// **'Travel and luggage'**
  String get groupTravel;

  /// groupMedicine
  ///
  /// In en, this message translates to:
  /// **'Basic medicine'**
  String get groupMedicine;

  /// groupComputing
  ///
  /// In en, this message translates to:
  /// **'Computing and programming'**
  String get groupComputing;

  /// groupAi
  ///
  /// In en, this message translates to:
  /// **'Artificial intelligence'**
  String get groupAi;

  /// groupKanaSubtitle
  ///
  /// In en, this message translates to:
  /// **'{count} characters · {examples}'**
  String groupKanaSubtitle(int count, String examples);

  /// groupWordsSubtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 word} other{{count} words}}'**
  String groupWordsSubtitle(int count);

  /// groupNamesSubtitle
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 name} other{{count} names}}'**
  String groupNamesSubtitle(int count);

  /// referenceTitle
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get referenceTitle;

  /// referenceCounts
  ///
  /// In en, this message translates to:
  /// **'{total} characters · {mastered} mastered'**
  String referenceCounts(int total, int mastered);

  /// vocabularyTitle
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabularyTitle;

  /// vocabReferenceHeading
  ///
  /// In en, this message translates to:
  /// **'Reference · {name}'**
  String vocabReferenceHeading(String name);

  /// vocabCounts
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 word} other{{count} words}} · {mastered} mastered'**
  String vocabCounts(int count, int mastered);

  /// vocabMenuReferenceSub
  ///
  /// In en, this message translates to:
  /// **'Words and meanings'**
  String get vocabMenuReferenceSub;

  /// vocabMenuPracticeSub
  ///
  /// In en, this message translates to:
  /// **'Pick the right answer'**
  String get vocabMenuPracticeSub;

  /// wordSearchName
  ///
  /// In en, this message translates to:
  /// **'Word search'**
  String get wordSearchName;

  /// wordSearchSub
  ///
  /// In en, this message translates to:
  /// **'Find the words'**
  String get wordSearchSub;

  /// modeKanaToRomaji
  ///
  /// In en, this message translates to:
  /// **'{script} → Romaji'**
  String modeKanaToRomaji(String script);

  /// modeRomajiToKana
  ///
  /// In en, this message translates to:
  /// **'Romaji → {script}'**
  String modeRomajiToKana(String script);

  /// modeScriptSwap
  ///
  /// In en, this message translates to:
  /// **'{from} → {to}'**
  String modeScriptSwap(String from, String to);

  /// modeWordToMeaning
  ///
  /// In en, this message translates to:
  /// **'{script} → English'**
  String modeWordToMeaning(String script);

  /// modeMeaningToWord
  ///
  /// In en, this message translates to:
  /// **'English → {script}'**
  String modeMeaningToWord(String script);

  /// setupFlashcards
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get setupFlashcards;

  /// setupPractice
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get setupPractice;

  /// setupWhatToPractice
  ///
  /// In en, this message translates to:
  /// **'WHAT DO YOU WANT TO PRACTICE'**
  String get setupWhatToPractice;

  /// multiSelect
  ///
  /// In en, this message translates to:
  /// **'Multiple selection'**
  String get multiSelect;

  /// multiSelectSub
  ///
  /// In en, this message translates to:
  /// **'9 characters in 3 blocks of 3'**
  String get multiSelectSub;

  /// comboBang
  ///
  /// In en, this message translates to:
  /// **'Combo x{n}!'**
  String comboBang(int n);

  /// masteredBang
  ///
  /// In en, this message translates to:
  /// **'Mastered!'**
  String get masteredBang;

  /// modeSectionLabel
  ///
  /// In en, this message translates to:
  /// **'MODE'**
  String get modeSectionLabel;

  /// practiceTag
  ///
  /// In en, this message translates to:
  /// **'PRACTICE · STROKES'**
  String get practiceTag;

  /// practiceDrawPrompt
  ///
  /// In en, this message translates to:
  /// **'Draw the {script} for'**
  String practiceDrawPrompt(String script);

  /// practiceCheck
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get practiceCheck;

  /// practiceHowDidYouDo
  ///
  /// In en, this message translates to:
  /// **'How did you do?'**
  String get practiceHowDidYouDo;

  /// practiceReview
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get practiceReview;

  /// practiceGotIt
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get practiceGotIt;

  /// practiceYourStroke
  ///
  /// In en, this message translates to:
  /// **'YOUR STROKES'**
  String get practiceYourStroke;

  /// practiceCompare
  ///
  /// In en, this message translates to:
  /// **'Compare the order and shape of the strokes'**
  String get practiceCompare;

  /// verdictGreat
  ///
  /// In en, this message translates to:
  /// **'Very good'**
  String get verdictGreat;

  /// verdictClose
  ///
  /// In en, this message translates to:
  /// **'Almost, check the shape'**
  String get verdictClose;

  /// verdictReview
  ///
  /// In en, this message translates to:
  /// **'Review the strokes'**
  String get verdictReview;

  /// similarity
  ///
  /// In en, this message translates to:
  /// **'{pct}% match · {label}'**
  String similarity(int pct, String label);

  /// learnTag
  ///
  /// In en, this message translates to:
  /// **'LEARN · {i}/{n}'**
  String learnTag(int i, int n);

  /// hideGuide
  ///
  /// In en, this message translates to:
  /// **'Hide guide'**
  String get hideGuide;

  /// showGuide
  ///
  /// In en, this message translates to:
  /// **'Show guide'**
  String get showGuide;

  /// viewStrokes
  ///
  /// In en, this message translates to:
  /// **'Show strokes'**
  String get viewStrokes;

  /// gamesTitle
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get gamesTitle;

  /// gamesTitleModule
  ///
  /// In en, this message translates to:
  /// **'Games · {module}'**
  String gamesTitleModule(String module);

  /// memoryName
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memoryName;

  /// memorySub
  ///
  /// In en, this message translates to:
  /// **'Find the pairs'**
  String get memorySub;

  /// buildName
  ///
  /// In en, this message translates to:
  /// **'Build the word'**
  String get buildName;

  /// buildSub
  ///
  /// In en, this message translates to:
  /// **'Put the characters in order'**
  String get buildSub;

  /// memoryTag
  ///
  /// In en, this message translates to:
  /// **'MEMORY'**
  String get memoryTag;

  /// buildTag
  ///
  /// In en, this message translates to:
  /// **'BUILD THE WORD'**
  String get buildTag;

  /// wordSearchTag
  ///
  /// In en, this message translates to:
  /// **'WORD SEARCH'**
  String get wordSearchTag;

  /// gameKindCharacters
  ///
  /// In en, this message translates to:
  /// **'Characters'**
  String get gameKindCharacters;

  /// gameKindVocabulary
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get gameKindVocabulary;

  /// gameSection
  ///
  /// In en, this message translates to:
  /// **'SECTION'**
  String get gameSection;

  /// newWordSearch
  ///
  /// In en, this message translates to:
  /// **'New search'**
  String get newWordSearch;

  /// findLabel
  ///
  /// In en, this message translates to:
  /// **'FIND · {found}/{total}'**
  String findLabel(int found, int total);

  /// foundAll
  ///
  /// In en, this message translates to:
  /// **'You found them all!'**
  String get foundAll;

  /// settingsDailyGoal
  ///
  /// In en, this message translates to:
  /// **'DAILY GOAL'**
  String get settingsDailyGoal;

  /// settingsGoalMinutes
  ///
  /// In en, this message translates to:
  /// **'{n} minutes a day'**
  String settingsGoalMinutes(int n);

  /// settingsGoalHint
  ///
  /// In en, this message translates to:
  /// **'The ring on Home fills with your practice time.'**
  String get settingsGoalHint;

  /// settingsGoalSlider
  ///
  /// In en, this message translates to:
  /// **'{n} min'**
  String settingsGoalSlider(int n);

  /// settingsRoundSize
  ///
  /// In en, this message translates to:
  /// **'ROUND SIZE'**
  String get settingsRoundSize;

  /// settingsCards
  ///
  /// In en, this message translates to:
  /// **'{n} cards'**
  String settingsCards(int n);

  /// settingsRoundHint
  ///
  /// In en, this message translates to:
  /// **'How many cards each Flashcards and Practice round has.'**
  String get settingsRoundHint;

  /// settingsFeedback
  ///
  /// In en, this message translates to:
  /// **'FEEDBACK'**
  String get settingsFeedback;

  /// settingsVibration
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get settingsVibration;

  /// settingsVibrationSub
  ///
  /// In en, this message translates to:
  /// **'On correct answers, combos and mastery'**
  String get settingsVibrationSub;

  /// settingsEffects
  ///
  /// In en, this message translates to:
  /// **'Celebrations and animations'**
  String get settingsEffects;

  /// settingsEffectsSub
  ///
  /// In en, this message translates to:
  /// **'Confetti when you finish rounds and goals'**
  String get settingsEffectsSub;

  /// settingsMascot
  ///
  /// In en, this message translates to:
  /// **'Show mascot'**
  String get settingsMascot;

  /// settingsMascotSub
  ///
  /// In en, this message translates to:
  /// **'The cat that keeps you company and cheers'**
  String get settingsMascotSub;

  /// settingsVersion
  ///
  /// In en, this message translates to:
  /// **'Version {v}'**
  String settingsVersion(String v);

  /// settingsCredit
  ///
  /// In en, this message translates to:
  /// **'Kanji data: KANJIDIC2 (EDRDG, CC BY-SA 4.0). Stroke order: KanjiVG (CC BY-SA 3.0)'**
  String get settingsCredit;

  /// practiceCorrect
  ///
  /// In en, this message translates to:
  /// **'CORRECT'**
  String get practiceCorrect;

  /// settingsSound
  ///
  /// In en, this message translates to:
  /// **'Shamisen sounds'**
  String get settingsSound;

  /// settingsSoundSub
  ///
  /// In en, this message translates to:
  /// **'Soft plucks on taps, answers and goals'**
  String get settingsSoundSub;

  /// soundOnLabel
  ///
  /// In en, this message translates to:
  /// **'Sound on'**
  String get soundOnLabel;

  /// soundOffLabel
  ///
  /// In en, this message translates to:
  /// **'Sound off'**
  String get soundOffLabel;

  /// continueTitle
  ///
  /// In en, this message translates to:
  /// **'Continue where you left off'**
  String get continueTitle;

  /// continueStart
  ///
  /// In en, this message translates to:
  /// **'Start studying'**
  String get continueStart;

  /// greetMorning
  ///
  /// In en, this message translates to:
  /// **'おはよう'**
  String get greetMorning;

  /// greetDay
  ///
  /// In en, this message translates to:
  /// **'こんにちは'**
  String get greetDay;

  /// greetEvening
  ///
  /// In en, this message translates to:
  /// **'こんばんは'**
  String get greetEvening;

  /// minOfGoal
  ///
  /// In en, this message translates to:
  /// **'of {goal} min'**
  String minOfGoal(int goal);

  /// modulesLabel
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesLabel;

  /// comingSoonShort
  ///
  /// In en, this message translates to:
  /// **'SOON'**
  String get comingSoonShort;

  /// groupGrade1
  ///
  /// In en, this message translates to:
  /// **'Grade 1'**
  String get groupGrade1;

  /// groupNumbers
  ///
  /// In en, this message translates to:
  /// **'Numbers'**
  String get groupNumbers;

  /// groupNature
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get groupNature;

  /// groupBodyPeople
  ///
  /// In en, this message translates to:
  /// **'Body and people'**
  String get groupBodyPeople;

  /// groupSchool
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get groupSchool;

  /// groupTimeDays
  ///
  /// In en, this message translates to:
  /// **'Time and days'**
  String get groupTimeDays;

  /// groupAnimalsColors
  ///
  /// In en, this message translates to:
  /// **'Animals and colors'**
  String get groupAnimalsColors;

  /// kanjiMeaning
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get kanjiMeaning;

  /// kanjiOnReadings
  ///
  /// In en, this message translates to:
  /// **'On readings'**
  String get kanjiOnReadings;

  /// kanjiKunReadings
  ///
  /// In en, this message translates to:
  /// **'Kun readings'**
  String get kanjiKunReadings;

  /// kanjiNoReadings
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get kanjiNoReadings;

  /// kanjiStrokeCount
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 stroke} other{{count} strokes}}'**
  String kanjiStrokeCount(int count);

  /// kanjiGradeLabel
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String kanjiGradeLabel(int grade);

  /// kanjiListen
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get kanjiListen;

  /// modeKanjiToMeaning
  ///
  /// In en, this message translates to:
  /// **'Kanji → English'**
  String get modeKanjiToMeaning;

  /// modeMeaningToKanji
  ///
  /// In en, this message translates to:
  /// **'English → Kanji'**
  String get modeMeaningToKanji;

  /// modeKanjiToReading
  ///
  /// In en, this message translates to:
  /// **'Kanji → Reading'**
  String get modeKanjiToReading;

  /// quizReadingKun
  ///
  /// In en, this message translates to:
  /// **'Kun reading'**
  String get quizReadingKun;

  /// quizReadingOn
  ///
  /// In en, this message translates to:
  /// **'On reading'**
  String get quizReadingOn;

  /// practiceDrawKanji
  ///
  /// In en, this message translates to:
  /// **'Draw the kanji for'**
  String get practiceDrawKanji;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
