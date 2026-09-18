class LedgerModel {
  final int? id;
  final String name;
  final String currencyCode;
  final bool isClosed;
  final DateTime createdAt;

  LedgerModel({
    this.id,
    required this.name,
    required this.currencyCode,
    this.isClosed = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'currency_code': currencyCode,
      'is_closed': isClosed ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory LedgerModel.fromMap(Map<String, Object?> map) {
    return LedgerModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      currencyCode: map['currency_code'] as String,
      isClosed: (map['is_closed'] as int? ?? 0) == 1,
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
    );
  }
}
