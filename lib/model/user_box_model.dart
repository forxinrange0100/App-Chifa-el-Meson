import 'dart:developer' show log;
import 'package:hive/hive.dart' show Box, Hive;

/// Guarda los ultimos inputs del usuario utilizados en una orden
class UserBox {
  String name;
  String email;
  String phone;
  int? deliveryZoneId;
  String? deliveryAddress;
  // static const List<String> keys = ['name', 'email', 'phone', 'deliveryZoneId', 'deliveryAddress'];

  UserBox(this.name, this.email, this.phone, this.deliveryZoneId, this.deliveryAddress);

  /// Instancia un UserBox a partir de una Box(name:'user')
  factory UserBox.fromBox(Box userBox) {
    return UserBox(
      userBox.get('name'),
      userBox.get('email'),
      userBox.get('phone'),
      userBox.get('deliveryZoneId'),
      userBox.get('deliveryAddress'),
    );
  }

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
