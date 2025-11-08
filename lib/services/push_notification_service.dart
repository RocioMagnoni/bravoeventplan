import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

// Handler for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialise() async {
    // Request permission
    await _fcm.requestPermission();

    // Get FCM Token
    final String? token = await _fcm.getToken();
    if (token != null) {
      print("FirebaseMessaging Token: $token");
      await Clipboard.setData(ClipboardData(text: token));
      print("--- FCM Token Copied to Clipboard! ---");
    }

    // Set up listeners
    // For foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // For background messages (when user taps the notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
    });

    // For terminated state messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
