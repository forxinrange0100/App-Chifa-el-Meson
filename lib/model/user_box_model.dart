import 'package:hive/hive.dart' show Box;

/// Guarda los ultimos inputs del usuario utilizados en una orden
class UserBox {
  String name;
  String email;
  String phone;
  int? deliveryZoneId;
  String? deliveryAddress;
  static const List<String> keys = ['name', 'email', 'phone', 'deliveryZoneId', 'deliveryAddress'];

  UserBox(this.name, this.email, this.phone, this.deliveryZoneId, this.deliveryAddress);

  /// Instancia un UserBox a partir de una Box(name:'user')
  factory UserBox.fromBox(Box userBox) => UserBox.fromValues(userBox.getAll(keys));

  /// Instancia un UserBox a partir de una lista de valores
  factory UserBox.fromValues(List<dynamic> values) {
    return Function.apply(UserBox.new, values) as UserBox;
  }
}
