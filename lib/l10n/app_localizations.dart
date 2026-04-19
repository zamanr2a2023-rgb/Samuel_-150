import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_nb.dart';

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
    Locale('nb')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'ProgramIT'**
  String get appTitle;

  /// No description provided for @kampprogramSubtitle.
  ///
  /// In en, this message translates to:
  /// **'MATCH SCHEDULE'**
  String get kampprogramSubtitle;

  /// No description provided for @hintEnterCode.
  ///
  /// In en, this message translates to:
  /// **'enter code'**
  String get hintEnterCode;

  /// No description provided for @searchByCode.
  ///
  /// In en, this message translates to:
  /// **'Search by code'**
  String get searchByCode;

  /// No description provided for @searchNearby.
  ///
  /// In en, this message translates to:
  /// **'Search nearby'**
  String get searchNearby;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get languageEnglish;

  /// No description provided for @languageNorwegian.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get languageNorwegian;

  /// No description provided for @languageToggleHint.
  ///
  /// In en, this message translates to:
  /// **'Switch language'**
  String get languageToggleHint;

  /// No description provided for @errorGpsDisabled.
  ///
  /// In en, this message translates to:
  /// **'GPS is not enabled'**
  String get errorGpsDisabled;

  /// No description provided for @errorGpsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'GPS permission denied'**
  String get errorGpsPermissionDenied;

  /// No description provided for @errorGpsPosition.
  ///
  /// In en, this message translates to:
  /// **'Could not get GPS position: {error}'**
  String errorGpsPosition(String error);

  /// No description provided for @snackNoGps.
  ///
  /// In en, this message translates to:
  /// **'Could not get GPS position'**
  String get snackNoGps;

  /// No description provided for @snackNoMatchesNearby.
  ///
  /// In en, this message translates to:
  /// **'No matches found nearby'**
  String get snackNoMatchesNearby;

  /// No description provided for @snackFoundSchedules.
  ///
  /// In en, this message translates to:
  /// **'Found {count} match schedules'**
  String snackFoundSchedules(int count);

  /// No description provided for @snackSearchFailed.
  ///
  /// In en, this message translates to:
  /// **'Search failed: {error}'**
  String snackSearchFailed(String error);

  /// No description provided for @snackEnterCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter a code'**
  String get snackEnterCode;

  /// No description provided for @snackNoMatchesForCode.
  ///
  /// In en, this message translates to:
  /// **'No matches found for code: {code}'**
  String snackNoMatchesForCode(String code);

  /// No description provided for @snackFacebookError.
  ///
  /// In en, this message translates to:
  /// **'Could not open Facebook group'**
  String get snackFacebookError;

  /// No description provided for @emptySearchPrompt.
  ///
  /// In en, this message translates to:
  /// **'Search for matches by code or GPS'**
  String get emptySearchPrompt;

  /// No description provided for @labelMatch.
  ///
  /// In en, this message translates to:
  /// **'MATCH'**
  String get labelMatch;

  /// No description provided for @labelEvent.
  ///
  /// In en, this message translates to:
  /// **'EVENT'**
  String get labelEvent;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap for details'**
  String get tapForDetails;

  /// No description provided for @tooltipDirections.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get tooltipDirections;

  /// No description provided for @tooltipChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get tooltipChat;

  /// No description provided for @tooltipSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tooltipSettings;

  /// No description provided for @taglineAnotherMatch.
  ///
  /// In en, this message translates to:
  /// **'Time for another match!'**
  String get taglineAnotherMatch;

  /// No description provided for @viewMatchSchedule.
  ///
  /// In en, this message translates to:
  /// **'VIEW MATCH SCHEDULE'**
  String get viewMatchSchedule;

  /// No description provided for @chooseUsername.
  ///
  /// In en, this message translates to:
  /// **'Choose a username'**
  String get chooseUsername;

  /// No description provided for @hintYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name…'**
  String get hintYourName;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @sendMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send message: {error}'**
  String sendMessageFailed(String error);

  /// No description provided for @timeAt.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get timeAt;

  /// No description provided for @changeUsernameTooltip.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get changeUsernameTooltip;

  /// No description provided for @chatAs.
  ///
  /// In en, this message translates to:
  /// **'Chat as: {name}'**
  String chatAs(String name);

  /// No description provided for @chatLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load chat'**
  String get chatLoadFailed;

  /// No description provided for @chatSignInRequired.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in for chat. Check your connection, Firebase project settings, and that Anonymous sign-in is enabled. Firestore rules must allow signed-in users to read this room.'**
  String get chatSignInRequired;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(String error);

  /// No description provided for @noMessagesYet.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get noMessagesYet;

  /// No description provided for @beFirstToWrite.
  ///
  /// In en, this message translates to:
  /// **'Be the first to write!'**
  String get beFirstToWrite;

  /// No description provided for @hintWriteMessage.
  ///
  /// In en, this message translates to:
  /// **'Write a message…'**
  String get hintWriteMessage;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @nicknameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a nickname'**
  String get nicknameRequired;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved!'**
  String get settingsSaved;

  /// No description provided for @privacyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy / GDPR'**
  String get privacyDialogTitle;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @fontSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSizeLabel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @privacyFooter.
  ///
  /// In en, this message translates to:
  /// **'Privacy / GDPR'**
  String get privacyFooter;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'This app respects your privacy. We only collect and store data necessary to provide app functionality.\n\nBy using the app you agree that data is processed as described in this privacy policy.'**
  String get privacyIntroBody;

  /// No description provided for @privacyStoredTitle.
  ///
  /// In en, this message translates to:
  /// **'2. What information is stored'**
  String get privacyStoredTitle;

  /// No description provided for @privacyStoredBody.
  ///
  /// In en, this message translates to:
  /// **'The app may store:\n• Chat messages you send\n• Message timestamps\n\nWe do not store more information than necessary to provide the service.'**
  String get privacyStoredBody;

  /// No description provided for @privacyUseTitle.
  ///
  /// In en, this message translates to:
  /// **'3. How information is used'**
  String get privacyUseTitle;

  /// No description provided for @privacyUseBody.
  ///
  /// In en, this message translates to:
  /// **'Information is used only to provide the in-app chat feature. It is not used for advertising or marketing.'**
  String get privacyUseBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data storage'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Data is stored in Cloud Firestore (Google Firebase). Google may process data according to its security and privacy policies.'**
  String get privacyStorageBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Sharing information'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We do not share your personal information with third parties.'**
  String get privacySharingBody;

  /// No description provided for @privacySecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Security'**
  String get privacySecurityTitle;

  /// No description provided for @privacySecurityBody.
  ///
  /// In en, this message translates to:
  /// **'We work to protect your data using secure systems and access control to the database.'**
  String get privacySecurityBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Your rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'You have the right to:\n• receive information about what data is stored\n• request deletion of your data\n• stop using the service'**
  String get privacyRightsBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'9. Contact'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy questions can be sent to:\nbestilling@programmit.no'**
  String get privacyContactBody;

  /// No description provided for @mapDirectionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get mapDirectionsTitle;

  /// No description provided for @mapYourPosition.
  ///
  /// In en, this message translates to:
  /// **'Your position'**
  String get mapYourPosition;

  /// No description provided for @mapStartNavTooltip.
  ///
  /// In en, this message translates to:
  /// **'Start navigation'**
  String get mapStartNavTooltip;

  /// No description provided for @mapStartNavigation.
  ///
  /// In en, this message translates to:
  /// **'START NAVIGATION'**
  String get mapStartNavigation;

  /// No description provided for @mapTransportCar.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get mapTransportCar;

  /// No description provided for @mapTransportWalk.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get mapTransportWalk;

  /// No description provided for @mapTransportBus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get mapTransportBus;

  /// No description provided for @mapTransportBike.
  ///
  /// In en, this message translates to:
  /// **'Bike'**
  String get mapTransportBike;
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
      <String>['en', 'nb'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'nb':
      return AppLocalizationsNb();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
