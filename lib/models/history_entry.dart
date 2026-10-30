class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.listId,
    required this.itemName,
    required this.listName,
    required this.removedAt,
  });

  final String id;
  final String listId;
  final String itemName;
  final String listName;
  final DateTime removedAt;

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      // Entries saved before per-list history was added have no listId.
      listId: json['listId'] as String? ?? '',
      itemName: json['itemName'] as String,
      listName: json['listName'] as String,
      removedAt: DateTime.parse(json['removedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'listId': listId,
        'itemName': itemName,
        'listName': listName,
        'removedAt': removedAt.toIso8601String(),
      };
}
