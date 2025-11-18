import 'package:delivera/model/dish_model.dart';
import 'package:flutter/foundation.dart' show UniqueKey;

class CartItem {
  final String id;
  final Dish product;
  int quantity;
  String notes;

  /// Total price of the item without discount
  int get regularPrice => product.regularPrice * quantity;

  /// Total price of the item with discount applied, if any
  int get totalPrice => product.price * quantity;

  /// Total discount of the item
  int get discounts => regularPrice - totalPrice;


  CartItem({
    required this.product,
    required this.quantity,
    required this.notes,
  }) : id = UniqueKey().toString();

  factory CartItem.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return CartItem(
      product: Dish.fromJson(map['product']),
      quantity: map['quantity'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'notes': notes,
      };
}
