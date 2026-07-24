import 'package:flutter/material.dart';
import 'package:medicai/ui/chat_history_screen.dart';
import 'package:medicai/ui/model_management_screen.dart';
import 'package:medicai/ui/home_screen.dart';
import 'package:medicai/ui/widgets/navigation_drawer.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0; // 0: Chat History, 1: Model Management, 2: Account

  final List<Widget> _screens = [
    const ChatHistoryScreen(),
    const ModelManagementScreen(),
    const Center(child: Text("Account Settings (WIP)")),
  ];

  @override
  Widget build(BuildContext context) {
    // Check if desktop or mobile for persistent drawer
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: isDesktop ? null : AppBar(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text("MedicAI", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      drawer: isDesktop ? null : AppNavigationDrawer(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          setState(() => _selectedIndex = index);
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
              ),
            ),
          ),
          
          Row(
            children: [
              if (isDesktop)
                AppNavigationDrawer(
                  selectedIndex: _selectedIndex,
                  onItemSelected: (index) => setState(() => _selectedIndex = index),
                ),
              Expanded(
                child: _screens[_selectedIndex],
              ),
            ],
          ),
        ],
      ),
      // Mobile Bottom Nav for quick access (Chat / History)
      bottomNavigationBar: isDesktop ? null : BottomNavigationBar(
        currentIndex: _selectedIndex == 0 ? 1 : 0, // Mocking logic for bottom nav
        onTap: (idx) {
          if (idx == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
          } else {
            setState(() => _selectedIndex = 0);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "New Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen())),
            child: const Icon(Icons.add),
          )
        : null,
    );
  }
}
