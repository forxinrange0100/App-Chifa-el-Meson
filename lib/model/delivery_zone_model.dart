class DeliveryZone {
  final int id;
  // final DateTime createdAt;
  // final DateTime updatedAt;
  final String name;
  final int price;
  
  DeliveryZone({
    required this.id,
    // required this.createdAt,
    // required this.updatedAt,
    required this.name,
    required this.price,
  });

  factory DeliveryZone.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return DeliveryZone(
      id: map['id'],
      // createdAt: DateTime.parse(map['created_at']),
      // updatedAt: DateTime.parse(map['updated_at']),
      name: map['name'],
      price: map['price'],
    );
  }
}
