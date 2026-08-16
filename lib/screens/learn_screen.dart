import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/topic.dart';
import '../main.dart'; // LanguageProvider (will refactor later)

class LearnScreen extends StatefulWidget {
  final Topic topic;
  const LearnScreen({super.key, required this.topic});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool _isSpeaking = false;

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isHindi = langProvider.currentLanguage == 'hi';

    final title = widget.topic.getTitle(langProvider.currentLanguage);
    final paragraph = widget.topic.getParagraph(langProvider.currentLanguage);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Paragraph
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  paragraph,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    height: 1.6,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                // Listen button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() => _isSpeaking = true);
                      await langProvider.speak(paragraph);
                      setState(() => _isSpeaking = false);
                    },
                    icon: Icon(
                      _isSpeaking ? Icons.stop : Icons.volume_up,
                    ),
                    label: Text(isHindi ? 'सुनें' : 'Listen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Quiz button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to QuizScreen (will be created next)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isHindi ? 'क्विज़ जल्द आ रहा है' : 'Quiz coming soon',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(isHindi ? 'क्विज़ लें' : 'Take Quiz'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}