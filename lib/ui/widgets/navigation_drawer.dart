import 'package:flutter/material.dart';
import 'package:medicai/ui/widgets/glass_panel.dart';
import 'package:medicai/ui/widgets/language_selector.dart';

class AppNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppNavigationDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: 320,
      child: GlassPanel(
        borderRadius: 0,
        blurRadius: 24,
        padding: EdgeInsets.zero,
        color: Colors.white.withOpacity(0.75),
        borderColor: Colors.white.withOpacity(0.8),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _NavItem(
                    icon: Icons.history,
                    title: "Chat History",
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  const SizedBox(height: 8),
                  _NavItem(
                    icon: Icons.cloud_download,
                    title: "Model Management",
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  const SizedBox(height: 8),
                  _NavItem(
                    icon: Icons.language,
                    title: "Language Settings",
                    isSelected: false,
                    onTap: () => showLanguageSelector(context),
                  ),
                  const SizedBox(height: 8),
                  _NavItem(
                    icon: Icons.account_circle,
                    title: "Account",
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.black12, height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Icon(Icons.policy, color: Colors.blueGrey.shade400, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.blueGrey.shade400, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 64, left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.blue.withOpacity(0.2))),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white.withOpacity(0.4), Colors.transparent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue.withOpacity(0.4), width: 2),
                  image: const DecorationImage(
                    image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuDDRPIr0dIitAszFE6Qn_8oslX-Xsw5gIAQtfVm8jOJeCvmk81yHIdhQCDN0Xfy3Pl_iBFMWGhkXcQlME-jOmDIWrQwIXD1piqQ8tKwDhujvxQAXtilJXF12iRd4Q4IqblYDZq-HIcM_Uz0aME8Lsc3Xy2vFLbNSTd3w9dIh8tMq7qc60qUEy-_0S9rTeZJUuqjJ2tNMb-cvKe0J3vRqeBS4pTGCTJPMDnGTuzayAQYji5h-xsLimtFsnnfFhR0ME439TJe_DE0gNA"),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 15),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "User Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F1524)),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 8)],
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "Privacy Level: High",
                        style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.memory, size: 16, color: Colors.black87),
                    const SizedBox(width: 8),
                    const Text("Local Model: V1.2", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Icon(Icons.sync, size: 16, color: Colors.blue),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: isSelected ? Colors.blue : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.blueGrey, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.blue.shade800 : Colors.blueGrey.shade800,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
