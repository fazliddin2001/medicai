// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'MedicAI';

  @override
  String get welcomeMessage => 'MedicAI-ga xush kelibsiz';

  @override
  String get modeSelector => 'Rejimni tanlang';

  @override
  String get webApiMode => 'Veb API';

  @override
  String get cloudIntelligence => '(Bulutli intellekt)';

  @override
  String get webApiDesc =>
      'Keng ko\'lamli. Murakkab masalalar va ko\'proq ma\'lumot olish uchun ilg\'or bulutli modellardan foydalaning.';

  @override
  String get onDeviceMode => 'Qurilmadagi sun\'iy intellekt';

  @override
  String get localPrivacy => '(100% Maxfiy)';

  @override
  String get onDeviceDesc =>
      'Barqaror va ishonchli. Barcha amallar mahalliy tarzda bajarilib, ma\'lumotlar xavfsizligi ta\'minlanadi.';

  @override
  String get connected => 'Ulangan';

  @override
  String get ready => 'Tayyor';

  @override
  String get cloudApiMode => '⚡ Bulutli API rejimi';

  @override
  String get localApiMode => '🛡️ Mahalliy rejim';

  @override
  String get cloudInfo =>
      'Bulutli mantiqiy dvigatelga ulangan. Maxfiylik boshqaruvi biroz yumshatilgan.';

  @override
  String get localInfo =>
      'Mahalliy mantiqiy dvigatelga ulangan. Barcha ma\'lumotlar qurilmada qoladi.';

  @override
  String get messageHint => 'Xabar yoki audio yozing...';

  @override
  String get settings => 'Sozlamalar';

  @override
  String get gatewayUrl => 'Gateway URL manzili';

  @override
  String get modelPath => 'Model fayli yo\'li';

  @override
  String get save => 'Saqlash';

  @override
  String get pickModel => 'Modelni tanlang';

  @override
  String get downloadModel => 'Modelni yuklab olish';
}
