class Subcategory {
  final int? id;
  final int categoryId;
  final String name;
  final String description;

  Subcategory({this.id, required this.categoryId, required this.name, required this.description});

  factory Subcategory.fromMap(Map<String, dynamic> map) => Subcategory(
    id: map['id'],
    categoryId: map['category_id'],
    name: map['name'],
    description: map['description'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'category_id': categoryId,
    'name': name,
    'description': description,
  };
}