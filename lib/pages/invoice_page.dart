import 'dart:io';

import 'package:chifa_el_meson/pages/home_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/invoice_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/utils/generate_invoice_pdf.dart';
import 'package:chifa_el_meson/widget/invoice_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  bool reloading = false;
  Future<bool> getOrderFull() async {
    await context.read<InvoiceProvider>().getOrderResultFull();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: getOrderFull(),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      "Estamos cargando la boleta para ti, espera un momento...")
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          return reloading
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
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                          "Estamos cargando la boleta para ti, espera un momento...")
                    ],
                  ),
                )
              : PopScope(
                  canPop: false,
                  onPopInvoked: (didPop) {
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
                      surfaceTintColor: Colors.white,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 2,
                      centerTitle: true,
                      leading: IconButton(
                          onPressed: () {
                            context
                                .read<BottomNavigationBarProvider>()
                                .showHome();
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
                          icon: const Icon(Icons.arrow_back)),
                      title: const Text("BOLETA",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                reloading = true;
                              });
                              await getOrderFull();
                              setState(() {
                                reloading = false;
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
                                    final pdfDocument =
                                        await generateInvoicePdf(
                                      context
                                          .read<InvoiceProvider>()
                                          .orderResultFull,
                                      context
                                          .read<RestaurantInfoProvider>()
                                          .restaurantInfo,
                                    );
                                    final pdfBytes = await pdfDocument.save();
                                    final directory =
                                        await getTemporaryDirectory();
                                    final tempFile =
                                        File('${directory.path}/boleta.pdf');
                                    await tempFile.writeAsBytes(pdfBytes);
                                    OpenFilex.open(tempFile.path);
                                  },
                                  child: const Text("Descargar boleta")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll<Color>(
                                              Colors.grey.shade400),
                                      foregroundColor:
                                          const WidgetStatePropertyAll<Color>(
                                              Colors.black)),
                                  onPressed: () {
                                    context
                                        .read<BottomNavigationBarProvider>()
                                        .showHome();
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
          return const Scaffold(
            body: Center(
              child: Text("Error"),
            ),
          );
        }
      },
    );
  }
}
