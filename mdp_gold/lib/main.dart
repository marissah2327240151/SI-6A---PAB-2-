import 'package:daftar_belanja/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Custom ScrollBehavior agar bisa scroll dengan mouse di Chrome/Web
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

void main() async {
  // Memastikan binding Flutter sudah siap sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase dengan konfigurasi sesuai platform (Android/Web/Windows)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Menjalankan aplikasi Flutter dengan widget MainApp
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Custom scroll behavior agar bisa scroll di Chrome
      scrollBehavior: AppScrollBehavior(),
      // Menghilangkan banner "DEBUG" di pojok kanan atas
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
