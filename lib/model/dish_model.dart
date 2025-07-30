class Dish {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final int regularPrice;
  final int? _discountedPrice;
  final String image;
  final int categoryId;
  final bool enabled;
  final int displayOrder;
  final int units;

  int get discountedPrice => _discountedPrice ?? 0;

  Dish(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.description,
      required this.regularPrice,
      int? discountedPrice,
      required this.image,
      required this.categoryId,
      required this.enabled,
      required this.displayOrder,
      required this.units}): _discountedPrice = discountedPrice;
}
