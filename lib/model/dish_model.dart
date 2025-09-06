import 'package:delivera/environment.dart' show Urls;
import 'package:delivera/utils/conversions.dart';
import '../utils/format_price.dart' show formatPrice;

class Dish {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final int regularPrice;
  late final int discountedPrice;
  final String? image;
  late final int categoryId;
  late final bool enabled;
  final int displayOrder;
  final int units;

  int get price => discountedPrice != 0 ? discountedPrice : regularPrice;

  String get formattedPrice => formatPrice(price);

  String get formattedDiscountedPrice => formatPrice(discountedPrice);

  String get formattedRegularPrice => formatPrice(regularPrice);

  String get imageUrl => image == null || image!.endsWith('null') ? 'https://chifaelmeson.cl/img/default.webp' : "${Urls.apiUrl}/storage/$image";

  Dish(
      {required this.id,
      required this.createdAt,
      required this.updatedAt,
      required this.name,
      required this.description,
      required this.regularPrice,
      int? discountedPrice,
      this.image,
      int? categoryId,
      required int enabled,
      required this.displayOrder,
      required this.units})
      : discountedPrice = discountedPrice ?? 0,
        categoryId = categoryId ?? 0,
        enabled = intToBool(enabled);

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
        enabled: map['enabled'],
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
        'enabled': boolToInt(enabled),
        'display_order': displayOrder,
        'units': units
      };
}
