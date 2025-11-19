import 'package:flutter/material.dart';
import 'package:responsive_magnoni/view/widgets/johnny_tips_carousel.dart';
import 'package:responsive_magnoni/view/widgets/main_drawer.dart'; // Import the new drawer
import 'adaptive_navigation_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      drawer: const MainDrawer(currentPage: AppPage.home), // ⬅️ ADDED THIS
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg', width: 220),
              const SizedBox(height: 20),
              const Text(
                "Bienvenido,\nJohnny Bravo. Prepárate para brillar, baby!",
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
