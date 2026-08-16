import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // LanguageProvider
import 'topics_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isHindi = langProvider.currentLanguage == 'hi';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                'DarkSider',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isHindi
                    ? 'अपनी मनोवैज्ञानिक यात्रा शुरू करें'
                    : 'Begin your psychological journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),

              // Language Selector
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isHindi ? 'भाषा चुनें' : 'Select Language',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: langProvider.currentLanguage,
                      dropdownColor: const Color(0xFF1E1E1E),
                      underline: const SizedBox(),
                      style: GoogleFonts.poppins(color: Colors.white),
                      items: const [
                        DropdownMenuItem(
                          value: 'en',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'hi',
                          child: Text('हिन्दी'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          langProvider.changeLanguage(value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Start Learning Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TopicsScreen()),
                  );
                },
                icon: const Icon(Icons.menu_book),
                label: Text(
                  isHindi ? 'सीखना शुरू करें' : 'Start Learning',
                  style: const TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Settings Button
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                icon: const Icon(Icons.settings),
                label: Text(
                  isHindi ? 'सेटिंग्स' : 'Settings',
                  style: const TextStyle(fontSize: 18),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.deepPurple),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}