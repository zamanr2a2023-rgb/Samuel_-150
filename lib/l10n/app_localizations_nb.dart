// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get appTitle => 'ProgramIT';

  @override
  String get kampprogramSubtitle => 'KAMPPROGRAM';

  @override
  String get hintEnterCode => 'skriv inn kode';

  @override
  String get searchByCode => 'Søk på kode';

  @override
  String get searchNearby => 'Søk i nærheten';

  @override
  String get languageEnglish => 'EN';

  @override
  String get languageNorwegian => 'NO';

  @override
  String get languageToggleHint => 'Bytt språk';

  @override
  String get errorGpsDisabled => 'GPS er ikke aktivert';

  @override
  String get errorGpsPermissionDenied => 'GPS-tillatelse nektet';

  @override
  String errorGpsPosition(String error) {
    return 'Kunne ikke hente GPS-posisjon: $error';
  }

  @override
  String get snackNoGps => 'Kunne ikke hente GPS-posisjon';

  @override
  String get snackNoMatchesNearby => 'Ingen kamper funnet i nærheten';

  @override
  String snackFoundSchedules(int count) {
    return 'Fant $count kampprogram';
  }

  @override
  String snackSearchFailed(String error) {
    return 'Søk feilet: $error';
  }

  @override
  String get snackEnterCode => 'Vennligst skriv inn en kode';

  @override
  String snackNoMatchesForCode(String code) {
    return 'Ingen kamper funnet med kode: $code';
  }

  @override
  String get snackFacebookError => 'Kunne ikke åpne Facebook-gruppe';

  @override
  String get emptySearchPrompt => 'Søk etter kamper med kode eller GPS';

  @override
  String get labelMatch => 'KAMP';

  @override
  String get labelEvent => 'EVENT';

  @override
  String get tapForDetails => 'Trykk for detaljer';

  @override
  String get tooltipDirections => 'Veibeskrivelse';

  @override
  String get tooltipChat => 'Chat';

  @override
  String get tooltipSettings => 'Innstillinger';

  @override
  String get taglineAnotherMatch => 'Tid for nok en kamp!';

  @override
  String get viewMatchSchedule => 'VIS KAMPPROGRAM';

  @override
  String get chooseUsername => 'Velg brukernavn';

  @override
  String get hintYourName => 'Skriv ditt navn…';

  @override
  String get ok => 'OK';

  @override
  String sendMessageFailed(String error) {
    return 'Kunne ikke sende melding: $error';
  }

  @override
  String get timeAt => 'kl.';

  @override
  String get changeUsernameTooltip => 'Bytt brukernavn';

  @override
  String chatAs(String name) {
    return 'Chat som: $name';
  }

  @override
  String get chatLoadFailed => 'Kunne ikke laste chat';

  @override
  String errorWithDetails(String error) {
    return 'Feil: $error';
  }

  @override
  String get noMessagesYet => 'Ingen meldinger ennå';

  @override
  String get beFirstToWrite => 'Vær den første til å skrive!';

  @override
  String get hintWriteMessage => 'Skriv en melding…';

  @override
  String get anonymous => 'Anonym';

  @override
  String get nicknameRequired => 'Vennligst skriv inn et kallenavn';

  @override
  String get settingsSaved => 'Innstillinger lagret!';

  @override
  String get privacyDialogTitle => 'Personvern / GDPR';

  @override
  String get close => 'Lukk';

  @override
  String get settingsTitle => 'Innstillinger';

  @override
  String get nicknameLabel => 'Kallenavn';

  @override
  String get fontSizeLabel => 'Font størrelse';

  @override
  String get save => 'Lagre';

  @override
  String get privacyFooter => 'Personvern / GDPR';

  @override
  String get privacyIntroTitle => '1. Innledning';

  @override
  String get privacyIntroBody =>
      'Denne appen respekterer ditt personvern. Vi samler kun inn og lagrer data som er nødvendig for å levere funksjonaliteten i appen.\n\nVed å bruke appen godtar du at data behandles slik det beskrives i denne personvernerklæringen.';

  @override
  String get privacyStoredTitle => '2. Hvilke opplysninger som lagres';

  @override
  String get privacyStoredBody =>
      'Appen kan lagre følgende opplysninger:\n• Chatmeldinger du sender\n• Tidspunkt for meldinger\n\nVi lagrer ikke flere opplysninger enn det som er nødvendig for å levere tjenesten.';

  @override
  String get privacyUseTitle => '3. Hvordan opplysningene brukes';

  @override
  String get privacyUseBody =>
      'Opplysningene brukes kun til å levere chat-funksjonen i appen. Opplysningene brukes ikke til reklame eller markedsføring.';

  @override
  String get privacyStorageTitle => '4. Lagring av data';

  @override
  String get privacyStorageBody =>
      'Data lagres i Cloud Firestore, som er en del av Google Firebase. Google kan behandle data i henhold til sine sikkerhets- og personvernregler.';

  @override
  String get privacySharingTitle => '5. Deling av informasjon';

  @override
  String get privacySharingBody =>
      'Vi deler ikke dine personopplysninger med tredjeparter.';

  @override
  String get privacySecurityTitle => '6. Sikkerhet';

  @override
  String get privacySecurityBody =>
      'Vi jobber for å beskytte dine data ved å bruke sikre systemer og tilgangskontroll til databasen.';

  @override
  String get privacyRightsTitle => '7. Dine rettigheter';

  @override
  String get privacyRightsBody =>
      'Du har rett til å:\n• få informasjon om hvilke data som lagres\n• be om at dine data slettes\n• slutte å bruke tjenesten';

  @override
  String get privacyContactTitle => '9. Kontakt';

  @override
  String get privacyContactBody =>
      'Spørsmål om personvern kan sendes til:\nbestilling@programmit.no';

  @override
  String get mapDirectionsTitle => 'Veibeskrivelse';

  @override
  String get mapYourPosition => 'Din posisjon';

  @override
  String get mapStartNavTooltip => 'Start navigasjon';

  @override
  String get mapStartNavigation => 'START NAVIGASJON';

  @override
  String get mapTransportCar => 'Bil';

  @override
  String get mapTransportWalk => 'Gå';

  @override
  String get mapTransportBus => 'Buss';

  @override
  String get mapTransportBike => 'Sykkel';
}
