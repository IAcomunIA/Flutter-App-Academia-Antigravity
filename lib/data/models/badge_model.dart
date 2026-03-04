/// Modelo de badge/insignia desbloqueable
class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String conditionType;
  final int? conditionValue;
  final bool isEarned;
  final String? earnedAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.conditionType,
    this.conditionValue,
    this.isEarned = false,
    this.earnedAt,
  });

  factory BadgeModel.fromMap(Map<String, dynamic> map) => BadgeModel(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    icon: map['icon'],
    conditionType: map['condition_type'],
    conditionValue: map['condition_value'],
    isEarned: map['is_earned'] == 1,
    earnedAt: map['earned_at'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'condition_type': conditionType,
    'condition_value': conditionValue,
  };
}
