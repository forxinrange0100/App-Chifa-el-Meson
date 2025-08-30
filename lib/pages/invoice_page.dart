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
  final Order? _order;

  const InvoicePage({super.key, order}) : _order = order;

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  Future<bool>? _isOrderFetched;
  bool _reloading = false;
  String? _errorMessage;
  late InvoiceProvider _invoiceProvider;

  Future<bool> _getOrder() async {
    try {
      if (widget._order == null) {
        await context.read<InvoiceProvider>().getOrder();
        // ignore: use_build_context_synchronously
        context.read<InvoiceProvider>().storeOrder();
      } else {
        context.read<InvoiceProvider>().setOrder(widget._order!);
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
  void initState() {
    super.initState();
    _isOrderFetched = _getOrder();
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<bool>(
      future: _isOrderFetched,
      builder: (context, snapshot) {
        _invoiceProvider = context.watch<InvoiceProvider>();

        if (snapshot.connectionState == ConnectionState.waiting) {
          log('ConnectionState: waiting');
          return _loadingScreen();
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          log('ConnectionState: done');
          return _reloading
              ? _loadingScreen()
              : PopScope(
                  canPop: false,
                  onPopInvokedWithResult: (didPop, _) {
                    if (!didPop) {
                      _navigateHome(context);
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
                            _navigateHome(context);
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.black)),
                      title: const Text("BOLETA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      actions: [
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                _reloading = true;
                              });
                              await _getOrder();
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
                                onPressed: () => _downloadInvoice(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Descargar boleta"),
                                    _invoiceProvider.isDownloadingInvoice
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
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
                                      foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black)),
                                  onPressed: () {
                                    context.read<BottomNavigationBarProvider>().showHome();
                                    _navigateHome(context);
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

  void _navigateHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  Scaffold _loadingScreen() {
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
  }

  void _downloadInvoice() async {
    _invoiceProvider.setIsDownloadingInvoice(true);

    final order = _invoiceProvider.order;
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
    _invoiceProvider.setIsDownloadingInvoice(false);
  }
}
