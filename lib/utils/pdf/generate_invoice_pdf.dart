import 'package:delivera/model/order_result_full_model.dart';
import 'package:delivera/model/restaurant_info_model.dart';
import 'package:delivera/utils/format_date_time.dart';
import 'package:delivera/utils/pdf/price_pw_widget.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<pw.Document> generateInvoicePdf(
    OrderResultFull orderResultFull, RestaurantInfo restaurantInfo) async {
  final pw.Document pdf = pw.Document();

  final moneyBillWavePngBytes =
      await rootBundle.load('assets/icons/money-bill-wave.png');
  final locationDotPngBytes =
      await rootBundle.load('assets/icons/location-dot.png');
  final clockPngBytes = await rootBundle.load('assets/icons/clock.png');
  final moneyCheckDollarPngBytes =
      await rootBundle.load('assets/icons/money-check-dollar.png');
  final userPngBytes = await rootBundle.load('assets/icons/user.png');
  final phoneFlipPngBytes =
      await rootBundle.load('assets/icons/phone-flip.png');
  final boxesStackedPngBytes =
      await rootBundle.load('assets/icons/boxes-stacked.png');
  final faceSmilePngBytes =
      await rootBundle.load('assets/icons/face-smile.png');

  final moneyBillWave =
      pw.MemoryImage(moneyBillWavePngBytes.buffer.asUint8List());
  final locationDot = pw.MemoryImage(locationDotPngBytes.buffer.asUint8List());
  final clock = pw.MemoryImage(clockPngBytes.buffer.asUint8List());
  final moneyCheckDollar =
      pw.MemoryImage(moneyCheckDollarPngBytes.buffer.asUint8List());
  final user = pw.MemoryImage(userPngBytes.buffer.asUint8List());
  final phoneFlip = pw.MemoryImage(phoneFlipPngBytes.buffer.asUint8List());
  final boxesStacked =
      pw.MemoryImage(boxesStackedPngBytes.buffer.asUint8List());
  final faceSmile = pw.MemoryImage(faceSmilePngBytes.buffer.asUint8List());

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat(
        100 * PdfPageFormat.mm,
        PdfPageFormat.a4.height,
      ),
      build: (context) {
        return [
          pw.Center(
              child: pw.SizedBox(
                  width: 300,
                  child: pw.Column(children: [
                    pw.Text("CLIENTE",
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, fontSize: 18)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(moneyBillWave, height: 15),
                        pw.SizedBox(width: 10),
                        pw.Text("Nº de orden: ${orderResultFull.publicId}"),
                      ],
                    ),
                    pw.Text(restaurantInfo.name,
                        style: pw.TextStyle(
                            fontSize: 15, fontWeight: pw.FontWeight.bold)),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(locationDot, height: 15),
                        pw.SizedBox(width: 10),
                        pw.Text(restaurantInfo.address),
                      ],
                    ),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Image(clock, height: 15),
                        pw.SizedBox(width: 10),
                        pw.Text(formatDateTime(orderResultFull.timestamp))
                      ],
                    ),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                        child: pw.Container(
                            color: orderResultFull
                                .paymentStatusFull.backgroundColorPdf,
                            child: pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(
                                    vertical: 4.0),
                                child: pw.Row(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      pw.Image(moneyCheckDollar, height: 15),
                                      pw.SizedBox(width: 10),
                                      pw.Text(
                                          "Pago: ${orderResultFull.paymentStatusFull.name}",
                                          style: pw.TextStyle(
                                              color: orderResultFull
                                                  .paymentStatusFull.colorPdf,
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 15))
                                    ])))),
                    pw.Divider(
                        color: PdfColors.grey,
                        borderStyle: const pw.BorderStyle(pattern: [3, 2])),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                        child: pw.Column(children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(user, height: 15),
                                pw.SizedBox(width: 10),
                                pw.Text(
                                    "Cliente: ${orderResultFull.clientName}")
                              ]),
                          pw.SizedBox(height: 5),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(locationDot, height: 15),
                                pw.SizedBox(width: 10),
                                pw.Text(
                                    "Dirección: ${orderResultFull.clientAddress}")
                              ]),
                          pw.SizedBox(height: 5),
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(phoneFlip, height: 15),
                                pw.SizedBox(width: 10),
                                pw.Text(
                                    "Teléfono: ${orderResultFull.clientPhone}")
                              ])
                        ])),
                    pw.Divider(
                        color: PdfColors.grey,
                        borderStyle: const pw.BorderStyle(pattern: [3, 2])),
                    pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 8.0),
                        child: pw.Column(children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Image(boxesStacked, height: 15),
                                pw.SizedBox(width: 10),
                                pw.Text("Detalles del pedido",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Padding(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Table(columnWidths: const {
                                0: pw.FlexColumnWidth(2),
                                1: pw.FlexColumnWidth(1),
                                2: pw.FlexColumnWidth(1),
                              }, children: [
                                pw.TableRow(
                                    decoration: const pw.BoxDecoration(
                                        border: pw.Border(
                                            bottom: pw.BorderSide(
                                                width: 1,
                                                color: PdfColors.black))),
                                    children: [
                                      pw.Text('Producto',
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold)),
                                      pw.Center(
                                          child: pw.Text('Cant',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold))),
                                      pw.Center(
                                          child: pw.Text('Importe',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold)))
                                    ]),
                                ...orderResultFull.orderProducts
                                    .map((orderProduct) {
                                  return pw.TableRow(
                                      decoration: (orderResultFull
                                                  .orderProducts.lastOrNull ==
                                              orderProduct)
                                          ? null
                                          : const pw.BoxDecoration(
                                              border: pw.Border(
                                                bottom: pw.BorderSide(
                                                    width: 1,
                                                    color: PdfColors.grey),
                                              ),
                                            ),
                                      children: [
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                            child: pw.Text(
                                                orderProduct.product.name)),
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.all(8.0),
                                            child: pw.Center(
                                                child: pw.Text(orderProduct
                                                    .quantity
                                                    .toString()))),
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.all(8.0),
                                            child: pw.Center(
                                                child: PricePWWidget(
                                                    price: orderProduct.product
                                                            .regularPrice *
                                                        orderProduct.quantity)))
                                      ]);
                                })
                              ]))
                        ])),
                    pw.Divider(
                        color: PdfColors.grey,
                        borderStyle: const pw.BorderStyle(pattern: [3, 2])),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Column(children: [
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Subtotal"),
                                PricePWWidget(
                                  price: orderResultFull.subtotal,
                                ),
                              ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("Costo de envío"),
                                PricePWWidget(
                                  price: orderResultFull.deliveryCost,
                                ),
                              ]),
                          pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("TOTAL",
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                                PricePWWidget(
                                    price: orderResultFull.total,
                                    fontWeight: pw.FontWeight.bold),
                              ]),
                          pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 8.0),
                              child: pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text("¡Muchas gracias por tu compra!",
                                        style:
                                            const pw.TextStyle(fontSize: 10)),
                                    pw.SizedBox(width: 10),
                                    pw.Image(faceSmile, height: 12),
                                  ]))
                        ]))
                  ])))
        ];
      },
    ),
  );
  return pdf;
}
