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

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      name: json['name'],
      description: json['description'],
      regularPrice: json['regular_price'],
      discountedPrice: json['discounted_price'],
      image: json['image'],
      categoryId: json['category_id'],
      enabled: json['enabled'] == 1 ? true : false,
      displayOrder: json['display_order'],
      units: json['units']);

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
