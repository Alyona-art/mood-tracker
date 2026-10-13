// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mood Calendar`
  String get moodCalendar {
    return Intl.message(
      'Mood Calendar',
      name: 'moodCalendar',
      desc: '',
      args: [],
    );
  }

  /// `Error: {message}`
  String error(Object message) {
    return Intl.message(
      'Error: $message',
      name: 'error',
      desc: 'Error message with parameter',
      args: [message],
    );
  }

  /// `Emotion Settings`
  String get emotionSettings {
    return Intl.message(
      'Emotion Settings',
      name: 'emotionSettings',
      desc: '',
      args: [],
    );
  }

  /// `Delete emotion?`
  String get deleteEmotion {
    return Intl.message(
      'Delete emotion?',
      name: 'deleteEmotion',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this emotion?`
  String get deleteEmotionConfirmation {
    return Intl.message(
      'Are you sure you want to delete this emotion?',
      name: 'deleteEmotionConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add emotion`
  String get addEmotion {
    return Intl.message(
      'Add emotion',
      name: 'addEmotion',
      desc: '',
      args: [],
    );
  }

  /// `Edit emotion`
  String get editEmotion {
    return Intl.message(
      'Edit emotion',
      name: 'editEmotion',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get id {
    return Intl.message(
      'ID',
      name: 'id',
      desc: '',
      args: [],
    );
  }

  /// `happy`
  String get idHint {
    return Intl.message(
      'happy',
      name: 'idHint',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Happy`
  String get nameHint {
    return Intl.message(
      'Happy',
      name: 'nameHint',
      desc: '',
      args: [],
    );
  }

  /// `Color:`
  String get color {
    return Intl.message(
      'Color:',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Ecstatic`
  String get emotionEcstatic {
    return Intl.message(
      'Ecstatic',
      name: 'emotionEcstatic',
      desc: '',
      args: [],
    );
  }

  /// `Festive`
  String get emotionFestive {
    return Intl.message(
      'Festive',
      name: 'emotionFestive',
      desc: '',
      args: [],
    );
  }

  /// `Surprised`
  String get emotionSurprised {
    return Intl.message(
      'Surprised',
      name: 'emotionSurprised',
      desc: '',
      args: [],
    );
  }

  /// `Excited`
  String get emotionExcited {
    return Intl.message(
      'Excited',
      name: 'emotionExcited',
      desc: '',
      args: [],
    );
  }

  /// `Optimistic`
  String get emotionOptimistic {
    return Intl.message(
      'Optimistic',
      name: 'emotionOptimistic',
      desc: '',
      args: [],
    );
  }

  /// `Energized`
  String get emotionEnergized {
    return Intl.message(
      'Energized',
      name: 'emotionEnergized',
      desc: '',
      args: [],
    );
  }

  /// `Blissful`
  String get emotionBlissful {
    return Intl.message(
      'Blissful',
      name: 'emotionBlissful',
      desc: '',
      args: [],
    );
  }

  /// `Proud`
  String get emotionProud {
    return Intl.message(
      'Proud',
      name: 'emotionProud',
      desc: '',
      args: [],
    );
  }

  /// `Pleasant`
  String get emotionPleasant {
    return Intl.message(
      'Pleasant',
      name: 'emotionPleasant',
      desc: '',
      args: [],
    );
  }

  /// `Fulfilled`
  String get emotionFulfilled {
    return Intl.message(
      'Fulfilled',
      name: 'emotionFulfilled',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get emotionContent {
    return Intl.message(
      'Content',
      name: 'emotionContent',
      desc: '',
      args: [],
    );
  }

  /// `At Ease`
  String get emotionAtEase {
    return Intl.message(
      'At Ease',
      name: 'emotionAtEase',
      desc: '',
      args: [],
    );
  }

  /// `Balanced`
  String get emotionBalanced {
    return Intl.message(
      'Balanced',
      name: 'emotionBalanced',
      desc: '',
      args: [],
    );
  }

  /// `Blessed`
  String get emotionBlessed {
    return Intl.message(
      'Blessed',
      name: 'emotionBlessed',
      desc: '',
      args: [],
    );
  }

  /// `Relaxed`
  String get emotionRelaxed {
    return Intl.message(
      'Relaxed',
      name: 'emotionRelaxed',
      desc: '',
      args: [],
    );
  }

  /// `Serene`
  String get emotionSerene {
    return Intl.message(
      'Serene',
      name: 'emotionSerene',
      desc: '',
      args: [],
    );
  }

  /// `Tranquil`
  String get emotionTranquil {
    return Intl.message(
      'Tranquil',
      name: 'emotionTranquil',
      desc: '',
      args: [],
    );
  }

  /// `Sleepy`
  String get emotionSleepy {
    return Intl.message(
      'Sleepy',
      name: 'emotionSleepy',
      desc: '',
      args: [],
    );
  }

  /// `Enraged`
  String get emotionEnraged {
    return Intl.message(
      'Enraged',
      name: 'emotionEnraged',
      desc: '',
      args: [],
    );
  }

  /// `Stressed`
  String get emotionStressed {
    return Intl.message(
      'Stressed',
      name: 'emotionStressed',
      desc: '',
      args: [],
    );
  }

  /// `Shocked`
  String get emotionShocked {
    return Intl.message(
      'Shocked',
      name: 'emotionShocked',
      desc: '',
      args: [],
    );
  }

  /// `Fuming`
  String get emotionFuming {
    return Intl.message(
      'Fuming',
      name: 'emotionFuming',
      desc: '',
      args: [],
    );
  }

  /// `Angry`
  String get emotionAngry {
    return Intl.message(
      'Angry',
      name: 'emotionAngry',
      desc: '',
      args: [],
    );
  }

  /// `Restless`
  String get emotionRestless {
    return Intl.message(
      'Restless',
      name: 'emotionRestless',
      desc: '',
      args: [],
    );
  }

  /// `Repulse`
  String get emotionRepulse {
    return Intl.message(
      'Repulse',
      name: 'emotionRepulse',
      desc: '',
      args: [],
    );
  }

  /// `Worried`
  String get emotionWorried {
    return Intl.message(
      'Worried',
      name: 'emotionWorried',
      desc: '',
      args: [],
    );
  }

  /// `Annoyed`
  String get emotionAnnoyed {
    return Intl.message(
      'Annoyed',
      name: 'emotionAnnoyed',
      desc: '',
      args: [],
    );
  }

  /// `Disgusted`
  String get emotionDisgusted {
    return Intl.message(
      'Disgusted',
      name: 'emotionDisgusted',
      desc: '',
      args: [],
    );
  }

  /// `Down`
  String get emotionDown {
    return Intl.message(
      'Down',
      name: 'emotionDown',
      desc: '',
      args: [],
    );
  }

  /// `Apathetic`
  String get emotionApathetic {
    return Intl.message(
      'Apathetic',
      name: 'emotionApathetic',
      desc: '',
      args: [],
    );
  }

  /// `Miserable`
  String get emotionMiserable {
    return Intl.message(
      'Miserable',
      name: 'emotionMiserable',
      desc: '',
      args: [],
    );
  }

  /// `Lonely`
  String get emotionLonely {
    return Intl.message(
      'Lonely',
      name: 'emotionLonely',
      desc: '',
      args: [],
    );
  }

  /// `Tired`
  String get emotionTired {
    return Intl.message(
      'Tired',
      name: 'emotionTired',
      desc: '',
      args: [],
    );
  }

  /// `Despair`
  String get emotionDespair {
    return Intl.message(
      'Despair',
      name: 'emotionDespair',
      desc: '',
      args: [],
    );
  }

  /// `Desolate`
  String get emotionDesolate {
    return Intl.message(
      'Desolate',
      name: 'emotionDesolate',
      desc: '',
      args: [],
    );
  }

  /// `Drained`
  String get emotionDrained {
    return Intl.message(
      'Drained',
      name: 'emotionDrained',
      desc: '',
      args: [],
    );
  }

  /// `how was your energy today?`
  String get howEnergy {
    return Intl.message(
      'how was your energy today?',
      name: 'howEnergy',
      desc: '',
      args: [],
    );
  }

  /// `how pleasant was your day?`
  String get howPleasant {
    return Intl.message(
      'how pleasant was your day?',
      name: 'howPleasant',
      desc: '',
      args: [],
    );
  }

  /// `welcome to {name} and all its possibilities`
  String welcome(String name) {
    return Intl.message(
      'welcome to $name and all its possibilities',
      name: 'welcome',
      desc: 'Welcome message with app name',
      args: [name],
    );
  }

  /// `year`
  String get year {
    return Intl.message(
      'year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message(
      'month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `continue`
  String get continueButton {
    return Intl.message(
      'continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `back`
  String get back {
    return Intl.message(
      'back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `clear`
  String get clear {
    return Intl.message(
      'clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `energy`
  String get energy {
    return Intl.message(
      'energy',
      name: 'energy',
      desc: '',
      args: [],
    );
  }

  /// `high`
  String get high {
    return Intl.message(
      'high',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `low`
  String get low {
    return Intl.message(
      'low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `feeling`
  String get feeling {
    return Intl.message(
      'feeling',
      name: 'feeling',
      desc: '',
      args: [],
    );
  }

  /// `pleasant`
  String get pleasant {
    return Intl.message(
      'pleasant',
      name: 'pleasant',
      desc: '',
      args: [],
    );
  }

  /// `unpleasant`
  String get unpleasant {
    return Intl.message(
      'unpleasant',
      name: 'unpleasant',
      desc: '',
      args: [],
    );
  }

  /// `everything is in your hands`
  String get everythingHands {
    return Intl.message(
      'everything is in your hands',
      name: 'everythingHands',
      desc: '',
      args: [],
    );
  }

  /// `Feel free to customize the corner colors:`
  String get customizeColors {
    return Intl.message(
      'Feel free to customize the corner colors:',
      name: 'customizeColors',
      desc: '',
      args: [],
    );
  }

  /// `reset to default`
  String get resetToDefaults {
    return Intl.message(
      'reset to default',
      name: 'resetToDefaults',
      desc: '',
      args: [],
    );
  }

  /// `save colors`
  String get saveColors {
    return Intl.message(
      'save colors',
      name: 'saveColors',
      desc: '',
      args: [],
    );
  }

  /// `You are collected, alert, and vigilant`
  String get redDescription {
    return Intl.message(
      'You are collected, alert, and vigilant',
      name: 'redDescription',
      desc: '',
      args: [],
    );
  }

  /// `You are ready to create new ideas, feel spiritual uplift, energy, and excitement`
  String get yellowDescription {
    return Intl.message(
      'You are ready to create new ideas, feel spiritual uplift, energy, and excitement',
      name: 'yellowDescription',
      desc: '',
      args: [],
    );
  }

  /// `Emotions that allow you to focus on deduction and critical thinking`
  String get blueDescription {
    return Intl.message(
      'Emotions that allow you to focus on deduction and critical thinking',
      name: 'blueDescription',
      desc: '',
      args: [],
    );
  }

  /// `You are peaceful, attentive, and ready to perceive new information`
  String get greenDescription {
    return Intl.message(
      'You are peaceful, attentive, and ready to perceive new information',
      name: 'greenDescription',
      desc: '',
      args: [],
    );
  }

  /// `Cleaning, hobbies, physical activity`
  String get redAdvice {
    return Intl.message(
      'Cleaning, hobbies, physical activity',
      name: 'redAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Activity, creativity, new projects, work`
  String get yellowAdvice {
    return Intl.message(
      'Activity, creativity, new projects, work',
      name: 'yellowAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Recovery, rest, communication with loved ones, self-care, routine`
  String get blueAdvice {
    return Intl.message(
      'Recovery, rest, communication with loved ones, self-care, routine',
      name: 'blueAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Intellectual work, communication, planning, calm hobbies`
  String get greenAdvice {
    return Intl.message(
      'Intellectual work, communication, planning, calm hobbies',
      name: 'greenAdvice',
      desc: '',
      args: [],
    );
  }

  /// `You can try:`
  String get YouCanTry {
    return Intl.message(
      'You can try:',
      name: 'YouCanTry',
      desc: '',
      args: [],
    );
  }

  /// `Show advice`
  String get showAdvice {
    return Intl.message(
      'Show advice',
      name: 'showAdvice',
      desc: '',
      args: [],
    );
  }

  /// `Display advice for selected mood`
  String get showAdviceDescription {
    return Intl.message(
      'Display advice for selected mood',
      name: 'showAdviceDescription',
      desc: '',
      args: [],
    );
  }

  /// `Show English translations`
  String get showEnglishTranslations {
    return Intl.message(
      'Show English translations',
      name: 'showEnglishTranslations',
      desc: '',
      args: [],
    );
  }

  /// `Display English emotion names in brackets`
  String get showEnglishTranslationsDescription {
    return Intl.message(
      'Display English emotion names in brackets',
      name: 'showEnglishTranslationsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Choose the mood that best matches how you feel:`
  String get chooseMood {
    return Intl.message(
      'Choose the mood that best matches how you feel:',
      name: 'chooseMood',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Mood Tracker`
  String get onboardingPage1Title {
    return Intl.message(
      'Welcome to Mood Tracker',
      name: 'onboardingPage1Title',
      desc: '',
      args: [],
    );
  }

  /// `The emotion map helps track what you're feeling using two parameters: pleasantness of emotions and energy level`
  String get onboardingPage1Description {
    return Intl.message(
      'The emotion map helps track what you\'re feeling using two parameters: pleasantness of emotions and energy level',
      name: 'onboardingPage1Description',
      desc: '',
      args: [],
    );
  }

  /// `Simply select your energy and pleasantness levels. Then choose the mood that best matches your state`
  String get onboardingPage2Description {
    return Intl.message(
      'Simply select your energy and pleasantness levels. Then choose the mood that best matches your state',
      name: 'onboardingPage2Description',
      desc: '',
      args: [],
    );
  }

  /// `Start Your Journey`
  String get onboardingPage3Title {
    return Intl.message(
      'Start Your Journey',
      name: 'onboardingPage3Title',
      desc: '',
      args: [],
    );
  }

  /// `Track your mood daily and analyze changes over the year, but most importantly — remember to listen to yourself and allow yourself to feel.`
  String get onboardingPage3Description {
    return Intl.message(
      'Track your mood daily and analyze changes over the year, but most importantly — remember to listen to yourself and allow yourself to feel.',
      name: 'onboardingPage3Description',
      desc: '',
      args: [],
    );
  }

  /// `get started`
  String get getStarted {
    return Intl.message(
      'get started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Export as Markdown`
  String get exportAsMarkdown {
    return Intl.message(
      'Export as Markdown',
      name: 'exportAsMarkdown',
      desc: '',
      args: [],
    );
  }

  /// `Pick a date range, then share the text`
  String get exportMarkdownDescription {
    return Intl.message(
      'Pick a date range, then share the text',
      name: 'exportMarkdownDescription',
      desc: '',
      args: [],
    );
  }

  /// `No entries in this range`
  String get exportMarkdownNoEntries {
    return Intl.message(
      'No entries in this range',
      name: 'exportMarkdownNoEntries',
      desc: '',
      args: [],
    );
  }

  /// `Energy`
  String get exportMarkdownEnergy {
    return Intl.message(
      'Energy',
      name: 'exportMarkdownEnergy',
      desc: '',
      args: [],
    );
  }

  /// `Feeling`
  String get exportMarkdownFeeling {
    return Intl.message(
      'Feeling',
      name: 'exportMarkdownFeeling',
      desc: '',
      args: [],
    );
  }

  /// `Mood`
  String get exportMarkdownMood {
    return Intl.message(
      'Mood',
      name: 'exportMarkdownMood',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
