import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart'; // LanguageProvider
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isHindi = langProvider.currentLanguage == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'सेटिंग्स' : 'Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          _buildSectionTitle(isHindi ? 'भाषा' : 'Language'),
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.language, color: Colors.deepPurple),
              title: Text(
                isHindi ? 'भाषा चुनें' : 'Select Language',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              trailing: DropdownButton<String>(
                value: langProvider.currentLanguage,
                dropdownColor: const Color(0xFF1E1E1E),
                style: GoogleFonts.poppins(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    langProvider.changeLanguage(value);
                    setState(() {});
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // About Section
          _buildSectionTitle(isHindi ? 'जानकारी' : 'About'),
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.privacy_tip,
                  title: isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
                  onTap: () {
                    // TODO: Navigate to PrivacyPolicyScreen
                    _showComingSoon(context, isHindi ? 'गोपनीयता नीति' : 'Privacy Policy');
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildListTile(
                  icon: Icons.description,
                  title: isHindi ? 'नियम और शर्तें' : 'Terms & Conditions',
                  onTap: () {
                    _showComingSoon(context, isHindi ? 'नियम और शर्तें' : 'Terms & Conditions');
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildListTile(
                  icon: Icons.info,
                  title: isHindi ? 'हमारे बारे में' : 'About Us',
                  onTap: () {
                    _showComingSoon(context, isHindi ? 'हमारे बारे में' : 'About Us');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Account Section
          _buildSectionTitle(isHindi ? 'खाता' : 'Account'),
          Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                _buildListTile(
                  icon: Icons.star,
                  title: isHindi ? 'ऐप को रेट करें' : 'Rate App',
                  onTap: () {
                    _showComingSoon(context, isHindi ? 'रेट करें' : 'Rate App');
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildListTile(
                  icon: Icons.share,
                  title: isHindi ? 'ऐप साझा करें' : 'Share App',
                  onTap: () {
                    _showComingSoon(context, isHindi ? 'साझा करें' : 'Share App');
                  },
                ),
                const Divider(color: Colors.grey, height: 1),
                _buildListTile(
                  icon: Icons.logout,
                  title: isHindi ? 'लॉगआउट करें' : 'Logout',
                  onTap: () {
                    // TODO: Firebase sign out logic
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}