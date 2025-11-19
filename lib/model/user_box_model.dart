import 'dart:developer' show log;
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/user_details_model.dart';
import 'package:hive/hive.dart' show Hive;

/// Guarda los ultimos inputs del usuario utilizados en una orden
class UserBox {
  String name;
  String email;
  String phone;
  int? deliveryZoneId;
  String? deliveryAddress;

  // static const List<String> keys = ['name', 'email', 'phone', 'deliveryZoneId', 'deliveryAddress'];

  UserBox(this.name, this.email, this.phone, this.deliveryZoneId, this.deliveryAddress);

  /// Crea un UserBox a partir de los inputs de un OrderSummary
  factory UserBox.fromSummary(UserDetails userDetails, DeliveryDetails deliveryDetails) {
    int? deliveryZoneId;
    String? deliveryAddress;
    if (deliveryDetails is Dispatch) {
      deliveryZoneId = deliveryDetails.zone.id;
      deliveryAddress = deliveryDetails.address;
    }
    return UserBox(
      userDetails.fullName,
      userDetails.email,
      userDetails.phoneNumber,
      deliveryZoneId,
      deliveryAddress,
    );
  }

  /// Guarda los ultimos inputs del usuario utilizados en una orden, en el almacenamiento local
  void store() {
    try {
      final userBox = Hive.box(name: 'user');
      userBox.putAll({
        'name': name,
        'email': email,
        'phone': phone,
      });
      if (deliveryZoneId != null && deliveryAddress != null) {
        userBox.putAll({
          'deliveryZoneId': deliveryZoneId,
          'deliveryAddress': deliveryAddress,
        });
      }
      userBox.close();
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  static UserBox? fromStorage() {
    final box = Hive.box(name: 'user');
    if (box.isEmpty) {
      box.close();
      return null;
    }

    UserBox? userBox;
    try {
      userBox = UserBox(
        box.get('name'),
        box.get('email'),
        box.get('phone'),
        box.get('deliveryZoneId'),
        box.get('deliveryAddress'),
      );
    } catch (e, stackTrace) {
      log("Error al obtener UserBox del almacenamiento: $e", stackTrace: stackTrace);
      userBox = null;
      box.clear();
    } finally {
      box.close();
    }

    return userBox;
  }

  bool isSameZone(int zoneId) {
    if (deliveryZoneId == null) return false;
    return deliveryZoneId == zoneId;
  }

  static void clearStorage() {
    final box = Hive.box(name: 'user');
    box.clear();
    box.close();
  }

  factory UserBox.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return UserBox(
      map['name'],
      map['email'],
      map['phone'],
      map['deliveryZoneId'],
      map['deliveryAddress'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'deliveryZoneId': deliveryZoneId,
        'deliveryAddress': deliveryAddress,
      };
}
