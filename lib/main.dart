import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:firebase_core/firebase_core.dart'; // Uncomment when Firebase is configured
// import 'package:firebase_auth/firebase_auth.dart'; // Uncomment later

import 'screens/home_screen.dart';

// ------------------ Language Provider ------------------
class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'en'; // 'en' or 'hi'
  final FlutterTts _tts = FlutterTts();
  String get currentLanguage => _currentLanguage;

  LanguageProvider() {
    _loadLanguage();
    _setupTts();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'en';
    notifyListeners();
  }

  Future<void> _setupTts() async {
    await _tts.setLanguage(_currentLanguage == 'hi' ? 'hi-IN' : 'en-US');
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.5); // Slightly slower for clarity
    // Male voice if available:
    // await _tts.setVoice({"name": "Google हिन्दी", "locale": "hi-IN"});
  }

  Future<void> changeLanguage(String lang) async {
    _currentLanguage = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    await _setupTts();
  }

  Future<void> speak(String text) async {
    await _tts.stop();
    await _tts.speak(text);
  }
}

// ------------------ Main App ------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Uncomment and configure Firebase later:
  // await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageProvider(),
      child: const DarkSiderApp(),
    ),
  );
}

class DarkSiderApp extends StatelessWidget {
  const DarkSiderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DarkSider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomeScreen(), // Updated to use new HomeScreen from screens folder
    );
  }
}