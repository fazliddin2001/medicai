import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicai/l10n/app_localizations.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/chat_screen.dart';
import 'package:medicai/ui/settings_screen.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AppState>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.4),
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: const ColorFilter.mode(Colors.transparent, BlendMode.srcOver), // Simple effect
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Text(l10n.appTitle, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
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
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  l10n.welcomeMessage,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                if (state.initError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(state.initError!, style: const TextStyle(color: Colors.red)),
                  ),
                _ModeCard(
                  title: l10n.webApiMode,
                  subtitle: l10n.cloudIntelligence,
                  description: l10n.webApiDesc,
                  icon: Icons.cloud_queue,
                  color: const Color(0xFF7DD3FC),
                  onTap: () => _selectMode(context, false),
                  isLoading: state.isInitializing && !state.isLocalMode,
                ),
                const SizedBox(height: 24),
                _ModeCard(
                  title: l10n.onDeviceMode,
                  subtitle: l10n.localPrivacy,
                  description: l10n.onDeviceDesc,
                  icon: Icons.shield_outlined,
                  color: const Color(0xFFC8A0F0),
                  onTap: () => _selectMode(context, true),
                  isLoading: state.isInitializing && state.isLocalMode,
                ),
              ],
            ),
          ),
          ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectMode(BuildContext context, bool local) async {
    final state = context.read<AppState>();
    await state.setMode(local);
    if (state.initError == null && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ChatScreen()),
      );
    }
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                if (isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
            const SizedBox(height: 12),
            Text(description, style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}
