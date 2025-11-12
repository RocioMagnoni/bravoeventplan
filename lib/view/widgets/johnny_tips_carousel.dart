import 'dart:async';
import 'package:flutter/material.dart';

class JohnnyTipsCarousel extends StatefulWidget {
  const JohnnyTipsCarousel({super.key});

  @override
  State<JohnnyTipsCarousel> createState() => _JohnnyTipsCarouselState();
}

class _JohnnyTipsCarouselState extends State<JohnnyTipsCarousel> {
  final List<String> _tips = [
    "¡Hey, nena! ¿Sientes eso? Son mis músculos pidiendo más... ¡más fiesta!",
    "Suficiente charla. ¡Es hora de la acción!",
    "El hombre del pelo increíble necesita una fiesta increíble.",
    "Mis gafas son tan brillantes como mi futuro.",
    "Si ser guapo fuera un crimen, yo estaría en cadena perpetua.",
    "¡Hu, ha, huah! ¡Pose de karate!",
    "Soy Johnny Bravo, el único, el inimitable.",
  ];

  int _currentIndex = 0;
  Timer? _textTimer;

  @override
  void initState() {
    super.initState();
    // Timer for changing text
    _textTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _tips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, // Made the GIF smaller
      height: 200, // Made the GIF smaller
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The animated GIF background
          Image.asset(
            'assets/images/disco_ball.webp',
            width: 200, // Made the GIF smaller
            height: 200, // Made the GIF smaller
          ),
          // The text with fade animation
          SizedBox(
            width: 140,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Stack(
                key: ValueKey<int>(_currentIndex), // Key is now on the Stack
                children: [
                  // Outlined text (the border)
                  Text(
                    _tips[_currentIndex],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 2.5
                        ..color = Colors.black,
                    ),
                  ),
                  // Filled text (the content)
                  Text(
                    _tips[_currentIndex],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
