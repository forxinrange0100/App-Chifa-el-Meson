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
      required this.enabled,
      required this.displayOrder,
      int? units})
      : discountedPrice = discountedPrice ?? 0,
        categoryId = categoryId ?? 0,
        units = units ?? 0;

  Dish copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? name,
    String? description,
    int? regularPrice,
    int? discountedPrice,
    String? image,
    int? categoryId,
    bool? enabled,
    int? displayOrder,
    int? units,
  }) {
    return Dish(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      name: name ?? this.name,
      description: description ?? this.description,
      regularPrice: regularPrice ?? this.regularPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      image: image ?? this.image,
      categoryId: categoryId ?? this.categoryId,
      enabled: enabled ?? this.enabled,
      displayOrder: displayOrder ?? this.displayOrder,
      units: units ?? this.units,
    );
  }

  factory Dish.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    map['created_at'] = map['createdAt'] ?? DateTime.now().toString();
    map['updated_at'] = map['updatedAt'] ?? DateTime.now().toString();

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
        enabled: dynamicToBool(map['enabled'], defaultValue: true),
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
