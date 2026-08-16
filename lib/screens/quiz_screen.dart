import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/topic.dart';
import '../services/data_loader.dart';
import '../main.dart'; // LanguageProvider (will refactor later)

class QuizScreen extends StatefulWidget {
  final Topic topic;
  const QuizScreen({super.key, required this.topic});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion>? _questions;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _answered = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await DataLoader.loadQuizQuestions(widget.topic.id);
    setState(() {
      _questions = questions;
      _loading = false;
    });
  }

  void _selectOption(int optionIndex) {
    if (_answered) return;
    setState(() {
      _selectedOptionIndex = optionIndex;
      _answered = true;
      if (optionIndex == _questions![_currentIndex].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions!.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = null;
        _answered = false;
      });
    } else {
      // Quiz completed
      setState(() {
        _currentIndex = _questions!.length; // Will show result
      });
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOptionIndex = null;
      _answered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);
    final isHindi = langProvider.currentLanguage == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isHindi ? 'क्विज़' : 'Quiz',
        ),
      ),
      body: _buildBody(context, isHindi),
    );
  }

  Widget _buildBody(BuildContext context, bool isHindi) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_questions == null || _questions!.isEmpty) {
      return Center(
        child: Text(
          isHindi ? 'प्रश्न उपलब्ध नहीं हैं' : 'No questions available',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    // If quiz completed
    if (_currentIndex >= _questions!.length) {
      return _buildResultScreen(isHindi);
    }

    final question = _questions![_currentIndex];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions!.length,
            backgroundColor: Colors.grey[800],
            color: Colors.deepPurple,
            minHeight: 6,
          ),
          const SizedBox(height: 10),
          Text(
            '${_currentIndex + 1} / ${_questions!.length}',
            style: GoogleFonts.poppins(color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Question
          Text(
            question.getQuestion(langProvider.currentLanguage),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          // Options
          ...List.generate(question.options.length, (index) {
            final option = question.options[index];
            final isSelected = _selectedOptionIndex == index;
            final isCorrect = index == question.correctIndex;
            final showCorrect = _answered && isCorrect;
            final showWrong = _answered && isSelected && !isCorrect;

            Color? bgColor = const Color(0xFF1E1E1E);
            if (showCorrect) bgColor = Colors.green[700];
            if (showWrong) bgColor = Colors.red[700];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () => _selectOption(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.deepPurple : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    option.getText(langProvider.currentLanguage),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }),

          const Spacer(),

          // Next / Finish button
          if (_answered)
            ElevatedButton(
              onPressed: _nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _currentIndex == _questions!.length - 1
                    ? (isHindi ? 'समाप्त' : 'Finish')
                    : (isHindi ? 'अगला' : 'Next'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(bool isHindi) {
    final total = _questions!.length;
    final percentage = (_score / total * 100).round();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              percentage >= 60 ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              size: 80,
              color: percentage >= 60 ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              isHindi ? 'आपका स्कोर' : 'Your Score',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$_score / $total',
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Text(
              '$percentage%',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _restartQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(isHindi ? 'फिर से प्रयास करें' : 'Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}