import 'package:chifa_el_meson/model/cart_item_model.dart';
import 'package:chifa_el_meson/model/dish_model.dart';
import 'package:chifa_el_meson/model/shopping_cart_model.dart';
import 'package:flutter/material.dart';

class ShoppingCartProvider extends ChangeNotifier {
  ShoppingCart _cardItems = ShoppingCart();

  ShoppingCartProvider();

  int get length => _cardItems.cartItems.length;
  List<CartItem> get cardItems => _cardItems.cartItems;
  ShoppingCart get shoppingCart => _cardItems;

  int get subtotal => _cardItems.shoppingCartRegularPrice;
  int get discount =>
      _cardItems.shoppingCartRegularPrice -
      _cardItems.shoppingCartDiscountedPrice;

  void addCardItem(Dish dish, int quantity, String preferenceNote) {
    _cardItems.cartItems.add(CartItem(
        dish: dish, quantity: quantity, preferenceNote: preferenceNote));
    notifyListeners();
  }

  void removeCardItem(String id) {
    _cardItems.cartItems = _cardItems.cartItems.where((cartItem) {
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
    _cardItems.cartItems = _cardItems.cartItems.map((cartItem) {
      if (cartItem.id == id) {
        cartItem.preferenceNote = preference;
      }
      return cartItem;
    }).toList();
    notifyListeners();
  }

  void cleanShoppingCart() {
    _cardItems = ShoppingCart();
    notifyListeners();
  }
}
