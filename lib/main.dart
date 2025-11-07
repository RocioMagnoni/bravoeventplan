import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import the generated file
import 'services/camera_service.dart';
import 'services/push_notification_service.dart'; // Import the new service
import 'view/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Use the generated options to initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize the notification service
  await PushNotificationService().initialise();
  
  await CameraService.initializeCameras();
  runApp(const EventPlanApp());
}

class EventPlanApp extends StatelessWidget {
  const EventPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EventPlan Johnny Bravo',
      theme: ThemeData(
        fontFamily: 'WurmicsBravo',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomePage(),
    );
  }
}
