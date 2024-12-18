import 'package:chifa_el_meson/model/order_result_full_model.dart';
import 'package:chifa_el_meson/model/restaurant_info_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Document generateInvoicePdf(
    OrderResultFull orderResultFull, RestaurantInfo restaurantInfo) {
  final pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Center(
            child: pw.SizedBox(
                height: 580,
                width: 300,
                child: pw.ListView(children: [
                  pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 24.0),
                      child: pw.Column(children: [
                        pw.Text("CLIENTE",
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 18)),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text("Nº de orden: ${orderResultFull.publicId}"),
                          ],
                        ),
                        pw.Text(restaurantInfo.name,
                            style: pw.TextStyle(
                                fontSize: 15, fontWeight: pw.FontWeight.bold)),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(restaurantInfo.address),
                          ],
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(orderResultFull.timestamp.toString()),
                          ],
                        ),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 8.0),
                            child: pw.Container(
                                color: PdfColors.greenAccent100,
                                child: pw.Padding(
                                    padding: const pw.EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: pw.Row(children: [
                                      pw.Text(orderResultFull.paymentStatus,
                                          style: pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,
                                              fontSize: 15))
                                    ])))),
                        pw.Divider(),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 8.0),
                            child: pw.Column(children: [
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                        "Cliente ${orderResultFull.clientName}")
                                  ]),
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                        "Dirección: ${orderResultFull.clientAddress}")
                                  ]),
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                        "Teléfono: ${orderResultFull.clientPhone}")
                                  ])
                            ])),
                        pw.Divider(),
                        pw.Padding(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 8.0),
                            child: pw.Column(children: [
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
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
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text('Cant',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold)),
                                          pw.Text('Importe',
                                              style: pw.TextStyle(
                                                  fontWeight:
                                                      pw.FontWeight.bold))
                                        ]),
                                    ...orderResultFull.orderProducts
                                        .map((orderProduct) {
                                      return pw.TableRow(children: [
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.all(8.0),
                                            child: pw.Text(
                                                orderProduct.product.name)),
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.all(8.0),
                                            child: pw.Text(orderProduct.quantity
                                                .toString())),
                                        pw.Padding(
                                            padding:
                                                const pw.EdgeInsets.all(8.0),
                                            child: pw.Text((orderProduct
                                                        .product.regularPrice *
                                                    orderProduct.quantity)
                                                .toString()))
                                      ]);
                                    })
                                  ]))
                            ])),
                        pw.Divider(),
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Column(children: [
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text("Subtotal"),
                                    pw.Text(orderResultFull.subtotal.toString())
                                  ]),
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text("Costo de envío"),
                                    pw.Text(
                                        orderResultFull.deliveryCost.toString())
                                  ]),
                              pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text("TOTAL"),
                                    pw.Text(orderResultFull.total.toString())
                                  ]),
                              pw.Padding(
                                  padding: const pw.EdgeInsets.symmetric(
                                      vertical: 8.0),
                                  child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.center,
                                      children: [
                                        pw.Text(
                                            "¡Muchas gracias por tu compra!",
                                            style: const pw.TextStyle(
                                                fontSize: 12))
                                      ]))
                            ]))
                      ]))
                ])));
      },
    ),
  );
  return pdf;
}
