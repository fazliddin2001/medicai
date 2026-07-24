import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/models/chat_message.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';
import 'package:medicai/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAutoScrolling = true;
  bool _isRecording = false;
  
  final AudioRecorder _audioRecorder = AudioRecorder();
  List<String> _attachmentPaths = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _controller.addListener(() => setState(() {}));
  }

  void _scrollListener() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels < _scrollController.position.maxScrollExtent - 50) {
      _isAutoScrolling = false;
    } else {
      _isAutoScrolling = true;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final state = context.read<AppState>();
    if (!state.isLocalMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image sending is unavailable in the free tier.")),
      );
      return;
    }

    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _attachmentPaths.add(result.files.single.path!);
      });
    }
  }

  Future<void> _toggleRecording() async {
    final state = context.read<AppState>();
    if (!state.isLocalMode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Audio sending is unavailable in the free tier.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Audio is not supported by the local model yet.")),
      );
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachmentPaths.isEmpty) return;
    
    _isAutoScrolling = true;
    context.read<AppState>().sendMessage(text, attachmentPaths: List.from(_attachmentPaths));
    _controller.clear();
    setState(() {
      _attachmentPaths.clear();
    });
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    // Auto-scroll logic when generating text streams in
    if (state.chatHistory.isNotEmpty && state.chatHistory.last.isGenerating && _isAutoScrolling) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: state.isLocalMode ? Colors.green.shade100 : Colors.blue.shade100,
              radius: 16,
              child: Icon(
                state.isLocalMode ? Icons.shield : Icons.cloud,
                size: 16,
                color: state.isLocalMode ? Colors.green.shade700 : Colors.blue.shade700,
              ),
            ),
            const SizedBox(width: 8),
            Text(l10n.appTitle, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              GlassPanel(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                borderRadius: 20,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.isLocalMode ? l10n.localInfo : l10n.cloudInfo,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.chatHistory.length,
                  itemBuilder: (context, index) {
                    final msg = state.chatHistory[index];
                    final isUser = msg.role == MessageRole.user;
                    
                    String displayText = msg.text;
                    bool isThinking = false;
                    int thoughtChars = 0;
                    
                    if (displayText.contains('<unused94>')) {
                      final startIndex = displayText.indexOf('<unused94>');
                      final beforeThought = displayText.substring(0, startIndex);
                      
                      if (displayText.contains('<unused95>')) {
                        final endIndex = displayText.indexOf('<unused95>') + '<unused95>'.length;
                        final afterThought = displayText.substring(endIndex).trimLeft();
                        displayText = beforeThought + afterThought;
                      } else {
                        if (msg.isGenerating) {
                          isThinking = true;
                          thoughtChars = displayText.length - startIndex - '<unused94>'.length;
                          if (thoughtChars < 0) thoughtChars = 0;
                          displayText = beforeThought;
                        } else {
                          // Generation stopped without a closing tag. Show everything.
                          displayText = msg.text;
                        }
                      }
                    }

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: GlassPanel(
                          color: isUser ? Colors.blue.shade50.withOpacity(0.5) : Colors.white.withOpacity(0.5),
                          borderColor: isUser ? Colors.blue.shade200 : Colors.white.withOpacity(0.8),
                          borderRadius: 20,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (msg.attachmentPaths.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: msg.attachmentPaths.map((path) {
                                    final isImage = path.toLowerCase().endsWith('.jpg') || path.toLowerCase().endsWith('.png') || path.toLowerCase().endsWith('.jpeg');
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.black12,
                                        image: isImage ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null,
                                      ),
                                      child: isImage ? null : AudioPlayerWidget(audioPath: path),
                                    );
                                  }).toList(),
                                ),
                              if (msg.attachmentPaths.isNotEmpty && (displayText.isNotEmpty || isThinking))
                                const SizedBox(height: 8),
                              msg.isGenerating && displayText.isEmpty && !isThinking
                                  ? const SizedBox(
                                      width: 40,
                                      child: LinearProgressIndicator(),
                                    )
                                  : isThinking
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (displayText.isNotEmpty) ...[
                                              MarkdownBody(
                                                data: displayText,
                                                selectable: true,
                                                styleSheet: MarkdownStyleSheet(
                                                  p: TextStyle(
                                                    color: isUser ? Colors.blue.shade900 : Colors.black87,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                            ],
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Thinking... ($thoughtChars chars)",
                                                  style: TextStyle(
                                                    color: isUser ? Colors.blue.shade900 : Colors.black87,
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : MarkdownBody(
                                          data: displayText,
                                          selectable: true,
                                          styleSheet: MarkdownStyleSheet(
                                            p: TextStyle(
                                              color: isUser ? Colors.blue.shade900 : Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (_attachmentPaths.isNotEmpty)
                      Container(
                        height: 60,
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _attachmentPaths.length,
                          itemBuilder: (context, index) {
                            final path = _attachmentPaths[index];
                            final isImage = path.toLowerCase().endsWith('.jpg') || path.toLowerCase().endsWith('.png') || path.toLowerCase().endsWith('.jpeg');
                            return Stack(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.only(right: 8, top: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black12,
                                    image: isImage ? DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover) : null,
                                  ),
                                  child: isImage ? null : AudioPlayerWidget(audioPath: path, isCompact: true),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(() => _attachmentPaths.removeAt(index)),
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                                      child: const Icon(Icons.close, size: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    GlassPanel(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      borderRadius: 24,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.blueGrey),
                            onPressed: state.chatHistory.isNotEmpty && state.chatHistory.last.isGenerating ? null : _pickImage,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              enabled: !(state.chatHistory.isNotEmpty && state.chatHistory.last.isGenerating),
                              decoration: InputDecoration(
                                hintText: _isRecording ? "Recording..." : l10n.messageHint,
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          if (state.chatHistory.isNotEmpty && state.chatHistory.last.isGenerating)
                            IconButton(
                              icon: const Icon(Icons.stop, color: Colors.red),
                              onPressed: () => state.cancelGeneration(),
                            )
                          else if (_controller.text.isEmpty && _attachmentPaths.isEmpty)
                            GestureDetector(
                              onLongPress: _toggleRecording,
                              onLongPressUp: _toggleRecording,
                              child: IconButton(
                                icon: Icon(_isRecording ? Icons.mic : Icons.mic_none, color: _isRecording ? Colors.red : Colors.blue),
                                onPressed: _toggleRecording,
                              ),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.send, color: Colors.blue),
                              onPressed: _sendMessage,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioPath;
  final bool isCompact;
  
  const AudioPlayerWidget({super.key, required this.audioPath, this.isCompact = false});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.play(DeviceFileSource(widget.audioPath));
      setState(() => _isPlaying = true);
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton(
        icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
        iconSize: widget.isCompact ? 30 : 40,
        color: Colors.blue.shade700,
        onPressed: _togglePlay,
      ),
    );
  }
}
