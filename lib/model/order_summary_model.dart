import 'package:chifa_el_meson/model/delivery_zone_model.dart';
import 'package:chifa_el_meson/model/shopping_cart_model.dart';
import 'package:chifa_el_meson/model/user_details_model.dart';

class OrderSummary {
  DeliveryDetails details;
  UserDetails userDetails;
  ShoppingCart shoppingCart;
  OrderSummary(
      {required this.details,
      required this.userDetails,
      required this.shoppingCart});
  double get subtotal => shoppingCart.shoppingCartPrice;
  double get discount => shoppingCart.shoppingCartDiscount;
  double get deliveryCost {
    if (details is HomeDelivery) {
      return (details as HomeDelivery).zone.price;
    }
    return 0;
  }

  double get total => subtotal - discount + deliveryCost;
}

abstract class DeliveryDetails {}

class PickUp extends DeliveryDetails {
  final String address;
  PickUp({required this.address});
}

class HomeDelivery extends DeliveryDetails {
  final String address;
  final DeliveryZone zone;
  HomeDelivery({required this.address, required this.zone});
}
