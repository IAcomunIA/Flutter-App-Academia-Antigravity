/// Resultado de un quiz completado
class QuizResult {
  final int? id;
  final int userId;
  final int subcategoryId;
  final String level; // basico|intermedio|avanzado
  final int score;
  final int correctCount;
  final int totalQuestions;
  final double percentage;
  final int? timeSeconds;
  final int xpEarned;
  final int starsEarned;
  final String completedAt;

  QuizResult({
    this.id,
    required this.userId,
    required this.subcategoryId,
    this.level = 'basico',
    required this.score,
    required this.correctCount,
    required this.totalQuestions,
    required this.percentage,
    this.timeSeconds,
    this.xpEarned = 0,
    this.starsEarned = 0,
    required this.completedAt,
  });

  factory QuizResult.fromMap(Map<String, dynamic> map) => QuizResult(
    id: map['id'],
    userId: map['user_id'],
    subcategoryId: map['subcategory_id'],
    level: map['level'] ?? 'basico',
    score: map['score'],
    correctCount: map['correct_count'],
    totalQuestions: map['total_questions'],
    percentage: (map['percentage'] ?? 0.0).toDouble(),
    timeSeconds: map['time_seconds'],
    xpEarned: map['xp_earned'] ?? 0,
    starsEarned: map['stars_earned'] ?? 0,
    completedAt: map['completed_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'subcategory_id': subcategoryId,
    'level': level,
    'score': score,
    'correct_count': correctCount,
    'total_questions': totalQuestions,
    'percentage': percentage,
    'time_seconds': timeSeconds,
    'xp_earned': xpEarned,
    'stars_earned': starsEarned,
    'completed_at': completedAt,
  };
}
