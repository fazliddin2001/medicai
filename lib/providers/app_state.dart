import 'package:flutter/material.dart';
import 'package:medicai/models/chat_message.dart';
import 'package:medicai/services/ai_engine_interface.dart';
import 'package:medicai/services/local_model_engine.dart';
import 'package:medicai/services/web_api_engine.dart';
import 'package:medicai/data/database.dart';
import 'package:drift/drift.dart' as drift;

class AppState extends ChangeNotifier {
  bool isLocalMode = false;
  AIEngine? _engine;
  List<ChatMessage> chatHistory = [];
  bool isInitializing = false;
  String? initError;
  bool _cancelRequested = false;
  late final AppDatabase db;

  AppState() {
    db = AppDatabase();
  }

  // Language/Locale
  Locale currentLocale = const Locale('uz', '');

  void setLocale(Locale locale) {
    if (currentLocale != locale) {
      currentLocale = locale;
      notifyListeners();
    }
  }

  // Settings
  String gatewayUrl = 'https://api.openai.com/v1'; // Default or user provided
  String apiKey = 'sk-debug-key';
  String modelPath = '';
  
  // Storage usage mock for UI
  String storageUsed = '3.0 GB';

  Future<void> setMode(bool local) async {
    isLocalMode = local;
    isInitializing = true;
    initError = null;
    notifyListeners();

    await _engine?.dispose();
    
    try {
      if (isLocalMode) {
        if (modelPath.isEmpty) {
          throw Exception("Model path is empty. Please select a model in settings.");
        }
        _engine = LocalModelEngine(modelPath: modelPath);
      } else {
        _engine = WebApiEngine(gatewayUrl: gatewayUrl, apiKey: apiKey);
      }
      
      await _engine!.initialize();
    } catch (e) {
      initError = e.toString();
      _engine = null;
    } finally {
      isInitializing = false;
      notifyListeners();
    }
  }

  void updateSettings({String? newGateway, String? newModelPath, String? newApiKey}) {
    if (newGateway != null) gatewayUrl = newGateway;
    if (newModelPath != null) modelPath = newModelPath;
    if (newApiKey != null) apiKey = newApiKey;
    notifyListeners();
  }

  void clearLocalModel() {
    modelPath = '';
    notifyListeners();
  }

  void cancelGeneration() {
    _cancelRequested = true;
    notifyListeners();
  }

  Future<void> sendMessage(String text, {List<String> attachmentPaths = const []}) async {
    if (_engine == null) {
      initError = "Engine not initialized";
      notifyListeners();
      return;
    }

    _cancelRequested = false;

    // Add user message
    final userMsg = ChatMessage(text: text, role: MessageRole.user, attachmentPaths: attachmentPaths);
    chatHistory.add(userMsg);
    
    // Add empty assistant message for streaming/generating
    final aiMsg = ChatMessage(text: '', role: MessageRole.ai, isGenerating: true);
    chatHistory.add(aiMsg);
    notifyListeners();

    int? qaId;
    try {
      qaId = await db.into(db.qAPairs).insert(
        QAPairsCompanion.insert(
          query: text,
          answer: '',
          timestamp: DateTime.now(),
          isLocalMode: drift.Value(isLocalMode),
        )
      );
    } catch (e) {
      debugPrint("DB Insert error: $e");
    }

    try {
      final aiIndex = chatHistory.length - 1;
      
      if (_engine is WebApiEngine) {
        final stream = _engine!.sendMessageStream(text, chatHistory.sublist(0, chatHistory.length - 2), attachmentPaths: attachmentPaths);
        String currentText = '';
        await for (var chunk in stream) {
          if (_cancelRequested) break;
          currentText += chunk;
          chatHistory[aiIndex] = chatHistory[aiIndex].copyWith(text: currentText);
          notifyListeners();
          
          if (qaId != null) {
            db.update(db.qAPairs).replace(
              QAPairsCompanion(
                id: drift.Value(qaId),
                query: drift.Value(text),
                answer: drift.Value(currentText),
                timestamp: drift.Value(DateTime.now()),
                isLocalMode: drift.Value(isLocalMode),
              )
            ).catchError((_) => false);
          }
        }
        chatHistory[aiIndex] = chatHistory[aiIndex].copyWith(isGenerating: false);
      } else {
        // Local model streaming
        final stream = _engine!.sendMessageStream(text, chatHistory.sublist(0, chatHistory.length - 2), attachmentPaths: attachmentPaths);
        String currentText = '';
        await for (var chunk in stream) {
          if (_cancelRequested) break;
          currentText += chunk;
          chatHistory[aiIndex] = chatHistory[aiIndex].copyWith(text: currentText);
          notifyListeners();
          
          if (qaId != null) {
            db.update(db.qAPairs).replace(
              QAPairsCompanion(
                id: drift.Value(qaId),
                query: drift.Value(text),
                answer: drift.Value(currentText),
                timestamp: drift.Value(DateTime.now()),
                isLocalMode: drift.Value(isLocalMode),
              )
            ).catchError((_) => false);
          }
        }
        chatHistory[aiIndex] = chatHistory[aiIndex].copyWith(isGenerating: false);
      }
    } catch (e) {
      final aiIndex = chatHistory.length - 1;
      chatHistory[aiIndex] = chatHistory[aiIndex].copyWith(
        text: 'Error: ${e.toString()}',
        isGenerating: false,
      );
    }
    notifyListeners();
  }
}
