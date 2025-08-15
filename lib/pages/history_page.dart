import 'package:delivera/model/order_model.dart' show Order;
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersBox = Hive.box<Order>(name: 'orders');
    final List<Order?> orders = ordersBox.getAll(ordersBox.keys.toList());
    addFakeOrders();
    for (var order in orders) {
      if (order == null) continue;
      // Aquí puedes procesar cada order como desees
      print(order.toJson());
    }

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        title: const Text(
          "Historial",
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
                (orders[0]?.toJson()).toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void addFakeOrders() {
    final ordersBox = Hive.box<Order>(name: 'orders');
    for (int i = 0; i < 10; i++) {
      var order = Order.some(publicId: i);
      ordersBox.put((order.publicId).toString(), order);
    }
  }
}
