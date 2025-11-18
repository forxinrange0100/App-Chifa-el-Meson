import 'package:delivera/enum/payment_type_enum.dart';
import 'package:delivera/model/delivery_zone_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:delivera/model/user_details_model.dart';

class OrderSummary {
  DeliveryDetails deliveryDetails;
  UserDetails userDetails;
  ShoppingCart shoppingCart;
  PaymentTypeEnum paymentType = PaymentTypeEnum.unknown;

  OrderSummary({
    required this.deliveryDetails,
    required this.userDetails,
    required this.shoppingCart,
    required this.paymentType,
  });

  factory OrderSummary.empty() => OrderSummary(
        deliveryDetails: PickUp(),
        userDetails: UserDetails(fullName: "", email: "", phoneNumber: ""),
        shoppingCart: ShoppingCart(),
        paymentType: PaymentTypeEnum.unknown,
      );
}

abstract class DeliveryDetails {
  int get cost;
  String? address;
  DeliveryZone? zone;

  String get name;
}

class PickUp extends DeliveryDetails {
  @override
  int get cost => 0;

  @override
  String get name => 'pickup';
}

class Dispatch extends DeliveryDetails {
  final String _address;

  @override
  String get address => _address;

  final DeliveryZone _zone;

  @override
  DeliveryZone get zone => _zone;

  @override
  int get cost => _zone.price;

  Dispatch({required String address, required DeliveryZone zone})
      : _address = address,
        _zone = zone;

  @override
  String get name => 'dispatch';
}
