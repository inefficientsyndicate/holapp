class GroceryItem {
  const GroceryItem({
    required this.id,
    required this.name,
    required this.addedAt,
  });

  final String id;
  final String name;
  final DateTime addedAt;

  GroceryItem copyWith({String? name}) {
    return GroceryItem(id: id, name: name ?? this.name, addedAt: addedAt);
  }

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'addedAt': addedAt.toIso8601String(),
      };
}
