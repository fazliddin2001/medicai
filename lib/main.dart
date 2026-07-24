import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:medicai/l10n/app_localizations.dart';

import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/theme.dart';
import 'package:medicai/ui/main_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: const MedicAiApp(),
    ),
  );
}

class MedicAiApp extends StatelessWidget {
  const MedicAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return MaterialApp(
      title: 'MedicAI',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: state.currentLocale, // Dynamically updates locale
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uz', ''), 
        Locale('ru', ''),
        Locale('en', ''),
      ],
      home: const MainLayout(),
    );
  }
}
