import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicai/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _gatewayController;
  late TextEditingController _modelPathController;
  bool _isPicking = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    _gatewayController = TextEditingController(text: state.gatewayUrl);
    _modelPathController = TextEditingController(text: state.modelPath);
  }

  @override
  void dispose() {
    _gatewayController.dispose();
    _modelPathController.dispose();
    super.dispose();
  }

  Future<void> _pickModel() async {
    if (_isPicking) return;
    
    setState(() {
      _isPicking = true;
    });

    try {
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        FilePickerResult? result = await FilePicker.pickFiles(
          type: FileType.any, // LiteRTLM doesn't have a standard extension on all platforms yet in file_picker config
        );

        if (result != null) {
          final path = result.files.single.path;
        if (path != null) {
          setState(() {
            _modelPathController.text = path;
          });
          } else {
            if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not read file path. Please enter it manually.')));
          }
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied.')));
      }
    } catch (e) {
      if (mounted && !e.toString().contains('already_active')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  void _save() async {
    if (_modelPathController.text.isNotEmpty) {
      if (!(await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted)) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission is required for the local model.')));
        return;
      }
    }

    if (mounted) {
      context.read<AppState>().updateSettings(
        newGateway: _gatewayController.text,
        newModelPath: _modelPathController.text,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(l10n.settings, style: const TextStyle(color: Colors.black87)),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.gatewayUrl, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _gatewayController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.modelPath, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _modelPathController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                isDense: true,
                                hintText: "/storage/emulated/0/Download/model.bin",
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _pickModel,
                            child: Text(l10n.pickModel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7DD3FC),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _save,
                    child: Text(l10n.save, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
