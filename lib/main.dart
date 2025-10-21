import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:just_audio/just_audio.dart';
import 'package:responsive_magnoni/pages/contador_page.dart';
import 'package:responsive_magnoni/pages/ranking_page.dart';
import 'dart:math';
import 'utils/capability.dart';
import 'utils/policy.dart';
import 'dart:io';
import 'pages/events_page_unified.dart';
import 'pages/checklist_page.dart';
import 'pages/music_page.dart';
import 'pages/contador_page.dart';
import 'pages/ranking_page.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(EventPlanApp());
}

class EventPlanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventPlan Johnny Bravo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

// ----------------- Home con Drawer -----------------
class HomePage extends StatelessWidget {
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Inicio', style: TextStyle(color: Colors.black)),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logo.jpg', width: 80),
                  SizedBox(height: 10),
                  Text(
                    'EventPlan Johnny Bravo',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.event, color: Colors.yellow),
              title: Text('Eventos', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, EventsPageUnified()),
            ),
            ListTile(
              leading: Icon(Icons.attach_money, color: Colors.yellow),
              title: Text('Dinero', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, ContadorPage()),
            ),
            ListTile(
              leading: Icon(Icons.music_note, color: Colors.yellow),
              title: Text('Música', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, MusicPage()),
            ),
            ListTile(
              leading: Icon(Icons.camera_front, color: Colors.yellow),
              title: Text('Espejo', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, MirrorPage()),
            ),
            ListTile(
              leading: Icon(Icons.checklist, color: Colors.yellow),
              title: Text('CheckList', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, CheckListPage()),
            ),
            ListTile(
              leading: Icon(Icons.emoji_events, color: Colors.yellow),
              title: Text('Ranking', style: TextStyle(color: Colors.yellow)),
              onTap: () => _navigateTo(context, RankingPage()),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', width: 200),
            SizedBox(height: 20),
            Text(
              "¡Bienvenido a EventPlan Johnny Bravo!\nOrganiza tus fiestas, invitados y diversión.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.yellow, fontSize: 18),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AdaptiveNavigationScaffold()));
              },
              child: Text("Ir a la App"),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Navegación -----------------
class AppNavItem {
  final IconData icon;
  final String label;
  final Widget page;

  const AppNavItem({required this.icon, required this.label, required this.page});
}

final List<AppNavItem> mainNavItems = [
  AppNavItem(icon: Icons.event, label: 'Eventos', page: EventsPageUnified()),
  AppNavItem(icon: Icons.attach_money, label: 'Dinero', page: ContadorPage()),
  AppNavItem(icon: Icons.music_note, label: 'Música', page: MusicPage()),
  AppNavItem(icon: Icons.camera_front, label: 'Espejo', page: MirrorPage()),
  AppNavItem(icon: Icons.checklist, label: 'CheckList', page: CheckListPage()),
  AppNavItem(icon: Icons.emoji_events, label: 'Ranking', page: RankingPage()),
];

// ----------------- Mirror -----------------
class MirrorPage extends StatefulWidget {
  @override
  _MirrorPageState createState() => _MirrorPageState();
}

class _MirrorPageState extends State<MirrorPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    if (cameras.length > 1) {
      _controller = CameraController(cameras[1], ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Center(
        child: Text(
          "No camera found",
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
      );
    }
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller!);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

// ----------------- Adaptive Grid -----------------
class AdaptiveGridCardList extends StatelessWidget {
  final List<Map<String, String>> items;
  final List<Map<String, String>>? events;
  final Color backgroundColor;
  final Color textColor;

  const AdaptiveGridCardList({
    this.items = const [],
    this.events,
    this.backgroundColor = Colors.yellow,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    final list = events ?? items;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 600;
            return isWide
                ? GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: list.length,
              itemBuilder: (context, index) => _cardItem(list[index]),
            )
                : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) => _cardItem(list[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _cardItem(Map<String, String> item) {
    return Card(
      color: backgroundColor,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.containsKey('image'))
              Image.asset(
                'assets/images/${item['image']!}',
                width: double.infinity,
                height: 80,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 5),
            Text(item['name']!,
                style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            if (item.containsKey('description'))
              Text(item['description']!,
                  style: TextStyle(color: textColor, fontSize: 14)),
            if (item.containsKey('datetime'))
              Text(item['datetime']!,
                  style: TextStyle(color: textColor, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ----------------- Adaptive Navigation Scaffold -----------------
class AdaptiveNavigationScaffold extends StatefulWidget {
  @override
  State<AdaptiveNavigationScaffold> createState() =>
      _AdaptiveNavigationScaffoldState();
}

class _AdaptiveNavigationScaffoldState
    extends State<AdaptiveNavigationScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isCompact = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(mainNavItems[_selectedIndex].label,
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Row(
        children: [
          if (!isCompact)
            NavigationRail(
              backgroundColor: Colors.black,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) =>
                  setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: Color(0xFF1E3A5F)),
              unselectedIconTheme: IconThemeData(color: Colors.yellow),
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
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF1E3A5F),
        unselectedItemColor: Colors.yellow,
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
