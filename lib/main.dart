import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:responsive_magnoni/blocs/events/event_bloc.dart';
import 'package:responsive_magnoni/blocs/events/event_event.dart';
import 'package:responsive_magnoni/data/repositories/event_repository.dart';
import 'package:responsive_magnoni/viewmodel/checklist_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/contador_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/music_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/ranking_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase
import 'firebase_options.dart'; 
import 'services/camera_service.dart';
import 'services/push_notification_service.dart';
import 'view/pages/home_page.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://qnvuoogeiyzwanynlrtk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFudnVvb2dlaXl6d2FueW5scnRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1NDI0MzgsImV4cCI6MjA3ODExODQzOH0.rgSF5-sbWq2fvIUPklHY9ZdBZpuhbfi8JC49VAVX75k',
  );

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  await PushNotificationService().initialise();
  await CameraService.initializeCameras();

  runApp(const EventPlanApp());
}

class EventPlanApp extends StatelessWidget {
  const EventPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(EventRepository())..add(LoadEvents()),
        ),
        ChangeNotifierProvider<RankingViewModel>(create: (_) => RankingViewModel()),
        ChangeNotifierProvider<ContadorViewModel>(create: (_) => ContadorViewModel()),
        ChangeNotifierProvider<ChecklistViewModel>(create: (_) => ChecklistViewModel()),
        ChangeNotifierProvider<MusicViewModel>(create: (_) => MusicViewModel()),
      ],
      child: MaterialApp(
        title: 'EventPlan Johnny Bravo',
        theme: ThemeData(
          fontFamily: 'WurmicsBravo',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const HomePage(),
      ),
    );
  }
}
