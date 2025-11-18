import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
import 'package:delivera/model/shopping_cart_model.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

Future<void> initializeHive() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  Hive.registerAdapter('Order', Order.fromJson);
  Hive.registerAdapter('OrderTracking', OrderTracking.fromJson);
  Hive.registerAdapter('Cart', ShoppingCart.fromJson);
}