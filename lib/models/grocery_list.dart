import 'grocery_item.dart';
import 'list_icons.dart';

class GroceryList {
  const GroceryList({
    required this.id,
    required this.name,
    required this.items,
    required this.createdAt,
    this.icon,
  });

  final String id;
  final String name;
  final List<GroceryItem> items;
  final DateTime createdAt;

  /// Key into [listIcons], or `null` if the list has no icon.
  final String? icon;

  /// [icon] is a function so that passing one returning `null` clears the icon.
  GroceryList copyWith({
    String? name,
    List<GroceryItem>? items,
    String? Function()? icon,
  }) {
    return GroceryList(
      id: id,
      name: name ?? this.name,
      items: items ?? this.items,
      createdAt: createdAt,
      icon: icon != null ? icon() : this.icon,
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
      icon: json['icon'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((e) => e.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
        if (icon != null) 'icon': icon,
      };
}
