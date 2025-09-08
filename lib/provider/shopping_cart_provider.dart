import 'package:delivera/model/cart_item_model.dart';
import 'package:delivera/model/dish_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:flutter/material.dart';

class ShoppingCartProvider extends ChangeNotifier {
  ShoppingCart _shoppingCart = ShoppingCart();

  ShoppingCart get shoppingCart => _shoppingCart;

  ShoppingCartProvider();

  /// Number of items in the cart
  int get length => _shoppingCart.cartItems.length;
  /// List of all cart items
  List<CartItem> get cartItems => _shoppingCart.cartItems;
  /// Total price of the cart without discounts
  int get subtotal => _shoppingCart.regularPrice;
  /// Total price of the cart with discounts applied
  int get discount => _shoppingCart.regularPrice - _shoppingCart.discountedPrice;

  void addCartItem(Dish dish, int quantity, String preferenceNote) {
    _shoppingCart.cartItems.add(CartItem(dish: dish, quantity: quantity, notes: preferenceNote));
    notifyListeners();
  }

  void addCartItems(List<CartItem> items) {
    _shoppingCart.cartItems.addAll(items);
    notifyListeners();
  }

  void removeCartItem(String id) {
    _shoppingCart.cartItems = _shoppingCart.cartItems.where((cartItem) {
      return cartItem.id != id;
    }).toList();
    notifyListeners();
  }

  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity == 1) return;
    cartItem.quantity--;
    notifyListeners();
  }

  void setPreference(String id, String preference) {
    _shoppingCart.cartItems = _shoppingCart.cartItems.map((cartItem) {
      if (cartItem.id == id) {
        cartItem.notes = preference;
      }
      return cartItem;
    }).toList();
    notifyListeners();
  }

  void cleanShoppingCart() {
    _shoppingCart = ShoppingCart();
    notifyListeners();
  }
}
