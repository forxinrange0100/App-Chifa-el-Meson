import 'package:delivera/model/dish_model.dart';

class OrderProductResultFull {
  final Dish product;
  final int quantity;
  final String note;
  OrderProductResultFull(
      {required this.product, required this.quantity, required this.note});
}
