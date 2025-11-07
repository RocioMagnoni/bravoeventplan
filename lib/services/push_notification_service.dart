import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialise() async {
    await _fcm.requestPermission();

    final String? token = await _fcm.getToken();
    
    if (token != null) {
      print("FirebaseMessaging Token: $token");
      // Automatically copy the token to the clipboard
      await Clipboard.setData(ClipboardData(text: token));
      print("--- FCM Token Copied to Clipboard! ---");
    }
  }
}
