import 'package:delivera/model/delivery_zone_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:delivera/model/user_details_model.dart';

class OrderSummary {
  DeliveryDetails deliveryDetails;
  UserDetails userDetails;
  ShoppingCart shoppingCart;
  String paymentType;
  OrderSummary({required this.deliveryDetails, required this.userDetails, required this.shoppingCart, required this.paymentType});

  factory OrderSummary.empty() => OrderSummary(
      deliveryDetails: PickUp(address: ""),
      userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
      shoppingCart: ShoppingCart(),
      paymentType: "");
}

abstract class DeliveryDetails {
  int get cost => 0;
}

class PickUp extends DeliveryDetails {
  final String address;
  PickUp({required this.address});
}

class Dispatch extends DeliveryDetails {
  String address;
  final DeliveryZone zone;
  Dispatch({required this.address, required this.zone});
  @override
  int get cost => zone.price;
}
