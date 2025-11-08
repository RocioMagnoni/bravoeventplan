import 'dart:async';
import 'package:flutter/material.dart';

class JohnnyTipsCarousel extends StatefulWidget {
  const JohnnyTipsCarousel({super.key});

  @override
  State<JohnnyTipsCarousel> createState() => _JohnnyTipsCarouselState();
}

class _JohnnyTipsCarouselState extends State<JohnnyTipsCarousel>
    with SingleTickerProviderStateMixin { // Added mixin for animation
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
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    // Timer for changing text
    _textTimer = Timer.periodic(const Duration(seconds: 10), (timer) {  // tiempo para cambiar texto
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _tips.length;
        });
      }
    });

    // Controller for the star rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 100), // tiempo para girar de la estrella
    )..repeat();
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 290, // Made star bigger
      height: 290, // Made star bigger
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The rotating star with a black border
          RotationTransition(
            turns: _rotationController,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Black star for the border (the largest one)
                const Icon(
                  Icons.star_rounded,
                  color: Colors.black,
                  size: 290,
                ),
                // Yellow star on top (slightly smaller)
                const Icon(
                  Icons.star_rounded,
                  color: Colors.yellow,
                  size: 280,
                ),
              ],
            ),
          ),
          // The text with fade animation
          SizedBox(
            width: 130, // Adjusted width for more margin
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _tips[_currentIndex],
                key: ValueKey<int>(_currentIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10, // Text size reduced further
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
