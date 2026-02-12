

import 'dart:developer';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/utils/initialize_hive.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:hive_ce/hive_ce.dart' show Hive;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  // Hive.registerAdapter('Order', Order.fromJson);
  // readAll();
  await initializeHive();
  // delete(100001);
  deleteAll();
  log("Finished.");
}

void readAll() {
  final ordersBox = Hive.box<Order>('orders');
  final List<Order?> orders = ordersBox.getAll(ordersBox.keys.toList());
  for (var order in orders) {
    if (order == null) continue;
    log(order.toJson().toString());
  }
}

void delete(int publicId) {
  final ordersBox = Hive.box<Order>('orders');
  ordersBox.delete(publicId.toString());
}

void deleteAll() {
  final ordersBox = Hive.box<Order>('orders');
  ordersBox.clear();
}