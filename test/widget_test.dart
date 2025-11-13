// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_magnoni/main.dart';
import 'package:responsive_magnoni/view/pages/home_page.dart';

void main() {
  testWidgets('App starts and shows HomePage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // The widget is now EventPlanApp, not MyApp.
    await tester.pumpWidget(const EventPlanApp());

    // Verify that our app shows the HomePage.
    expect(find.byType(HomePage), findsOneWidget);
  });
}
