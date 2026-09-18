class PersonModel {
  final int? id;
  final int ledgerId;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final String kind;
  final String? photoPath;

  const PersonModel({
    this.id,
    required this.ledgerId,
    required this.name,
    this.phone = '',
    this.address = '',
    this.notes = '',
    this.kind = 'person',
    this.photoPath,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'ledger_id': ledgerId,
      'name': name,
      'phone': phone,
      'address': address,
      'notes': notes,
      'kind': kind,
      'photo_path': photoPath,
    };
  }

  factory PersonModel.fromMap(Map<String, Object?> map) {
    return PersonModel(
      id: map['id'] as int?,
      ledgerId: map['ledger_id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String? ?? '',
      address: map['address'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      kind: map['kind'] as String? ?? 'person',
      photoPath: map['photo_path'] as String?,
    );
  }
}
