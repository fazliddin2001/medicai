import 'dart:async';
import 'dart:isolate';
import 'package:litertlm/litertlm.dart';
import 'package:medicai/models/chat_message.dart';
import 'package:medicai/services/ai_engine_interface.dart';

class LocalModelEngine implements AIEngine {
  SendPort? _isolateSendPort;
  Isolate? _isolate;
  Completer<void>? _initCompleter;
  
  int _requestId = 0;
  final Map<int, Completer<String>> _requests = {};
  final Map<int, StreamController<String>> _streamRequests = {};
  final String modelPath;

  LocalModelEngine({required this.modelPath});

  @override
  Future<void> initialize() async {
    if (_isolate != null) return;
    
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);
    
    final broadcastStream = receivePort.asBroadcastStream();
    _isolateSendPort = await broadcastStream.first;
    
    _initCompleter = Completer<void>();
    
    broadcastStream.listen((message) {
      if (message is Map) {
        if (message['type'] == 'init_done') {
          _initCompleter?.complete();
        } else if (message['type'] == 'init_error') {
          _initCompleter?.completeError(Exception(message['error']));
        } else if (message['type'] == 'response') {
          final id = message['id'] as int;
          final text = message['text'] as String;
          _requests[id]?.complete(text);
          _requests.remove(id);
        } else if (message['type'] == 'error') {
          final id = message['id'] as int;
          final err = message['error'];
          _requests[id]?.completeError(Exception(err));
          _requests.remove(id);
          _streamRequests[id]?.addError(Exception(err));
          _streamRequests[id]?.close();
          _streamRequests.remove(id);
        } else if (message['type'] == 'response_chunk') {
          final id = message['id'] as int;
          final text = message['text'] as String;
          _streamRequests[id]?.add(text);
        } else if (message['type'] == 'response_done') {
          final id = message['id'] as int;
          _streamRequests[id]?.close();
          _streamRequests.remove(id);
        }
      }
    });
    
    _isolateSendPort!.send({
      'type': 'init',
      'modelPath': modelPath,
    });
    
    await _initCompleter!.future;
  }

  static void _isolateEntryPoint(SendPort mainSendPort) async {
    final receivePort = ReceivePort();
    mainSendPort.send(receivePort.sendPort);
    
    Engine? engine;
    Conversation? conversation;
    
    await for (final message in receivePort) {
      if (message is Map) {
        final type = message['type'];
        
        if (type == 'init') {
          final path = message['modelPath'] as String;
          
          Future<bool> tryInit(Backend backend, bool useVision, bool useAudio) async {
            try {
              engine = Engine(engineConfig: EngineConfig(
                modelPath: path, 
                backend: backend,
                visionBackend: useVision ? backend : null,
                audioBackend: useAudio ? backend : null,
              ));
              await engine!.initialize();
              conversation = await engine!.createConversation(
                ConversationConfig(systemMessage: Message.system('You are a helpful and reliable AI medical assistant.')),
              );
              return true;
            } catch (e) {
              await engine?.dispose();
              engine = null;
              conversation = null;
              return false;
            }
          }

          const gpu = Backend.gpu();
          const cpu = Backend.cpu();

          if (await tryInit(cpu, true, true)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(cpu, true, false)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(cpu, false, true)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(cpu, false, false)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(gpu, true, true)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(gpu, true, false)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(gpu, false, true)) {
            mainSendPort.send({'type': 'init_done'});
          } else if (await tryInit(gpu, false, false)) {
            mainSendPort.send({'type': 'init_done'});
          } else {
            mainSendPort.send({'type': 'init_error', 'error': 'Failed to initialize engine with any configuration.'});
          }
          
        } else if (type == 'generate') {
          final id = message['id'] as int;
          final text = message['text'] as String;
          
          try {
            if (conversation == null) throw Exception("Engine not initialized");
            final response = await conversation!.sendMessage(Message.user(text));
            mainSendPort.send({'type': 'response', 'id': id, 'text': response.text});
          } catch (e) {
            mainSendPort.send({'type': 'error', 'id': id, 'error': e.toString()});
          }
          
        } else if (type == 'generate_stream') {
          final id = message['id'] as int;
          final text = message['text'] as String;
          
          try {
            if (conversation == null) throw Exception("Engine not initialized");
            
            final List<String>? attachmentPaths = message['attachmentPaths'];
            final List<Content> contents = [];
            
            if (attachmentPaths != null && attachmentPaths.isNotEmpty) {
              for (final path in attachmentPaths) {
                final lowerPath = path.toLowerCase();
                if (lowerPath.endsWith('.jpg') || lowerPath.endsWith('.jpeg') || lowerPath.endsWith('.png')) {
                  contents.add(Content.imageFile(path));
                } else if (lowerPath.endsWith('.m4a') || lowerPath.endsWith('.mp3') || lowerPath.endsWith('.wav')) {
                  contents.add(Content.audioFile(path));
                }
              }
            }
            
            if (text.isNotEmpty) {
              contents.add(Content.text(text));
            } else if (contents.isNotEmpty) {
              // Ensure we have some text prompt to accompany the image if empty
              contents.add(Content.text("What is in this image?"));
            }
            
            final Message userMsg = (attachmentPaths == null || attachmentPaths.isEmpty) 
                ? Message.user(text) 
                : Message.userContents(Contents(contents));

            final stream = conversation!.sendMessageStream(userMsg);
            await for (final response in stream) {
              mainSendPort.send({'type': 'response_chunk', 'id': id, 'text': response.text});
            }
            mainSendPort.send({'type': 'response_done', 'id': id});
          } catch (e) {
            mainSendPort.send({'type': 'error', 'id': id, 'error': e.toString()});
          }
          
        } else if (type == 'cancel') {
          // Stream controller cancellation will break the stream naturally, no need to call engine.cancel()
        } else if (type == 'dispose') {
          await conversation?.dispose();
          await engine?.dispose();
          receivePort.close();
          break;
        }
      }
    }
  }

  @override
  Future<void> dispose() async {
    _isolateSendPort?.send({'type': 'dispose'});
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _isolateSendPort = null;
  }

  @override
  Future<String> sendMessage(String message, List<ChatMessage> history, {List<String>? attachmentPaths}) {
    if (_isolateSendPort == null) throw Exception("Engine not initialized");
    
    final id = _requestId++;
    final completer = Completer<String>();
    _requests[id] = completer;
    
    _isolateSendPort!.send({
      'type': 'generate',
      'id': id,
      'text': message,
      'attachmentPaths': attachmentPaths,
    });
    
    return completer.future;
  }

  @override
  Stream<String> sendMessageStream(String message, List<ChatMessage> history, {List<String>? attachmentPaths}) {
    if (_isolateSendPort == null) throw Exception("Engine not initialized");
    
    final id = _requestId++;
    final controller = StreamController<String>(
      onCancel: () {
        _isolateSendPort!.send({'type': 'cancel'});
      }
    );
    _streamRequests[id] = controller;
    
    _isolateSendPort!.send({
      'type': 'generate_stream',
      'id': id,
      'text': message,
      'attachmentPaths': attachmentPaths,
    });
    
    return controller.stream;
  }
}
