import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';

class ModelManagementScreen extends StatefulWidget {
  const ModelManagementScreen({super.key});

  @override
  State<ModelManagementScreen> createState() => _ModelManagementScreenState();
}

class _ModelManagementScreenState extends State<ModelManagementScreen> {
  bool _isPicking = false;

  Future<void> _pickModel(BuildContext context) async {
    if (_isPicking) return;
    
    setState(() {
      _isPicking = true;
    });

    try {
      if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
        FilePickerResult? result = await FilePicker.pickFiles(type: FileType.any);
        if (result != null && context.mounted) {
          final path = result.files.single.path;
          if (path != null) {
            context.read<AppState>().updateSettings(newModelPath: path);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to retrieve file path from picker. You may need to enter it manually.')));
          }
        }
      } else {
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied.')));
      }
    } catch (e) {
      if (context.mounted && !e.toString().contains('already_active')) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Model Management",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage your local AI models for complete privacy and offline capability.",
                style: TextStyle(color: Colors.blueGrey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              
              GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                                ),
                                child: const Icon(Icons.medical_services, color: Colors.blue),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("MedicAI Core V1.2", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                    Text(".LITERTLM FORMAT", style: TextStyle(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (state.modelPath.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                const Text("Model Ready", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: () => _pickModel(context),
                            icon: const Icon(Icons.download),
                            label: const Text("Load Model"),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: state.modelPath),
                      decoration: const InputDecoration(
                        labelText: "Or enter manual absolute path to model (.bin/.tflite)",
                        border: OutlineInputBorder(),
                        isDense: true,
                        hintText: "/storage/emulated/0/Download/model.bin",
                      ),
                      onSubmitted: (val) async {
                        if (await Permission.manageExternalStorage.request().isGranted || await Permission.storage.request().isGranted) {
                          if (context.mounted) context.read<AppState>().updateSettings(newModelPath: val);
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission is required to read the model.')));
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white),
                      ),
                      child: const Text(
                        "This local model enables 100% private, offline medical AI. Your prompts and data never leave this device, ensuring complete confidentiality while maintaining high-performance inference.",
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("STORAGE USED", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                            Text(state.modelPath.isNotEmpty ? state.storageUsed : "0.0 GB", style: TextStyle(fontSize: 20, color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (state.modelPath.isNotEmpty)
                          TextButton.icon(
                            onPressed: () => context.read<AppState>().clearLocalModel(),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text("Delete Model", style: TextStyle(color: Colors.red)),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              // Gateway Settings could still be here for Cloud mode
              GlassPanel(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Cloud Gateway Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextField(
                      controller: TextEditingController(text: state.gatewayUrl),
                      decoration: const InputDecoration(
                        labelText: "Gateway URL",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (val) => context.read<AppState>().updateSettings(newGateway: val),
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
