import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/utils/format_date_time.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class InvoiceCardWidget extends StatelessWidget {
  const InvoiceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = context.watch<InvoiceProvider>();
    final restaurantInfoProvider = context.watch<RestaurantInfoProvider>();

    return Expanded(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 10,
              color: Colors.white,
              child: Column(
                children: [
                  const Text(
                    "CLIENTE",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.moneyBillWave,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Nº de orden: ${invoiceProvider.order.publicId}"),
                    ],
                  ),
                  Text(
                    restaurantInfoProvider.restaurantInfo.name,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.locationDot,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(restaurantInfoProvider.restaurantInfo.address)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.solidClock,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(formatDateTime(invoiceProvider.order.timestamp))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: invoiceProvider.order.paymentStatusStyle.backgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.moneyCheckDollar,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Pago: ${invoiceProvider.order.paymentStatusStyle.label}",
                              style: TextStyle(
                                  color: invoiceProvider.order.paymentStatusStyle.color, fontWeight: FontWeight.bold, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const DottedLine(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.solidUser,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Cliente: ${invoiceProvider.order.clientName}")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.locationDot,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Dirección: ${invoiceProvider.order.clientAddress}")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.phoneFlip,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text("Teléfono: ${invoiceProvider.order.clientPhone}")
                          ],
                        )
                      ],
                    ),
                  ),
                  const DottedLine(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.boxesStacked,
                              size: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Detalles del pedido",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            columnWidths: const {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              const TableRow(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 1, color: Colors.black),
                                  ),
                                ),
                                children: [
                                  Text('Producto', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Center(
                                    child: Text('Cant', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                  Center(
                                    child: Text('Importe', style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...invoiceProvider.order.orderProducts.map((orderProduct) {
                                return TableRow(
                                  decoration: (invoiceProvider.order.orderProducts.lastOrNull == orderProduct)
                                      ? null
                                      : const BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(width: 1, color: Colors.grey),
                                          ),
                                        ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(orderProduct.product.name),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          orderProduct.quantity.toString(),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: PriceWidget(price: orderProduct.product.regularPrice * orderProduct.quantity),
                                      ),
                                    ),
                                  ],
                                );
                              })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const DottedLine(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text("Subtotal"), PriceWidget(price: invoiceProvider.order.subtotal)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text("Costo de envío"), PriceWidget(price: invoiceProvider.order.deliveryCost)],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "TOTAL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            PriceWidget(
                              price: invoiceProvider.order.total,
                              fontWeight: FontWeight.bold,
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "¡Muchas gracias por tu compra!",
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.faceSmile,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
