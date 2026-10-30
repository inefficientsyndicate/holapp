import 'grocery_item.dart';

class GroceryList {
  const GroceryList({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<GroceryItem> items;
  final DateTime createdAt;

  GroceryList copyWith({String? name, List<GroceryItem>? items}) {
    return GroceryList(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
    );
  }

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    return GroceryList(
      id: json['id'] as String,
      name: json['name'] as String,
      items: (json['items'] as List)
          .map((e) => GroceryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };
}
