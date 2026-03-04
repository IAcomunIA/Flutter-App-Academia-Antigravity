/// Progreso de un usuario en un nivel específico de una subcategoría
class LevelProgress {
  final int? id;
  final int userId;
  final int subcategoryId;
  final String level; // basico|intermedio|avanzado
  final int stars; // 0, 1, 2, 3
  final int bestScore;
  final double bestPercentage;
  final int attempts;
  final String? completedAt;

  LevelProgress({
    this.id,
    required this.userId,
    required this.subcategoryId,
    required this.level,
    this.stars = 0,
    this.bestScore = 0,
    this.bestPercentage = 0.0,
    this.attempts = 0,
    this.completedAt,
  });

  bool get isCompleted => stars > 0;

  /// Verifica si el siguiente nivel está desbloqueado
  /// Intermedio: requiere ≥1 estrella en básico
  /// Avanzado: requiere ≥2 estrellas en intermedio
  static bool isLevelUnlocked(String level, LevelProgress? previousLevel) {
    switch (level) {
      case 'basico':
        return true; // Siempre desbloqueado
      case 'intermedio':
        return previousLevel != null && previousLevel.stars >= 1;
      case 'avanzado':
        return previousLevel != null && previousLevel.stars >= 2;
      default:
        return false;
    }
  }

  factory LevelProgress.fromMap(Map<String, dynamic> map) => LevelProgress(
    id: map['id'],
    userId: map['user_id'],
    subcategoryId: map['subcategory_id'],
    level: map['level'],
    stars: map['stars'] ?? 0,
    bestScore: map['best_score'] ?? 0,
    bestPercentage: (map['best_percentage'] ?? 0.0).toDouble(),
    attempts: map['attempts'] ?? 0,
    completedAt: map['completed_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'user_id': userId,
    'subcategory_id': subcategoryId,
    'level': level,
    'stars': stars,
    'best_score': bestScore,
    'best_percentage': bestPercentage,
    'attempts': attempts,
    'completed_at': completedAt,
  };

  LevelProgress copyWith({
    int? id,
    int? userId,
    int? subcategoryId,
    String? level,
    int? stars,
    int? bestScore,
    double? bestPercentage,
    int? attempts,
    String? completedAt,
  }) {
    return LevelProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      level: level ?? this.level,
      stars: stars ?? this.stars,
      bestScore: bestScore ?? this.bestScore,
      bestPercentage: bestPercentage ?? this.bestPercentage,
      attempts: attempts ?? this.attempts,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
