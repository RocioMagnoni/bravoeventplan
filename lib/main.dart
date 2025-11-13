import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:responsive_magnoni/blocs/checklist/checklist_bloc.dart';
import 'package:responsive_magnoni/blocs/contador/contador_bloc.dart';
import 'package:responsive_magnoni/blocs/contador/contador_event.dart';
import 'package:responsive_magnoni/blocs/events/event_bloc.dart';
import 'package:responsive_magnoni/blocs/events/event_event.dart';
import 'package:responsive_magnoni/blocs/gallery/gallery_bloc.dart';
import 'package:responsive_magnoni/blocs/gallery/gallery_event.dart';
import 'package:responsive_magnoni/blocs/music/music_bloc.dart';
import 'package:responsive_magnoni/data/repositories/checklist_repository.dart';
import 'package:responsive_magnoni/data/repositories/contador_repository.dart';
import 'package:responsive_magnoni/data/repositories/event_repository.dart';
import 'package:responsive_magnoni/data/repositories/gallery_repository.dart';
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

  await initializeDateFormatting('es_ES', null);

  await Supabase.initialize(
    url: 'https://qnvuoogeiyzwanynlrtk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFudnVvb2dlaXl6d2FueW5scnRrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI1NDI0MzgsImV4cCI6MjA3ODExODQzOH0.rgSF5-sbWq2fvIUPklHY9ZdBZpuhbfi8JC49VAVX75k',
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
    // Create repositories here to be used by Blocs
    final eventRepository = EventRepository();
    final galleryRepository = GalleryRepository();
    // The ContadorRepository now needs the EventRepository to listen to its stream
    final contadorRepository = ContadorRepository(eventRepository: eventRepository);
    final checklistRepository = ChecklistRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<EventBloc>(
          create: (_) => EventBloc(eventRepository)..add(LoadEvents()),
        ),
        BlocProvider<GalleryBloc>(
          create: (_) => GalleryBloc(galleryRepository)..add(LoadGallery()),
        ),
        BlocProvider<ContadorBloc>(
          // The ContadorBloc now only needs the unified ContadorRepository
          create: (_) => ContadorBloc(
            contadorRepository: contadorRepository,
          )..add(LoadContador()),
        ),
        BlocProvider<ChecklistBloc>(
          create: (_) => ChecklistBloc(checklistRepository),
        ),
        BlocProvider<MusicBloc>(
          create: (_) => MusicBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'EventPlan',
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
