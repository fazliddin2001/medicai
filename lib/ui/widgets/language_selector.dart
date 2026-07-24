import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        blurRadius: 24,
        color: Colors.white.withOpacity(0.75),
        borderColor: Colors.white.withOpacity(0.5),
        borderRadius: 24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Language",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF001F2E)),
            ),
            const SizedBox(height: 8),
            const Text(
              "Choose your preferred language for MedicAI",
              style: TextStyle(color: Color(0xFF2A4A5E)),
            ),
            const SizedBox(height: 24),
            _buildLangOption(context, 'en', 'EN', 'English', state.currentLocale.languageCode == 'en'),
            const SizedBox(height: 12),
            _buildLangOption(context, 'ru', 'RU', 'Русский', state.currentLocale.languageCode == 'ru'),
            const SizedBox(height: 12),
            _buildLangOption(context, 'uz', 'UZ', 'Oʻzbekcha', state.currentLocale.languageCode == 'uz'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A4C6E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Confirm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, String code, String shortcode, String name, bool isSelected) {
    return InkWell(
      onTap: () {
        context.read<AppState>().setLocale(Locale(code, ''));
      },
      borderRadius: BorderRadius.circular(12),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? const Color(0xFF7DD3FC).withOpacity(0.15) : Colors.white.withOpacity(0.5),
        borderColor: isSelected ? const Color(0xFF7DD3FC).withOpacity(0.8) : Colors.transparent,
        borderRadius: 12,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF7DD3FC).withOpacity(0.2)),
              ),
              alignment: Alignment.center,
              child: Text(shortcode, style: const TextStyle(color: Color(0xFF0A4C6E), fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF001F2E)),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF0A4C6E)),
          ],
        ),
      ),
    );
  }
}

void showLanguageSelector(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.2),
    builder: (context) => const LanguageSelector(),
  );
}
