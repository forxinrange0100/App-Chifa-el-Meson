import 'package:delivera/model/dish_model.dart';

class OrderProduct {
  final Dish product;
  final int quantity;
  final String note;
  OrderProduct({required this.product, required this.quantity, required this.note});

  factory OrderProduct.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return OrderProduct(product: Dish.fromJson(map['product']), quantity: map['quantity'], note: map['note']);
  }

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'note': note,
      };
}
