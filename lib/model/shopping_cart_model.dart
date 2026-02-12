import 'dart:developer' show log;

import 'package:delivera/model/cart_item_model.dart';
import 'package:hive_ce/hive_ce.dart' show Hive;

class ShoppingCart {
  List<CartItem> _cartItems;
  List<CartItem> get cartItems => _cartItems;

  /// Total price of the cart without discount
  int get subtotal => _cartItems.fold(0, (total, cartItem) => total + cartItem.regularPrice);

  /// Total price of the cart with discount applied, if any
  int get total => _cartItems.fold(0, (total, cartItem) => total + (cartItem.totalPrice));

  /// Total discounts
  int get discounts => _cartItems.fold(0, (total, cartItem) => total + cartItem.discounts);

  ShoppingCart({List<CartItem>? cartItems}) : _cartItems = cartItems ?? [];

  void add(CartItem cartItem) {
    _cartItems.add(cartItem);
  }

  void addAll(List<CartItem> cartItems) {
    _cartItems.addAll(cartItems);
  }

  void remove(String cartItemId) {
    _cartItems.removeWhere((cartItem) => cartItem.id == cartItemId);
  }

  void setNotes(String id, String notes) {
    _cartItems.firstWhere((cartItem) => cartItem.id == id).notes = notes;
  }

  void store() {
    try {
      final box = Hive.box('cart');
      box.put('cart', this);
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  static ShoppingCart? fromStorage() {
    try {
      final box = Hive.box('cart');
      if (box.isEmpty) return null;
      return box.get('cart');
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      return null;
    }
  }

  /// Borra el carrito del almacenamiento local
  /// Debe ejecutarse después de que se haya terminado la compra (al ver la boleta)
  static void clearStorage() {
    try {
      final box = Hive.box('cart');
      box.clear();
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  factory ShoppingCart.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;

    return ShoppingCart(
      cartItems: List<CartItem>.from(map['cart_items'].map((x) => CartItem.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'cart_items': cartItems.map((x) => x.toJson()).toList(),
      };
}
