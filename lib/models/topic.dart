import 'dart:convert';

class Topic {
  final String id;
  final String titleEn;
  final String titleHi;
  final String paragraphEn;
  final String paragraphHi;
  final String? ttsAudioEn;
  final String? ttsAudioHi;

  Topic({
    required this.id,
    required this.titleEn,
    required this.titleHi,
    required this.paragraphEn,
    required this.paragraphHi,
    this.ttsAudioEn,
    this.ttsAudioHi,
  });

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['topicId'] ?? json['id'] ?? '',
      titleEn: json['title']?['en'] ?? '',
      titleHi: json['title']?['hi'] ?? '',
      paragraphEn: json['paragraph']?['en'] ?? '',
      paragraphHi: json['paragraph']?['hi'] ?? '',
      ttsAudioEn: json['tts']?['en'],
      ttsAudioHi: json['tts']?['hi'],
    );
  }

  String getTitle(String lang) => lang == 'hi' ? titleHi : titleEn;
  String getParagraph(String lang) => lang == 'hi' ? paragraphHi : paragraphEn;
}

class QuizQuestion {
  final int id;
  final String questionEn;
  final String questionHi;
  final List<QuizOption> options;
  final int correctIndex;

  QuizQuestion({
    required this.id,
    required this.questionEn,
    required this.questionHi,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List? ?? [];
    return QuizQuestion(
      id: json['id'] ?? 0,
      questionEn: json['question']?['en'] ?? '',
      questionHi: json['question']?['hi'] ?? '',
      options: optionsJson
          .map((opt) => QuizOption.fromJson(opt as Map<String, dynamic>))
          .toList(),
      correctIndex: json['correctIndex'] ?? 0,
    );
  }

  String getQuestion(String lang) => lang == 'hi' ? questionHi : questionEn;
}

class QuizOption {
  final String en;
  final String hi;

  QuizOption({required this.en, required this.hi});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      en: json['en'] ?? '',
      hi: json['hi'] ?? '',
    );
  }

  String getText(String lang) => lang == 'hi' ? hi : en;
}

// For bulk loading topics from JSON list
List<Topic> topicsFromJson(String jsonStr) {
  final data = json.decode(jsonStr) as List;
  return data.map((item) => Topic.fromJson(item)).toList();
}

List<QuizQuestion> quizQuestionsFromJson(String jsonStr) {
  final data = json.decode(jsonStr) as List;
  return data.map((item) => QuizQuestion.fromJson(item)).toList();
}