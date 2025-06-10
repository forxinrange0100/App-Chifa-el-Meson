import 'package:delivera/model/delivery_zone_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:delivera/model/user_details_model.dart';

class OrderSummary {
  DeliveryDetails details;
  UserDetails userDetails;
  ShoppingCart shoppingCart;
  String paymentType;
  OrderSummary(
      {required this.details,
      required this.userDetails,
      required this.shoppingCart,
      required this.paymentType});
}

abstract class DeliveryDetails {
  int get cost => 0;
}

class PickUp extends DeliveryDetails {
  final String address;
  PickUp({required this.address});
}

class HomeDelivery extends DeliveryDetails {
  String address;
  final DeliveryZone zone;
  HomeDelivery({required this.address, required this.zone});
  @override
  int get cost => zone.price;
}
