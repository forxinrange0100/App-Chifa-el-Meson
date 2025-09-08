import 'package:delivera/model/dish_model.dart';

class CartItem {
  final String id;
  final Dish dish;
  int quantity;
  String notes;

  /// Total price of the item without discount
  int get regularPrice => dish.regularPrice * quantity;
  /// Total price of the item with discount applied, if any
  int get discountedPrice => dish.discountedPrice * quantity;

  CartItem({required this.dish, required this.quantity, required this.notes}) : id = DateTime.now().millisecondsSinceEpoch.toString();
}
