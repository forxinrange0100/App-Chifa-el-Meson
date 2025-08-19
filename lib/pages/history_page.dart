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
      body: orders.isEmpty
          ? Center(
              child: Text(
                "No tienes pedidos aún",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            )
          : _buildOrderList(orders),
    );
  }

  Column _buildOrderList(List<Order?> orders) {
    return Column(children: [
      Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: BoxBorder.fromLTRB(bottom: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Text(
          'Toca un pedido para ver más detalles',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          // itemExtent: 70,
          itemCount: orders.length,
          itemBuilder: (context, index) => _orderItem(orders[index]!),
          separatorBuilder: (context, index) => Divider(color: Colors.grey[500]),
        ),
      )
    ]);
  }

  Widget _orderItem(Order order) {
    final [String date, String time] = formatDateTime(order.timestamp).split(', ');

    return Table(
      children: [
        TableRow(children: [
          Text(
            'Pedido #${order.publicId}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            date,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.end,
          ),
        ]),
        TableRow(children: [
          Text(
            formatPrice(order.total),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.end,
          ),
        ]),
        TableRow(children: [
          Text(
            StatusEnum.fromName(order.status).label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: switch (DeliveryDetailEnum.fromName(order.deliveryType)) {
              DeliveryDetailEnum.pickup => [
                  Icon(Icons.store, size: 16),
                  SizedBox(width: 4),
                  Text("Recoger", style: TextStyle(fontSize: 14, color: Colors.grey))
                ],
              DeliveryDetailEnum.dispatch => [
                  Icon(Icons.motorcycle, size: 16),
                  SizedBox(width: 4),
                  Text("Domicilio", style: TextStyle(fontSize: 14, color: Colors.grey))
                ],
              _ => [],
            },
          )
        ])
      ],
    );
  }

  void addFakeOrders() {
    final ordersBox = Hive.box<Order>(name: 'orders');
    const from = 1001;
    const to = 1010;
    final status = StatusEnum.pending.name;
    final deliveryType = DeliveryDetailEnum.dispatch.name;
    const total = 20000;
    for (int i = from; i < to + 1; i++) {
      var order = Order.some(publicId: i, status: status, deliveryType: deliveryType, total: total);
      ordersBox.put((order.publicId).toString(), order);
    }
  }
}
