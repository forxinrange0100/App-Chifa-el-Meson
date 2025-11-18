import 'package:delivera/model/cart_item_model.dart';
import 'package:hive/hive.dart' show Hive;

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
    final box = Hive.box(name: 'cart');
    box.put('cart', this);
    box.close();
  }

  static ShoppingCart? fromStorage() {
    final box = Hive.box(name: 'cart');
    if (box.isEmpty) return null;
    return box.get('cart');
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
