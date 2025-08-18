import 'package:delivera/enum/delivery_detail_enum.dart';
import 'package:delivera/model/order_model.dart' show Order, StatusEnum;
import 'package:delivera/utils/format_date_time.dart';
import 'package:delivera/utils/format_price.dart';
import 'package:delivera/widget/pdf/price_pw_widget.dart';
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
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Toca un pedido para ver más detalles'),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemExtent: 70,
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              if (order == null) return const SizedBox.shrink();
              return _orderItem(order);
            },
          ),
        )
      ]),
    );
  }

  Widget _orderItem(Order order) {
    final [String date, String time] = formatDateTime(order.timestamp).split(', ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Table(
        children: [
          TableRow(
            children: [
              Text(
                'Pedido #${order.publicId}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                date,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          TableRow(children: [
            Text(
              formatPrice(order.total),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              time,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ]),
          TableRow(children: [
            Text(
              StatusEnum.fromName(order.status).label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
                children: switch (DeliveryDetailEnum.fromName(order.deliveryType)) {
              DeliveryDetailEnum.pickup => [
                  Icon(Icons.store, size: 16),
                  SizedBox(width: 4),
                  Text("Recoger", style: TextStyle(fontSize: 14, color: Colors.grey))
                ],
              DeliveryDetailEnum.dispatch => [
                  Icon(Icons.motorcycle, size: 16),
                  SizedBox(width: 4),
                  Text(
                    "Domicilio",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  )
                ],
              _ => [],
            })
          ])
        ],
      ),
    );
  }

  void addFakeOrders() {
    final ordersBox = Hive.box<Order>(name: 'orders');
    for (int i = 0; i < 10; i++) {
      var order = Order.some(publicId: i, status: StatusEnum.pending.name, deliveryType: DeliveryDetailEnum.pickup.name);
      ordersBox.put((order.publicId).toString(), order);
    }
  }
}
