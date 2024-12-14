import 'package:chifa_el_meson/model/dish_model.dart';

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
  int get cartItemPrice => dish.regularPrice * quantity;
  int get cartItemDiscount => dish.discountedPrice * quantity;
}
