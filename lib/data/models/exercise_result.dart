/// Resultado de un ejercicio interactivo completado
class ExerciseResult {
  final int? id;
  final int userId;
  final int exerciseItemId;
  final String exerciseType;
  final bool isCorrect;
  final int score;
  final int? timeSeconds;
  final int xpEarned;
  final String completedAt;

  ExerciseResult({
    this.id,
    required this.userId,
    required this.exerciseItemId,
    required this.exerciseType,
    required this.isCorrect,
    this.score = 0,
    this.timeSeconds,
    this.xpEarned = 0,
    required this.completedAt,
  });

  factory ExerciseResult.fromMap(Map<String, dynamic> map) => ExerciseResult(
    id: map['id'],
    userId: map['user_id'],
    exerciseItemId: map['exercise_item_id'],
    exerciseType: map['exercise_type'],
    isCorrect: map['is_correct'] == 1,
    score: map['score'] ?? 0,
    timeSeconds: map['time_seconds'],
    xpEarned: map['xp_earned'] ?? 0,
    completedAt: map['completed_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'exercise_item_id': exerciseItemId,
    'exercise_type': exerciseType,
    'is_correct': isCorrect ? 1 : 0,
    'score': score,
    'time_seconds': timeSeconds,
    'xp_earned': xpEarned,
    'completed_at': completedAt,
  };
}
