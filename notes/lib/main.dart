import 'package:flutter/material.dart';
import 'package:notes/screens/note_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart'; // ← import hasil generate

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Baca bahasa yang tersimpan, default ke 'id' (Indonesia)
  final prefs = await SharedPreferences.getInstance();
  final savedLocale = prefs.getString('app_locale') ?? 'id';

  runApp(MainApp(initialLocale: Locale(savedLocale)));
}

// Ubah dari StatelessWidget menjadi StatefulWidget
// agar bisa memanggil setState saat bahasa diganti
class MainApp extends StatefulWidget {
  final Locale initialLocale;

  const MainApp({super.key, required this.initialLocale});

  // Static instance supaya bisa dipanggil dari widget mana saja
  static _MainAppState? _instance;

  // Method untuk mengganti bahasa, dipanggil dari widget lain
  static void setLocale(Locale locale) {
    _instance?._setLocale(locale);
  }

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    MainApp._instance = this; // daftarkan instance
  }

  // Ganti bahasa + simpan ke SharedPreferences
  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('app_locale', locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple, useMaterial3: true),

      // ↓ Tiga baris ini yang mengaktifkan localization
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      home: const NoteListScreen(),
    );
  }
}