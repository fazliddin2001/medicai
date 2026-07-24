import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In uz, this message translates to:
  /// **'MedicAI'**
  String get appTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In uz, this message translates to:
  /// **'MedicAI-ga xush kelibsiz'**
  String get welcomeMessage;

  /// No description provided for @modeSelector.
  ///
  /// In uz, this message translates to:
  /// **'Rejimni tanlang'**
  String get modeSelector;

  /// No description provided for @webApiMode.
  ///
  /// In uz, this message translates to:
  /// **'Veb API'**
  String get webApiMode;

  /// No description provided for @cloudIntelligence.
  ///
  /// In uz, this message translates to:
  /// **'(Bulutli intellekt)'**
  String get cloudIntelligence;

  /// No description provided for @webApiDesc.
  ///
  /// In uz, this message translates to:
  /// **'Keng ko\'lamli. Murakkab masalalar va ko\'proq ma\'lumot olish uchun ilg\'or bulutli modellardan foydalaning.'**
  String get webApiDesc;

  /// No description provided for @onDeviceMode.
  ///
  /// In uz, this message translates to:
  /// **'Qurilmadagi sun\'iy intellekt'**
  String get onDeviceMode;

  /// No description provided for @localPrivacy.
  ///
  /// In uz, this message translates to:
  /// **'(100% Maxfiy)'**
  String get localPrivacy;

  /// No description provided for @onDeviceDesc.
  ///
  /// In uz, this message translates to:
  /// **'Barqaror va ishonchli. Barcha amallar mahalliy tarzda bajarilib, ma\'lumotlar xavfsizligi ta\'minlanadi.'**
  String get onDeviceDesc;

  /// No description provided for @connected.
  ///
  /// In uz, this message translates to:
  /// **'Ulangan'**
  String get connected;

  /// No description provided for @ready.
  ///
  /// In uz, this message translates to:
  /// **'Tayyor'**
  String get ready;

  /// No description provided for @cloudApiMode.
  ///
  /// In uz, this message translates to:
  /// **'⚡ Bulutli API rejimi'**
  String get cloudApiMode;

  /// No description provided for @localApiMode.
  ///
  /// In uz, this message translates to:
  /// **'🛡️ Mahalliy rejim'**
  String get localApiMode;

  /// No description provided for @cloudInfo.
  ///
  /// In uz, this message translates to:
  /// **'Bulutli mantiqiy dvigatelga ulangan. Maxfiylik boshqaruvi biroz yumshatilgan.'**
  String get cloudInfo;

  /// No description provided for @localInfo.
  ///
  /// In uz, this message translates to:
  /// **'Mahalliy mantiqiy dvigatelga ulangan. Barcha ma\'lumotlar qurilmada qoladi.'**
  String get localInfo;

  /// No description provided for @messageHint.
  ///
  /// In uz, this message translates to:
  /// **'Xabar yoki audio yozing...'**
  String get messageHint;

  /// No description provided for @settings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settings;

  /// No description provided for @gatewayUrl.
  ///
  /// In uz, this message translates to:
  /// **'Gateway URL manzili'**
  String get gatewayUrl;

  /// No description provided for @modelPath.
  ///
  /// In uz, this message translates to:
  /// **'Model fayli yo\'li'**
  String get modelPath;

  /// No description provided for @save.
  ///
  /// In uz, this message translates to:
  /// **'Saqlash'**
  String get save;

  /// No description provided for @pickModel.
  ///
  /// In uz, this message translates to:
  /// **'Modelni tanlang'**
  String get pickModel;

  /// No description provided for @downloadModel.
  ///
  /// In uz, this message translates to:
  /// **'Modelni yuklab olish'**
  String get downloadModel;
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
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
