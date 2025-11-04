import 'dart:developer';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  // readAll();
  // delete(100001);
  deleteAll();
  log("Finished.");
}

// void readAll() {
//   final ordersBox = Hive.box(name: 'user');
//   final List<Order?> orders = ordersBox.getAll(ordersBox.keys.toList());
//   for (var order in orders) {
//     if (order == null) continue;
//     log(order.toJson().toString());
//   }
// }

// void delete(int publicId) {
//   final ordersBox = Hive.box<Order>(name: 'orders');
//   ordersBox.delete(publicId.toString());
// }

void deleteAll() {
  final userBox = Hive.box<Order>(name: 'user');
  userBox.clear();
}