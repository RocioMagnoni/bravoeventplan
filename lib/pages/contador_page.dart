import 'package:flutter/material.dart';
import 'dart:math';

// ----------------- Dinero con Confeti -----------------
class ContadorPage extends StatefulWidget {
  @override
  _ContadorPageState createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> with SingleTickerProviderStateMixin {
  int money = 0;
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _controller.addListener(() => setState(() {}));
  }

  void _addMoney() {
    setState(() {
      money += 100;
      final rand = Random();
      for (int i = 0; i < 30; i++) {
        _particles.add(ConfettiParticle(
          dx: rand.nextDouble() * MediaQuery.of(context).size.width,
          dy: -rand.nextDouble() * 50,
          color: Colors.primaries[rand.nextInt(Colors.primaries.length)],
          rotation: rand.nextDouble() * 6.28,
          size: 6 + rand.nextDouble() * 6,
          speed: 2 + rand.nextDouble() * 3,
          rotationSpeed: rand.nextDouble() * 0.2,
        ));
      }
      _controller.forward(from: 0);
    });
  }

  void _removeMoney() => setState(() => money -= 100);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dinero total 💰', style: TextStyle(fontSize: 24, color: Colors.yellow)),
                SizedBox(height: 20),
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: money),
                  duration: Duration(milliseconds: 500),
                  builder: (context, value, child) => Text(
                    '\$ $value',
                    style: TextStyle(fontSize: 48, color: Colors.yellow, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _addMoney,
                      child: Text('+100'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E3A5F)),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: _removeMoney,
                      child: Text('-100'),
                      style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E3A5F)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ..._particles.map((p) {
            double t = _controller.value;
            return Positioned(
              left: p.dx,
              top: p.dy + t * MediaQuery.of(context).size.height,
              child: Transform.rotate(
                angle: p.rotation + t * p.rotationSpeed * 6.28,
                child: Container(width: p.size, height: p.size, color: p.color),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConfettiParticle {
  double dx, dy, rotation, size, speed, rotationSpeed;
  Color color;
  ConfettiParticle({
    required this.dx,
    required this.dy,
    required this.color,
    required this.rotation,
    required this.size,
    required this.speed,
    required this.rotationSpeed,
  });
}
