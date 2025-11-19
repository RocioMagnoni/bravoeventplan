import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/pages/gallery_page.dart';
import 'package:responsive_magnoni/view/pages/events_page_unified.dart';
import 'package:responsive_magnoni/view/pages/music_page.dart';
import 'package:responsive_magnoni/view/pages/mirror_page.dart';
import 'package:responsive_magnoni/view/pages/contador_page.dart';
import 'package:responsive_magnoni/view/pages/checklist_page.dart';
import 'package:responsive_magnoni/view/pages/home_page.dart';

enum AppPage { home, events, gallery, vault, music, mirror, checklist }

class MainDrawer extends StatelessWidget {
  final Color azul = const Color(0xFF1E3A5F);
  final AppPage currentPage;

  const MainDrawer({super.key, required this.currentPage});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close drawer
    // Use pushReplacement to avoid building up a stack of pages
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (_) => page)
    );
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pop(context); // Close drawer
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: azul.withOpacity(0.2)),
              child: Center(
                child: Image.asset('assets/images/logo.jpg'),
              ),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.events,
              title: 'Eventos',
              icon: Icons.celebration,
              targetPage: const EventsPageUnified(),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.gallery,
              title: 'Galería',
              icon: Icons.photo_library,
              targetPage: const GalleryPage(),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.vault,
              title: 'Bóveda',
              icon: Icons.monetization_on,
              targetPage: const ContadorPage(),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.music,
              title: 'Música',
              icon: Icons.music_note,
              targetPage: const MusicPage(),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.mirror,
              title: 'Espejo',
              icon: Icons.camera_front,
              targetPage: const MirrorPage(),
            ),
            _buildDrawerItem(
              context,
              page: AppPage.checklist,
              title: 'CheckList',
              icon: Icons.checklist,
              targetPage: const CheckListPage(),
            ),
            const Divider(color: Colors.yellow, indent: 16, endIndent: 16, thickness: 0.5),
            ListTile(
              leading: Icon(Icons.logout, color: currentPage == AppPage.home ? azul : Colors.yellow),
              title: Text('Salir', style: TextStyle(color: currentPage == AppPage.home ? azul : Colors.yellow, fontWeight: currentPage == AppPage.home ? FontWeight.bold : FontWeight.normal)),
              tileColor: currentPage == AppPage.home ? Colors.yellow.withOpacity(0.4) : null,
              onTap: () => _navigateToHome(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, {required AppPage page, required String title, required IconData icon, required Widget targetPage}) {
    final bool isSelected = currentPage == page;
    return ListTile(
      leading: Icon(icon, color: isSelected ? azul : Colors.yellow),
      title: Text(title, style: TextStyle(color: isSelected ? azul : Colors.yellow, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      tileColor: isSelected ? Colors.yellow.withOpacity(0.4) : null,
      onTap: () => _navigateTo(context, targetPage),
    );
  }
}
