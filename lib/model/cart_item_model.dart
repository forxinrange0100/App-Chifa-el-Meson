import 'package:delivera/model/dish_model.dart';

class CartItem {
  final String id;
  final Dish dish;
  int quantity;
  String preferenceNote;
  CartItem(
      {required this.dish,
      required this.quantity,
      required this.preferenceNote})
      : id = DateTime.now().millisecondsSinceEpoch.toString();
  int get cartItemRegularPrice => dish.regularPrice * quantity;
  int get cartItemDisccountedPrice => dish.discountedPrice * quantity;
}
