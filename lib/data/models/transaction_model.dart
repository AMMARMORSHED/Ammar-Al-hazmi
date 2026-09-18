class TransactionModel {
  final int? id;
  final int ledgerId;
  final int personId;
  final String type;
  final double amount;
  final DateTime date;
  final String description;
  final String category;
  final String notes;

  const TransactionModel({
    this.id,
    required this.ledgerId,
    required this.personId,
    required this.type,
    required this.amount,
    required this.date,
    this.description = '',
    this.category = '',
    this.notes = '',
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'ledger_id': ledgerId,
      'person_id': personId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'category': category,
      'notes': notes,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, Object?> map) {
    return TransactionModel(
      id: map['id'] as int?,
      ledgerId: map['ledger_id'] as int,
      personId: map['person_id'] as int,
      type: map['type'] as String,
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.tryParse(map['date'] as String? ?? DateTime.now().toIso8601String()) ?? DateTime.now(),
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }
}
