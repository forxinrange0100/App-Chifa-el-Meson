import 'package:delivera/model/dish_model.dart';

class OrderProduct {
  final Dish product;
  final int quantity;
  final String note;
  OrderProduct({required this.product, required this.quantity, required this.note});

  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      OrderProduct(product: Dish.fromJson(json['product']), quantity: json['quantity'], note: json['note']);

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
        'note': note,
      };
}
