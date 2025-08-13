import 'dart:developer';
import 'dart:io';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/pages/home_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/utils/pdf/generate_invoice_pdf.dart';
import 'package:delivera/widget/invoice_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  final Order? order;

  const InvoicePage({super.key, this.order});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool _reloading = false;
  String? _errorMessage;

  Future<bool> getOrder() async {
    try {
      if (widget.order == null) {
        await context.read<InvoiceProvider>().getOrder();
        // ignore: use_build_context_synchronously
        context.read<InvoiceProvider>().storeOrder();
      } else {
        context.read<InvoiceProvider>().setOrder(widget.order!);
      }

      return true;
    } catch (e, stackTrace) {
      log("Error in invoice_page, getOrder: ${e.toString()}");
      log("Stack trace: $stackTrace");
      setState(() {
        _errorMessage = e.toString();
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = context.watch<InvoiceProvider>();

    return FutureBuilder<bool>(
      future: getOrder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.blue,
                    backgroundColor: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("Estamos cargando la boleta para ti, espera un momento...", textAlign: TextAlign.center),
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          return _reloading
              ? const Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Estamos cargando la boleta para ti, espera un momento...", textAlign: TextAlign.center),
                      )
                    ],
                  ),
                )
              : PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, _) {
                    if (!didPop) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const HomePage();
                          },
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      surfaceTintColor: const Color.fromARGB(255, 89, 81, 81),
                      backgroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 2,
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            context.read<BottomNavigationBarProvider>().showHome();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const HomePage();
                                },
                              ),
                              (route) {
                                return false;
                              },
                            );
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.black)),
                      title: const Text("BOLETA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                _reloading = true;
                              });
                              await getOrder();
                              setState(() {
                                _reloading = false;
                              });
                            },
                            icon: const Icon(FontAwesomeIcons.arrowRotateRight))
                      ],
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const InvoiceCardWidget(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  onPressed: () async {
                                    invoiceProvider.setIsGettingInvoice(true);

                                    final order = invoiceProvider.order;
                                    final pdfDocument = await generateInvoicePdf(
                                      order,
                                      context.read<RestaurantInfoProvider>().restaurantInfo,
                                    );
                                    if (!context.mounted) return;
                                    final pdfBytes = await pdfDocument.save();
                                    final directory = await getTemporaryDirectory();
                                    final tempFile = File('${directory.path}/orden-${order.publicId}-${order.timestamp.toIso8601String()}.pdf');
                                    await tempFile.writeAsBytes(pdfBytes);
                                    OpenFilex.open(tempFile.path);
                                    if (!context.mounted) {
                                      return;
                                    }
                                    invoiceProvider.setIsGettingInvoice(false);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Descargar boleta"),
                                      invoiceProvider.isGettingInvoice
                                          ? const Padding(
                                              padding: EdgeInsets.only(left: 8.0),
                                              child: SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                    color: Colors.blue,
                                                    backgroundColor: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : const SizedBox()
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
                                      foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black)),
                                  onPressed: () {
                                    context.read<BottomNavigationBarProvider>().showHome();
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const HomePage();
                                        },
                                      ),
                                      (route) => false,
                                    );
                                  },
                                  child: const Text("Volver a la tienda")),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text("Error: $_errorMessage"),
            ),
          );
        }
      },
    );
  }
}
