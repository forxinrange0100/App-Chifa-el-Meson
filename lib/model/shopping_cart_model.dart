import 'package:chifa_el_meson/model/cart_item_model.dart';

class ShoppingCart {
  List<CartItem> cartItems = [];
  ShoppingCart();
  int get shoppingCartPrice =>
      cartItems.fold(0, (total, cartItem) => total + cartItem.cartItemPrice);
  int get shoppingCartDiscount =>
      cartItems.fold(0, (total, cartItem) => total + cartItem.cartItemDiscount);
}
