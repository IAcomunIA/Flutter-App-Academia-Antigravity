class Category {
  final int? id;
  final String name;
  final String description;
  final String icon;
  final String color;
  final String difficulty;

  Category({this.id, required this.name, required this.description, required this.icon, required this.color, required this.difficulty});

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'],
    name: map['name'],
    description: map['description'],
    icon: map['icon'],
    color: map['color'],
    difficulty: map['difficulty'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'color': color,
    'difficulty': difficulty,
  };
}