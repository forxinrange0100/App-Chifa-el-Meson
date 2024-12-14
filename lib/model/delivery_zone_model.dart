class DeliveryZone {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final int price;
  DeliveryZone(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.price});
}
