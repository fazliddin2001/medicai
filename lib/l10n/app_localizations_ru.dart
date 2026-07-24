// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'MedicAI';

  @override
  String get welcomeMessage => 'Добро пожаловать в MedicAI';

  @override
  String get modeSelector => 'Выберите режим';

  @override
  String get webApiMode => 'Веб API';

  @override
  String get cloudIntelligence => '(Облачный интеллект)';

  @override
  String get webApiDesc =>
      'Масштабный и гибкий. Используйте передовые облачные модели для решения сложных задач.';

  @override
  String get onDeviceMode => 'Локальный ИИ';

  @override
  String get localPrivacy => '(100% Конфиденциально)';

  @override
  String get onDeviceDesc =>
      'Надежно и безопасно. Все операции выполняются локально для максимальной защиты данных.';

  @override
  String get connected => 'Подключено';

  @override
  String get ready => 'Готов';

  @override
  String get cloudApiMode => '⚡ Режим облачного API';

  @override
  String get localApiMode => '🛡️ Локальный режим';

  @override
  String get cloudInfo =>
      'Подключено к облачному ИИ. Контроль конфиденциальности снижен.';

  @override
  String get localInfo =>
      'Подключено к локальному ИИ. Все данные остаются на устройстве.';

  @override
  String get messageHint => 'Сообщение или аудио...';

  @override
  String get settings => 'Настройки';

  @override
  String get gatewayUrl => 'URL шлюза';

  @override
  String get modelPath => 'Путь к модели';

  @override
  String get save => 'Сохранить';

  @override
  String get pickModel => 'Выбрать модель';

  @override
  String get downloadModel => 'Скачать модель';
}
