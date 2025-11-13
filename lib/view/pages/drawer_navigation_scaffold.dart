import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/pages/adaptive_navigation_scaffold.dart'; // for mainNavItems

class DrawerNavigationScaffold extends StatefulWidget {
  final int initialIndex;

  const DrawerNavigationScaffold({super.key, required this.initialIndex});

  @override
  State<DrawerNavigationScaffold> createState() => _DrawerNavigationScaffoldState();
}

class _DrawerNavigationScaffoldState extends State<DrawerNavigationScaffold> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);
    final currentPage = mainNavItems[_selectedIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(currentPage.label, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
            for (var i = 0; i < mainNavItems.length; i++)
              _buildDrawerItem(
                context,
                icon: mainNavItems[i].icon,
                text: mainNavItems[i].label,
                index: i,
                azul: azul,
              ),
          ],
        ),
      ),
      body: currentPage.page,
    );
  }

    Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String text, required int index, required Color azul}) {
    final bool isSelected = _selectedIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? azul : Colors.yellow),
      title: Text(text, style: TextStyle(color: isSelected ? azul : Colors.yellow, fontWeight: FontWeight.bold)),
      onTap: () => _onItemTapped(index),
    );
  }
}
