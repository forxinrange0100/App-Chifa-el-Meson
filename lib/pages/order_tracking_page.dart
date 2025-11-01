import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/widget/expandable_text_widget.dart' show ExpandableText;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderTrackingPage extends StatelessWidget {
  final Order _order;

  const OrderTrackingPage({super.key, required Order order}) : _order = order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color.fromARGB(255, 89, 81, 81),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("SEGUIMIENTO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<InvoiceProvider>(
          builder: (context, orderProvider, child) {
            final statusProcess = OrderStatusEnum.getStatusProcess(DeliveryTypeEnum.fromName(orderProvider.order.deliveryType));
            final status = OrderStatusEnum.fromName(_order.status);
            final itemCounter = statusProcess.length;
            final currentIndex = statusProcess.indexOf(status) + 2;
            final double iconSize = 32;
            return LayoutBuilder(
              builder: (context, constraints) => Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: FixedTimeline.tileBuilder(
                      mainAxisSize: MainAxisSize.min,
                      direction: Axis.horizontal,
                      builder: TimelineTileBuilder.connected(
                        itemCount: itemCounter,
                        indicatorBuilder: (_, index) => OutlinedDotIndicator(
                          size: iconSize * 1.5,
                          color: index <= currentIndex ? statusProcess[index].getColor() : Colors.grey.shade400,
                          backgroundColor: index <= currentIndex ? statusProcess[index].getColor().withValues(alpha: .15) : Colors.grey.shade400,
                          child: Icon(
                            statusProcess[index].getIcon(),
                            size: iconSize,
                            color: index <= currentIndex ? statusProcess[index].getColor() : Colors.white,
                          ),
                        ),
                        // contentsBuilder: (context, index) => Icon(OrderStatusEnum.icon(statusProcess[index]), size: iconSize),
                        oppositeContentsBuilder: (context, index) => SizedBox.square(
                          dimension: iconSize,
                          child: Icon(Icons.access_alarms_outlined, size: iconSize),
                        ),
                        connectorBuilder: (_, index, type) {
                          List<Color> gradient = [Colors.grey.shade400, Colors.grey.shade400];
                          if (index < currentIndex) {
                            final color = statusProcess[index].getColor();
                            final other = statusProcess[index + 1].getColor();
                            if (type == ConnectorType.start) {
                              gradient = [Color.lerp(color, other, .5)!, other];
                            } else if (type == ConnectorType.end) {
                              gradient = [color, Color.lerp(color, other, .5)!];
                            }
                          }
                          return DecoratedLineConnector(
                            thickness: 2.5,
                            decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)),
                          );
                        },
                        contentsAlign: ContentsAlign.basic,
                        nodePositionBuilder: (context, index) => 0.0,
                        connectionDirection: ConnectionDirection.after,
                        itemExtent: (constraints.maxWidth / itemCounter),
                      ),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Icon(Icons.circle, size: 16, color: Colors.blue),
                  //     Container(width: 2, height: 50, color: Colors.blue),
                  //   ],
                  // ),
                  Text(
                    OrderStatusEnum.fromName(orderProvider.order.status).label,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(height: 0, color: Colors.grey.shade300, thickness: 1),
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Productos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: orderProvider.order.orderProducts.length,
                    separatorBuilder: (_, __) => Divider(height: 5),
                    itemBuilder: (context, index) {
                      final orderProduct = _order.enabledProducts[index];
                      return Row(
                        spacing: 8,
                        children: [
                          CachedNetworkImage(
                            imageUrl: orderProduct.product.imageUrl,
                            width: 50,
                            height: 50,
                            placeholder: (_, __) => CircularProgressIndicator(),
                            errorWidget: (_, __, ___) => Icon(Icons.error),
                          ),
                          Expanded(
                            child: ExpandableText(
                              orderProduct.product.name,
                              enabled: false,
                              maxLines: 3,
                            ),
                          ),
                          Text('x${orderProduct.quantity}'),
                          Text(orderProduct.formattedTotalPrice),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InvoicePage(order: _order)),
              ),
              child: const Text(
                'Ver boleta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
                foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
              ),
              child: const Text(
                'Volver atrás',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
