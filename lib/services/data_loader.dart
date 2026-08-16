import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/topic.dart';

class DataLoader {
  static Future<List<Topic>> loadTopics() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/topics.json');
      return topicsFromJson(jsonString);
    } catch (e) {
      // Return empty list if file not found or parse error
      return [];
    }
  }

  static Future<List<QuizQuestion>> loadQuizQuestions(String topicId) async {
    try {
      // For simplicity, all quiz questions are in one file.
      // Alternatively, separate files per topic can be used.
      final jsonString = await rootBundle.loadString('assets/data/quiz.json');
      final allQuestions = quizQuestionsFromJson(jsonString);
      // Filter by topicId if the quiz data includes topicId field,
      // otherwise return all (assuming per topic file). 
      // We'll adjust once data format is finalized.
      return allQuestions.where((q) => q.id.toString().startsWith(topicId) || true).toList();
      // Note: this is placeholder logic. In final data, we may have quiz questions
      // grouped by topic in separate files or with topicId field.
    } catch (e) {
      return [];
    }
  }

  static Future<List<QuizQuestion>> loadAllQuizQuestions() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/quiz.json');
      return quizQuestionsFromJson(jsonString);
    } catch (e) {
      return [];
    }
  }
}