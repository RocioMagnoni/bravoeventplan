import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/pages/gallery_page.dart';
import 'events_page_unified.dart';
import 'checklist_page.dart';
import 'music_page.dart';
import 'contador_page.dart';
import 'mirror_page.dart';

class AppNavItem {
  final IconData icon;
  final String label;
  final Widget page;

  const AppNavItem({required this.icon, required this.label, required this.page});
}

// Themed Nav Items
final List<AppNavItem> mainNavItems = [
  const AppNavItem(icon: Icons.celebration, label: 'Eventos', page: EventsPageUnified()),
  const AppNavItem(icon: Icons.photo_library, label: 'Galería', page: GalleryPage()),
  const AppNavItem(icon: Icons.monetization_on, label: 'Bóveda', page: ContadorPage()),
  const AppNavItem(icon: Icons.music_note, label: 'Música', page: MusicPage()),
  const AppNavItem(icon: Icons.camera_front, label: 'Espejo', page: MirrorPage()), // Corrected Icon
  const AppNavItem(icon: Icons.checklist, label: 'CheckList', page: CheckListPage()),
];

class AdaptiveNavigationScaffold extends StatefulWidget {
  const AdaptiveNavigationScaffold({super.key});

  @override
  State<AdaptiveNavigationScaffold> createState() => _AdaptiveNavigationScaffoldState();
}

class _AdaptiveNavigationScaffoldState extends State<AdaptiveNavigationScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isCompact = screenSize.width < 600;
    final azul = const Color(0xFF1E3A5F);

    if (isCompact) {
      // Compact layout with BottomNavigationBar
      return Scaffold(
        body: mainNavItems[_selectedIndex].page,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed, 
          currentIndex: _selectedIndex,
          selectedItemColor: azul, // Selected is Blue
          unselectedItemColor: Colors.yellow, // Unselected is Yellow
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          items: mainNavItems.map((item) => 
            BottomNavigationBarItem(icon: Icon(item.icon, size: 28), label: item.label)
          ).toList(),
        ),
      );
    } else {
      // Expanded layout with NavigationRail
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              backgroundColor: Colors.black,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              leading: _buildHeader(),
              selectedIconTheme: IconThemeData(color: azul, size: 32), // Selected is Blue
              unselectedIconTheme: const IconThemeData(color: Colors.yellow, size: 28), // Unselected is Yellow
              selectedLabelTextStyle: TextStyle(color: azul, fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelTextStyle: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.normal, fontSize: 12),
              indicatorColor: Colors.transparent, // Let the icon color handle the selection
              destinations: mainNavItems.map((item) => 
                NavigationRailDestination(icon: Icon(item.icon), label: Text(item.label))
              ).toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1, color: Colors.grey),
            Expanded(child: mainNavItems[_selectedIndex].page),
          ],
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Image.asset('assets/images/logo.jpg', width: 60, height: 60),
          const SizedBox(height: 8),
          const Text('EventPlan', style: TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
