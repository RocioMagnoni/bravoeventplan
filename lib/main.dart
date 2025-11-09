import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import for date formatting
import 'package:provider/provider.dart';
import 'package:responsive_magnoni/blocs/events/event_bloc.dart';
import 'package:responsive_magnoni/blocs/events/event_event.dart';
import 'package:responsive_magnoni/data/repositories/event_repository.dart';
import 'package:responsive_magnoni/viewmodel/checklist_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/contador_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/music_viewmodel.dart';
import 'package:responsive_magnoni/viewmodel/ranking_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  // Initialize Date Formatting for Spanish
  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
    url: 'https://pgojhzoxkcjylhvlxmhg.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBnb2poem94a2NqeWxoZmx4bWhnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTgxMDM1ODksImV4cCI6MjAzMzY3OTU4OX0.kCqB2h-jLMF92F9Y_--fB75YtQ2wVl_jY8sTS0y3z-U',
  );

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
