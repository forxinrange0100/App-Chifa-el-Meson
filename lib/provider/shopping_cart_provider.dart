import 'package:delivera/model/cart_item_model.dart';
import 'package:delivera/model/product_model.dart';
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
  int get subtotal => _shoppingCart.subtotal;
  /// Total price of the cart with discounts applied
  int get total => _shoppingCart.total;
  /// Total discounts
  int get discounts => _shoppingCart.discounts;

  void setCart(ShoppingCart cart) {
    _shoppingCart = cart;
    notifyListeners();
  }

  void addCartItem(Product product, int quantity, String preferenceNote) {
    _shoppingCart.add(CartItem(product: product, quantity: quantity, notes: preferenceNote));
    notifyListeners();
  }

  void addCartItems(List<CartItem> items) {
    _shoppingCart.cartItems.addAll(items);
    notifyListeners();
  }

  void removeCartItem(String id) {
    _shoppingCart.remove(id);
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

  void setNotes(String id, String notes) {
    _shoppingCart.setNotes(id, notes);
    notifyListeners();
  }

  void cleanShoppingCart() {
    _shoppingCart = ShoppingCart();
    notifyListeners();
  }
}
