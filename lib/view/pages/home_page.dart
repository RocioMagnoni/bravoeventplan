import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/pages/gallery_page.dart';
import 'package:responsive_magnoni/view/widgets/johnny_tips_carousel.dart';
import 'adaptive_navigation_scaffold.dart';
import 'events_page_unified.dart';
import 'checklist_page.dart';
import 'music_page.dart';
import 'contador_page.dart';
import 'mirror_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.pop(context); // Close the drawer first
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        title: const Text('Inicio', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      drawer: SizedBox(
        width: 250, // Setting a narrower width for the drawer
        child: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: azul.withOpacity(0.2),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              ListTile(
                  leading: const Icon(Icons.celebration, color: Colors.yellow),
                  title: const Text('Eventos', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const EventsPageUnified()),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.yellow),
                  title: const Text('Galería', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const GalleryPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on, color: Colors.yellow),
                  title: const Text('Bóveda', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const ContadorPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.music_note, color: Colors.yellow),
                  title: const Text('Música', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const MusicPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_front, color: Colors.yellow),
                  title: const Text('Espejo', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const MirrorPage()),
                ),
                ListTile(
                  leading: const Icon(Icons.checklist, color: Colors.yellow),
                  title: const Text('CheckList', style: TextStyle(color: Colors.yellow)),
                  onTap: () => _navigateTo(context, const CheckListPage()),
                ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg', width: 220),
              const SizedBox(height: 20),
              const Text(
                "Bienvenido, Johnny Bravo. Prepárate para brillar, baby!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.yellow, fontSize: 18),
              ),
              const SizedBox(height: 20),
              const JohnnyTipsCarousel(),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: BorderSide(color: azul, width: 3),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdaptiveNavigationScaffold()),
                  );
                },
                child: const Text("Iniciar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
