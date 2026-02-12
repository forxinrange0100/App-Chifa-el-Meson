// import 'package:hive_ce/hive_ce.dart';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:delivera/hive/hive_registrar.g.dart';
// import 'package:delivera/model/order_model.dart' show Order;
// import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
// import 'package:delivera/model/shopping_cart_model.dart';
// import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

Future<void> initializeHive() async {
  // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  await Hive.initFlutter();
  Hive.registerAdapters();

  // Hive.registerAdapter('Order', Order.fromJson);
  // Hive.registerAdapter('OrderTracking', OrderTracking.fromJson);
  // Hive.registerAdapter('Cart', ShoppingCart.fromJson);
  await Future.wait([
    Hive.openBox<Order>('orders'),
    Hive.openBox<OrderTracking>('ordersTracking'),
    Hive.openBox('notification'),
    Hive.openBox('payment'),
    Hive.openBox('cart'),
    Hive.openBox('user'),
  ]);
}

void closeHive() {
  Hive.close();
}

extension HiveBoxExtension on Box {
  List<T?> getAll<T>(List keys) => keys.map((key) => get(key) as T?).toList();
}
