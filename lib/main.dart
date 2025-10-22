import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
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
        fontFamily:'WurmicsBravo',
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
      drawer: SizedBox(
        width: 200, // ancho más pequeño
        child: Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 400, // más grande para que se vea mejor
                    height: 400,
                  ),
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.jpg', width: 300),
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
                  MaterialPageRoute(builder: (_) => AdaptiveNavigationScaffold()),
                );
              },
              child: Text("Entra a la App"),
            ),
          ],
        ),
      ),
    );
  }
}

// ----------------- Mirror con AppBar -----------------
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Espejo", style: TextStyle(color: Colors.black)),
        leading: BackButton(color: Colors.black),
      ),
      body: _controller == null
          ? Center(
        child: Text(
          "No se encontró cámara",
          style: TextStyle(color: Colors.yellow, fontSize: 20),
        ),
      )
          : FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// ----------------- Navegación Adaptativa -----------------
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

class AdaptiveNavigationScaffold extends StatefulWidget {
  @override
  State<AdaptiveNavigationScaffold> createState() => _AdaptiveNavigationScaffoldState();
}

class _AdaptiveNavigationScaffoldState extends State<AdaptiveNavigationScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final isCompact = screenSize.width < 600;

    return Scaffold(
      body: Row(
        children: [
          if (!isCompact)
            NavigationRail(
              backgroundColor: Colors.black,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: Colors.yellow),
              unselectedIconTheme: IconThemeData(color: Colors.grey),
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
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: mainNavItems
            .map((item) =>
            BottomNavigationBarItem(icon: Icon(item.icon), label: item.label))
            .toList(),
      )
          : null,
    );
  }
}