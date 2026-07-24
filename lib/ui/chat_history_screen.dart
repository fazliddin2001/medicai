import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicai/providers/app_state.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';
import 'package:medicai/data/database.dart';
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatelessWidget {
  const ChatHistoryScreen({super.key});

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: GlassPanel(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                borderRadius: 30,
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Search history...",
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<QAPair>>(
                stream: state.db.watchAllHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final history = snapshot.data ?? [];
                  if (history.isEmpty) {
                    return const Center(
                      child: Text(
                        "No history yet.",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final item = history[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _HistoryItem(item: item, db: state.db),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final QAPair item;
  final AppDatabase db;

  const _HistoryItem({required this.item, required this.db});

  void _showFullConversation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Conversation Details"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Query", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
              const SizedBox(height: 4),
              Text(item.query),
              const SizedBox(height: 16),
              Text("Answer", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade900)),
              const SizedBox(height: 4),
              Text(item.answer.isEmpty ? "Generating..." : item.answer),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, HH:mm');

    return InkWell(
      onTap: () => _showFullConversation(context),
      borderRadius: BorderRadius.circular(16),
      child: GlassPanel(
        padding: const EdgeInsets.all(16),
        color: Colors.white.withOpacity(0.6),
        borderColor: Colors.white.withOpacity(0.8),
        borderRadius: 16,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.query,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.isLocalMode ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: item.isLocalMode ? Colors.green.withOpacity(0.3) : Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(item.isLocalMode ? Icons.shield : Icons.cloud, size: 12, color: item.isLocalMode ? Colors.green : Colors.blue),
                            const SizedBox(width: 4),
                            Text(
                              item.isLocalMode ? "LOCAL" : "CLOUD",
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: item.isLocalMode ? Colors.green : Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(dateFormat.format(item.timestamp), style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => db.deleteHistory(item.id),
            ),
          ],
        ),
      ),
    );
  }
}
