import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/widgets/johnny_tips_carousel.dart';
import 'adaptive_navigation_scaffold.dart';
import 'events_page_unified.dart';
import 'checklist_page.dart';
import 'music_page.dart';
import 'contador_page.dart';
import 'ranking_page.dart';
import 'mirror_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Inicio', style: TextStyle(color: Colors.black)),
      ),
      drawer: SizedBox(
        width: 200,
        child: Drawer(
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
              ListTile(
                leading: const Icon(Icons.event, color: Colors.yellow),
                title: const Text('Eventos', style: TextStyle(color: Colors.yellow)),
                onTap: () => _navigateTo(context, const EventsPageUnified()),
              ),
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.yellow),
                title: const Text('Dinero', style: TextStyle(color: Colors.yellow)),
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
              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.yellow),
                title: const Text('Ranking', style: TextStyle(color: Colors.yellow)),
                onTap: () => _navigateTo(context, const RankingPage()),
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
              Image.asset('assets/images/logo.jpg', width: 350),
              const SizedBox(height: 20),
              const Text( // Restored the description text
                "¡Bienvenido a EventPlan Johnny Bravo!\nOrganiza tus fiestas, invitados y mucho mas.",
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
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdaptiveNavigationScaffold()),
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
