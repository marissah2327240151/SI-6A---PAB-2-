import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// 🔥 WAJIB untuk background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 🔥 daftar background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initFCM();
  }

  void initFCM() async {
    print("INIT FCM...");

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 🔥 request permission (Android 13+ penting)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permission: ${settings.authorizationStatus}");

    // 🔥 ambil token (pakai retry biar tidak null)
    String? token;

    for (int i = 0; i < 5; i++) {
      token = await messaging.getToken();
      if (token != null) break;
      await Future.delayed(Duration(seconds: 1));
    }

    print("TOKEN DEVICE:");
    print(token ?? "TOKEN NULL ❌");

    // 🔥 handle saat app dibuka
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
    });

    // 🔥 saat klik notifikasi
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Klik notifikasi");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("FCM Ready")),
      ),
    );
  }
}