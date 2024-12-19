import 'package:chifa_el_meson/model/cart_item_model.dart';

class ShoppingCart {
  List<CartItem> cartItems = [];
  ShoppingCart();
  int get shoppingCartRegularPrice => cartItems.fold(
      0, (total, cartItem) => total + cartItem.cartItemRegularPrice);

  int get shoppingCartDiscountedPrice => cartItems.fold(
      0,
      (total, cartItem) =>
          total +
          (cartItem.cartItemDisccountedPrice != 0
              ? cartItem.cartItemDisccountedPrice
              : cartItem.cartItemRegularPrice));
}
