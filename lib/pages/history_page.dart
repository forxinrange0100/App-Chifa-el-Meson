import 'package:delivera/enum/delivery_detail_enum.dart';
import 'package:delivera/model/order_model.dart' show Order, StatusEnum;
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/provider/bottom_navigation_bar_provider.dart' show BottomNavigationBarProvider;
import 'package:delivera/utils/format_date_time.dart';
import 'package:delivera/utils/format_price.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:hive/hive.dart' show Hive;
import 'package:provider/provider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersBox = Hive.box<Order>(name: 'orders');
    final List<Order?> orders = ordersBox.getAll(ordersBox.keys).reversed.toList();
    // addFakeOrders();
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
          "HISTORIAL",
        ),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.clipboardList,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 50),
                  child: const Text("No hay pedidos anteriores", style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton.icon(
                  icon: const Icon(FontAwesomeIcons.cartShopping),
                  label: const Text("Ir a comprar"),
                  onPressed: () {
                    context.read<BottomNavigationBarProvider>().showHome();
                  },
                )
              ],
            ))
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
          // itemExtent: 70,
          itemCount: orders.length,
          itemBuilder: (context, index) => _orderItem(context, orders[index]!),
          separatorBuilder: (context, index) => Divider(
            color: Color.fromARGB(255, 0, 0, 0),
            thickness: 1,
            height: 0,
          ),
        ),
      )
    ]);
  }

  Widget _orderItem(BuildContext context, Order order) {
    final [String date, String time] = formatDateTime(order.timestampChile).split(', ');
    final DeliveryDetailEnum deliveryType = DeliveryDetailEnum.fromName(order.deliveryType);
    final StatusEnum status = StatusEnum.fromName(order.status);

    return TextButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => InvoicePage(order: order)));
      },
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.end,
                    ),
                  ]),
                  TableRow(children: [
                    orderStatusChip(status),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: switch (deliveryType) {
                        DeliveryDetailEnum.pickup => [
                            Icon(Icons.store, size: 16),
                            SizedBox(width: 4),
                            Text("Recoger", style: TextStyle(fontSize: 14, color: Colors.grey[800]))
                          ],
                        DeliveryDetailEnum.dispatch => [
                            Icon(Icons.motorcycle, size: 16),
                            SizedBox(width: 4),
                            Text("Domicilio", style: TextStyle(fontSize: 14, color: Colors.grey[800]))
                          ],
                        _ => [],
                      },
                    )
                  ])
                ],
              ),
            ),
          ),
          // VerticalDivider(color: const Color.fromARGB(255, 0, 0, 0), thickness: 1, ),
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(border: BoxBorder.fromLTRB(left: BorderSide())),
            child: status == StatusEnum.pending ? Icon(Icons.near_me_outlined) : Icon(Icons.receipt_long_outlined),
          ),
        ],
      ),
    );
  }

  Widget orderStatusChip(StatusEnum status) {
    final Color color = switch (status) {
      StatusEnum.pending => Colors.orange,
      StatusEnum.completed => Colors.green,
      StatusEnum.canceled => Colors.red,
      _ => Colors.grey,
    };

    const double alpha = .15;
    final Color backgroundColor = switch (status) {
      StatusEnum.pending => Colors.orange.withValues(alpha: alpha),
      StatusEnum.completed => Colors.green.withValues(alpha: alpha),
      StatusEnum.canceled => Colors.red.withValues(alpha: alpha),
      _ => Colors.grey.withValues(alpha: alpha),
    };

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(15)),
        constraints: BoxConstraints.tightFor(width: 100),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Text(
          status.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
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
