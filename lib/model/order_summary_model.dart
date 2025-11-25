import 'package:delivera/enum/payment_type_enum.dart';
import 'package:delivera/model/delivery_zone_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:delivera/model/user_box_model.dart' show UserBox;
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

  /// Guarda los datos del usuario y el carrito en el almacenamiento local
  void store() {
    final userBox = UserBox.fromSummary(userDetails, deliveryDetails);
    userBox.store();
    shoppingCart.store();
  }
}

abstract class DeliveryDetails {
  String get name;
  int get cost => 0;
  String? get address => null; 
  DeliveryZone? get zone => null;
}

class PickUp extends DeliveryDetails {
  @override
  String get name => 'pickup';
}

class Dispatch extends DeliveryDetails {
  @override
  String get name => 'dispatch';

  @override
  String address;

  @override
  DeliveryZone zone;

  @override
  int get cost => zone.price;

  Dispatch({this.address = '', required this.zone});
}
