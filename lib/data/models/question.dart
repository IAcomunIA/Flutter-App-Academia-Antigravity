class Question {
  final int? id;
  final int subcategoryId;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctOption;
  final String explanation;
  final String difficulty;
  final String level; // basico|intermedio|avanzado
  final int points;
  final int timeLimitSeconds;

  Question({
    this.id,
    required this.subcategoryId,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.explanation,
    this.difficulty = 'medio',
    this.level = 'basico',
    this.points = 10,
    this.timeLimitSeconds = 30,
  });

  factory Question.fromMap(Map<String, dynamic> map) => Question(
    id: map['id'],
    subcategoryId: map['subcategory_id'],
    questionText: map['question_text'],
    optionA: map['option_a'],
    optionB: map['option_b'],
    optionC: map['option_c'],
    optionD: map['option_d'],
    correctOption: map['correct_option'],
    explanation: map['explanation'] ?? '',
    difficulty: map['difficulty'] ?? 'medio',
    level: map['level'] ?? 'basico',
    points: map['points'] ?? 10,
    timeLimitSeconds: map['time_limit_seconds'] ?? 30,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'subcategory_id': subcategoryId,
    'question_text': questionText,
    'option_a': optionA,
    'option_b': optionB,
    'option_c': optionC,
    'option_d': optionD,
    'correct_option': correctOption,
    'explanation': explanation,
    'difficulty': difficulty,
    'level': level,
    'points': points,
    'time_limit_seconds': timeLimitSeconds,
  };
}
