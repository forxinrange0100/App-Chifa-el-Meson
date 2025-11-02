import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/utils/date_time_chile.dart';
import 'package:delivera/utils/format_date_time.dart';
import 'package:delivera/widget/expandable_text_widget.dart' show ExpandableText;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines_plus/timelines_plus.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

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
        child: LayoutBuilder(
          builder: (context, constraints) => Consumer<InvoiceProvider>(
            builder: (context, orderProvider, child) {
              final order = orderProvider.order;
              final status = OrderStatusEnum.fromName(order.status);
              final statusProcess = OrderStatusEnum.getStatusProcess(DeliveryTypeEnum.fromName(order.deliveryType));
              final itemCounter = statusProcess.length;
              final double iconSize = 32;

              final orderTracking = OrderTracking.fromStorage(order.publicId) ?? OrderTracking.fromOrder(order);
              log('orderTracking: ${orderTracking.toJson()}');
              final OrderStatusEnum lastActiveStatus = orderTracking.lastActiveStatus();
              final currentIndex = statusProcess.indexOf(lastActiveStatus);
              log('lastActiveStatus: $lastActiveStatus, currentIndex: $currentIndex');

              // Indice del nodo que debería mostrarse como cancelado
              int canceledIndex = statusProcess.indexOf(lastActiveStatus) + 1;
              log('canceledIndex: $canceledIndex');

              return Column(
                children: [
                  SizedBox(
                    height: iconSize * 2,
                    child: FixedTimeline.tileBuilder(
                      mainAxisSize: MainAxisSize.min,
                      direction: Axis.horizontal,
                      builder: TimelineTileBuilder.connected(
                        itemCount: itemCounter,
                        indicatorBuilder: (_, index) {
                          final double size = iconSize * 1.5;
                          final Color color;
                          // Indicador de cancelado, por delante del último estado activo
                          if (status == OrderStatusEnum.canceled && index == canceledIndex) {
                            color = status.getColor();
                            return OutlinedDotIndicator(
                              size: size,
                              color: color,
                              backgroundColor: color.withValues(alpha: .15),
                              child: Icon(status.getIcon(), size: iconSize, color: color),
                            );
                          }
                          // Indicador por defecto
                          if (index > currentIndex) {
                            return OutlinedDotIndicator(
                              size: size,
                              color: Colors.grey.shade400,
                              backgroundColor: Colors.grey.shade400,
                              child: Icon(statusProcess[index].getIcon(), size: iconSize, color: Colors.white),
                            );
                          }
                          // Indicador del estado activo
                          color = statusProcess[index].getColor();
                          return OutlinedDotIndicator(
                            size: size,
                            color: color,
                            backgroundColor: color.withValues(alpha: .15),
                            child: Icon(
                              statusProcess[index].getIcon(),
                              size: iconSize,
                              color: color,
                            ),
                          );
                        },
                        connectorBuilder: (_, index, type) {
                          List<Color> gradient;
                          late Color color;
                          late Color other;
                          if (status == OrderStatusEnum.canceled && index == canceledIndex - 1) {
                            // Connector de cancelado
                            color = lastActiveStatus.getColor();
                            other = status.getColor();
                          } else if (index < currentIndex) {
                            // Connector del estado activo
                            color = statusProcess[index].getColor();
                            other = statusProcess[index + 1].getColor();
                          } else {
                            // Connector por defecto
                            color = Colors.grey.shade400;
                            other = Colors.grey.shade400;
                          }

                          if (type == ConnectorType.start) {
                            gradient = [Color.lerp(color, other, .5)!, other];
                          } else {
                            gradient = [color, Color.lerp(color, other, .5)!];
                          }

                          return DecoratedLineConnector(
                            thickness: 2.5,
                            decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)),
                          );
                        },
                        // oppositeContentsBuilder: (context, index) => Icon(Icons.access_alarms_outlined, size: iconSize),
                        contentsBuilder: (_, index) {
                          DateTime? timestamp = orderTracking.timestamps[statusProcess[index]];
                          if (status == OrderStatusEnum.canceled && index == canceledIndex) {
                            timestamp = orderTracking.timestamps[status];
                          } else {
                            timestamp = orderTracking.timestamps[statusProcess[index]];
                          }
                          if (timestamp == null) return null;
                          final formattedTimestamp = formatHourMinute(dateTimeChile(timestamp));

                          return SizedBox(
                            height: iconSize / 2,
                            child: Text(
                              formattedTimestamp,
                              style: TextStyle(color: Colors.black87),
                            ),
                          );
                        },
                        contentsAlign: ContentsAlign.basic,
                        connectionDirection: ConnectionDirection.after,
                        nodePositionBuilder: (context, index) => 0,
                        itemExtent: (constraints.maxWidth / itemCounter),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.only(top: 12),
                    child: Text(
                      'N° de orden: ${order.publicId}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                        color: status.getColor().withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: status.getColor(), width: 1.5)),
                    constraints: BoxConstraints.tightFor(width: 100),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      status.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: status.getColor()),
                    ),
                  ),
                  // if (status != OrderStatusEnum.canceled && status != OrderStatusEnum.completed)
                  //   SizedBox(
                  //     height: 20,
                  //     child: Center(
                  //       child: Text(
                  //         'La hora de entrega es de 1 hora aproximadamente.',
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  Divider(height: 0, color: Colors.grey.shade300, thickness: 1),
                  SizedBox(
                    height: 32,
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text('Productos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: order.orderProducts.length,
                      separatorBuilder: (_, __) => Divider(height: 5),
                      itemBuilder: (context, index) {
                        final orderProduct = order.orderProducts[index];
                        return Row(
                          spacing: 8,
                          children: [
                            CachedNetworkImage(
                              imageUrl: orderProduct.product.imageUrl,
                              width: 75,
                              height: 75,
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
                  ),
                ],
              );
            },
          ),
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
                MaterialPageRoute(
                  builder: (context) => InvoicePage(order: context.read<InvoiceProvider>().order),
                ),
              ),
              child: const Text(
                'Ver boleta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<InvoiceProvider>().clearOrder();
                Navigator.pop(context);
              },
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
