import 'package:flutter/material.dart';
import 'events_page_unified.dart';
import 'checklist_page.dart';
import 'music_page.dart';
import 'contador_page.dart';
import 'ranking_page.dart';
import 'mirror_page.dart';

class AppNavItem {
  final IconData icon;
  final String label;
  final Widget page;

  const AppNavItem({required this.icon, required this.label, required this.page});
}

final List<AppNavItem> mainNavItems = [
  const AppNavItem(icon: Icons.event, label: 'Eventos', page: EventsPageUnified()),
  const AppNavItem(icon: Icons.attach_money, label: 'Dinero', page: ContadorPage()),
  const AppNavItem(icon: Icons.music_note, label: 'Música', page: MusicPage()),
  const AppNavItem(icon: Icons.camera_front, label: 'Espejo', page: MirrorPage()),
  const AppNavItem(icon: Icons.checklist, label: 'CheckList', page: CheckListPage()),
  const AppNavItem(icon: Icons.emoji_events, label: 'Ranking', page: RankingPage()),
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
    final screenSize = MediaQuery.sizeOf(context);
    final isCompact = screenSize.width < 600;
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      body: Row(
        children: [
          if (!isCompact)
            NavigationRail(
              backgroundColor: Colors.black,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: azul), // Azul when selected
              unselectedIconTheme: const IconThemeData(color: Colors.yellow), // Amarillo when unselected
              selectedLabelTextStyle: TextStyle(color: azul),
              unselectedLabelTextStyle: const TextStyle(color: Colors.yellow),
              destinations: mainNavItems
                  .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon), label: Text(item.label)))
                  .toList(),
            ),
          Expanded(child: mainNavItems[_selectedIndex].page),
        ],
      ),
      bottomNavigationBar: isCompact
          ? BottomNavigationBar(
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed, // To see the background color
              currentIndex: _selectedIndex,
              selectedItemColor: azul, // Azul when selected
              unselectedItemColor: Colors.yellow, // Amarillo when unselected
              onTap: (index) => setState(() => _selectedIndex = index),
              items: mainNavItems
                  .map((item) => BottomNavigationBarItem(
                      icon: Icon(item.icon), label: item.label))
                  .toList(),
            )
          : null,
    );
  }
}
