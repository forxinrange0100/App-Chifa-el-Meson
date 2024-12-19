import 'package:chifa_el_meson/provider/invoice_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/utils/format_date_time.dart';
import 'package:chifa_el_meson/widget/price_widget.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class InvoiceCardWidget extends StatelessWidget {
  const InvoiceCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 580,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Card(
            elevation: 10,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                      Text(
                          "Nº de orden: ${context.watch<InvoiceProvider>().orderResultFull.publicId}"),
                    ],
                  ),
                  Text(
                    context.watch<RestaurantInfoProvider>().restaurantInfo.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
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
                      Text(context
                          .watch<RestaurantInfoProvider>()
                          .restaurantInfo
                          .address)
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
                      Text(formatDateTime(context
                          .watch<InvoiceProvider>()
                          .orderResultFull
                          .timestamp))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      color: context
                          .watch<InvoiceProvider>()
                          .orderResultFull
                          .paymentStatusFull
                          .backgroundColor,
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
                              "Pago: ${context.watch<InvoiceProvider>().orderResultFull.paymentStatusFull.name}",
                              style: TextStyle(
                                  color: context
                                      .watch<InvoiceProvider>()
                                      .orderResultFull
                                      .paymentStatusFull
                                      .color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
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
                            Text(
                                "Cliente: ${context.watch<InvoiceProvider>().orderResultFull.clientName}")
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
                            Text(
                                "Dirección: ${context.watch<InvoiceProvider>().orderResultFull.clientAddress}")
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
                            Text(
                                "Teléfono: ${context.watch<InvoiceProvider>().orderResultFull.clientPhone}")
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
                                    bottom: BorderSide(
                                        width: 1, color: Colors.black),
                                  ),
                                ),
                                children: [
                                  Text('Producto',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Cant',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('Importe',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              ...context
                                  .watch<InvoiceProvider>()
                                  .orderResultFull
                                  .orderProducts
                                  .map((orderProduct) {
                                return TableRow(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(orderProduct.product.name),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          orderProduct.quantity.toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: PriceWidget(
                                          price: orderProduct
                                                  .product.regularPrice *
                                              orderProduct.quantity),
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
                          children: [
                            const Text("Subtotal"),
                            PriceWidget(
                                price: context
                                    .watch<InvoiceProvider>()
                                    .orderResultFull
                                    .subtotal)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Costo de envío"),
                            PriceWidget(
                                price: context
                                    .watch<InvoiceProvider>()
                                    .orderResultFull
                                    .deliveryCost)
                          ],
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
                              price: context
                                  .watch<InvoiceProvider>()
                                  .orderResultFull
                                  .total,
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
          ),
        ),
      ]),
    );
  }
}
