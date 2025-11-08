import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'firebase_options.dart'; 
import 'services/camera_service.dart';
import 'services/push_notification_service.dart';
import 'view/pages/home_page.dart';

// Handler for background messages MUST be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set the background messaging handler early
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Initialize other services
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
