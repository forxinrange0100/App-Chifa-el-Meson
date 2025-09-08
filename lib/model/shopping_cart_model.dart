import 'package:delivera/model/cart_item_model.dart';

class ShoppingCart {
  List<CartItem> cartItems = [];

  /// Total price of the cart without discount
  int get regularPrice => cartItems.fold(0, (total, cartItem) => total + cartItem.regularPrice);

  /// Total price of the cart with discount applied, if any
  int get discountedPrice => cartItems.fold(
      0, (total, cartItem) => total + (cartItem.discountedPrice != 0 ? cartItem.discountedPrice : cartItem.regularPrice));
  
  ShoppingCart();
}
