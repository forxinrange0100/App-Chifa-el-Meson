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
      required this.units})
      : _discountedPrice = discountedPrice;

  factory Dish.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return Dish(
        id: map['id'],
        createdAt: DateTime.parse(map['created_at']),
        updatedAt: DateTime.parse(map['updated_at']),
        name: map['name'],
        description: map['description'],
        regularPrice: map['regular_price'],
        discountedPrice: map['discounted_price'],
        image: map['image'],
        categoryId: map['category_id'],
        enabled: map['enabled'] == 1 ? true : false,
        displayOrder: map['display_order'],
        units: map['units']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'name': name,
        'description': description,
        'regular_price': regularPrice,
        'discounted_price': discountedPrice,
        'image': image,
        'category_id': categoryId,
        'enabled': enabled ? 1 : 0,
        'display_order': displayOrder,
        'units': units
      };
}
