import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const radius = 20.0;

    // Main rectangle path
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Circle paths for the notches
    final leftNotchPath = Path()
      ..addRRect(
        RRect.fromLTRBR(
          -radius, // Starts from outside the left edge
          size.height / 2 - radius,
          radius,  // Ends inside the left edge
          size.height / 2 + radius,
          const Radius.circular(radius),
        ),
      );

    final rightNotchPath = Path()
      ..addRRect(
        RRect.fromLTRBR(
          size.width - radius, // Starts from inside the right edge
          size.height / 2 - radius,
          size.width + radius, // Ends outside the right edge
          size.height / 2 + radius,
          const Radius.circular(radius),
        ),
      );

    // Combine the main path with the notch paths using 'difference'
    // This subtracts the notches from the main rectangle
    return Path.combine(
      PathOperation.difference,
      path,
      Path()..addPath(leftNotchPath, Offset.zero)..addPath(rightNotchPath, Offset.zero),
    );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
