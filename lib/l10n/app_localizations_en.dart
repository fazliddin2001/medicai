// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MedicAI';

  @override
  String get welcomeMessage => 'Welcome to MedicAI';

  @override
  String get modeSelector => 'Mode Selector';

  @override
  String get webApiMode => 'Web API';

  @override
  String get cloudIntelligence => '(Cloud Intelligence)';

  @override
  String get webApiDesc =>
      'Expansive and fluid. Harness advanced cloud-based models for complex problem solving and broader knowledge access.';

  @override
  String get onDeviceMode => 'On-Device AI';

  @override
  String get localPrivacy => '(100% Private)';

  @override
  String get onDeviceDesc =>
      'Stoic and reliable. All operations are executed locally ensuring maximum data integrity and zero external exposure.';

  @override
  String get connected => 'Connected';

  @override
  String get ready => 'Ready';

  @override
  String get cloudApiMode => '⚡ Cloud API Mode';

  @override
  String get localApiMode => '🛡️ Local AI Mode';

  @override
  String get cloudInfo =>
      'Connected to Cloud Inference Engine. Privacy controls relaxed.';

  @override
  String get localInfo =>
      'Connected to Local Inference Engine. All operations are strictly on-device.';

  @override
  String get messageHint => 'Message or record audio...';

  @override
  String get settings => 'Settings';

  @override
  String get gatewayUrl => 'Gateway URL';

  @override
  String get modelPath => 'Model Path';

  @override
  String get save => 'Save';

  @override
  String get pickModel => 'Pick Model';

  @override
  String get downloadModel => 'Download Model';
}
