// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ProgramIT';

  @override
  String get kampprogramSubtitle => 'MATCH SCHEDULE';

  @override
  String get hintEnterCode => 'enter code';

  @override
  String get searchByCode => 'Search by code';

  @override
  String get searchNearby => 'Search nearby';

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageNorwegian => 'NO';

  @override
  String get languageToggleHint => 'Switch language';

  @override
  String get errorGpsDisabled => 'GPS is not enabled';

  @override
  String get errorGpsPermissionDenied => 'GPS permission denied';

  @override
  String errorGpsPosition(String error) {
    return 'Could not get GPS position: $error';
  }

  @override
  String get snackNoGps => 'Could not get GPS position';

  @override
  String get snackNoMatchesNearby => 'No matches found nearby';

  @override
  String snackFoundSchedules(int count) {
    return 'Found $count match schedules';
  }

  @override
  String snackSearchFailed(String error) {
    return 'Search failed: $error';
  }

  @override
  String get snackEnterCode => 'Please enter a code';

  @override
  String snackNoMatchesForCode(String code) {
    return 'No matches found for code: $code';
  }

  @override
  String get snackFacebookError => 'Could not open Facebook group';

  @override
  String get emptySearchPrompt => 'Search for matches by code or GPS';

  @override
  String get labelMatch => 'MATCH';

  @override
  String get labelEvent => 'EVENT';

  @override
  String get tapForDetails => 'Tap for details';

  @override
  String get tooltipDirections => 'Directions';

  @override
  String get tooltipChat => 'Chat';

  @override
  String get tooltipSettings => 'Settings';

  @override
  String get taglineAnotherMatch => 'Time for another match!';

  @override
  String get viewMatchSchedule => 'VIEW MATCH SCHEDULE';

  @override
  String get chooseUsername => 'Choose a username';

  @override
  String get hintYourName => 'Enter your name…';

  @override
  String get ok => 'OK';

  @override
  String sendMessageFailed(String error) {
    return 'Could not send message: $error';
  }

  @override
  String get timeAt => 'at';

  @override
  String get changeUsernameTooltip => 'Change username';

  @override
  String chatAs(String name) {
    return 'Chat as: $name';
  }

  @override
  String get chatLoadFailed => 'Could not load chat';

  @override
  String get chatSignInRequired =>
      'Could not sign in for chat. Check your connection, Firebase project settings, and that Anonymous sign-in is enabled. Firestore rules must allow signed-in users to read this room.';

  @override
  String errorWithDetails(String error) {
    return 'Error: $error';
  }

  @override
  String get noMessagesYet => 'No messages yet';

  @override
  String get beFirstToWrite => 'Be the first to write!';

  @override
  String get hintWriteMessage => 'Write a message…';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get nicknameRequired => 'Please enter a nickname';

  @override
  String get settingsSaved => 'Settings saved!';

  @override
  String get privacyDialogTitle => 'Privacy / GDPR';

  @override
  String get close => 'Close';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get fontSizeLabel => 'Font size';

  @override
  String get save => 'Save';

  @override
  String get privacyFooter => 'Privacy / GDPR';

  @override
  String get privacyIntroTitle => '1. Introduction';

  @override
  String get privacyIntroBody =>
      'This app respects your privacy. We only collect and store data necessary to provide app functionality.\n\nBy using the app you agree that data is processed as described in this privacy policy.';

  @override
  String get privacyStoredTitle => '2. What information is stored';

  @override
  String get privacyStoredBody =>
      'The app may store:\n• Chat messages you send\n• Message timestamps\n\nWe do not store more information than necessary to provide the service.';

  @override
  String get privacyUseTitle => '3. How information is used';

  @override
  String get privacyUseBody =>
      'Information is used only to provide the in-app chat feature. It is not used for advertising or marketing.';

  @override
  String get privacyStorageTitle => '4. Data storage';

  @override
  String get privacyStorageBody =>
      'Data is stored in Cloud Firestore (Google Firebase). Google may process data according to its security and privacy policies.';

  @override
  String get privacySharingTitle => '5. Sharing information';

  @override
  String get privacySharingBody =>
      'We do not share your personal information with third parties.';

  @override
  String get privacySecurityTitle => '6. Security';

  @override
  String get privacySecurityBody =>
      'We work to protect your data using secure systems and access control to the database.';

  @override
  String get privacyRightsTitle => '7. Your rights';

  @override
  String get privacyRightsBody =>
      'You have the right to:\n• receive information about what data is stored\n• request deletion of your data\n• stop using the service';

  @override
  String get privacyContactTitle => '9. Contact';

  @override
  String get privacyContactBody =>
      'Privacy questions can be sent to:\nbestilling@programmit.no';

  @override
  String get mapDirectionsTitle => 'Directions';

  @override
  String get mapYourPosition => 'Your position';

  @override
  String get mapStartNavTooltip => 'Start navigation';

  @override
  String get mapStartNavigation => 'START NAVIGATION';

  @override
  String get mapTransportCar => 'Car';

  @override
  String get mapTransportWalk => 'Walk';

  @override
  String get mapTransportBus => 'Bus';

  @override
  String get mapTransportBike => 'Bike';
}
