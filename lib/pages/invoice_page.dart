import 'dart:developer';
import 'dart:io';
import 'package:delivera/enum/order_status_enum.dart' show OrderStatusEnum;
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/pages/home_page.dart';
import 'package:delivera/pages/order_tracking_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/utils/pdf/generate_invoice_pdf.dart';
import 'package:delivera/widget/error_screen_widget.dart' show ErrorScreenWidget;
import 'package:delivera/widget/invoice_card_widget.dart';
import 'package:delivera/widget/loading_screen_widget.dart' show LoadingScreenWidget;
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

  void _setReloading(bool isReloading) {
    setState(() {
      _reloading = isReloading;
    });
  }

  Future<bool> _getOrder() async {
    try {
      final invoiceProvider = context.read<InvoiceProvider>();
      if (widget._order == null) {
        await invoiceProvider.getOrder();
        invoiceProvider.order.storeOrder();
      } else {
        invoiceProvider.setOrder(widget._order!);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isOrderFetched = _getOrder();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOrderFetched,
      builder: (context, snapshot) {
        _invoiceProvider = context.watch<InvoiceProvider>();

        if (snapshot.connectionState == ConnectionState.waiting) {
          log('ConnectionState: waiting');
          return LoadingScreenWidget();
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          log('ConnectionState: done');
          return _reloading
              ? LoadingScreenWidget()
              : PopScope(
                  canPop: widget._order == null ? false : true,
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
                          widget._order == null ? _navigateHome(context) : Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      title: const Text("BOLETA", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      actions: [
                        IconButton(
                          onPressed: () async {
                            _setReloading(true);
                            await _getOrder();
                            _setReloading(false);
                          },
                          icon: const Icon(FontAwesomeIcons.arrowRotateRight),
                        )
                      ],
                    ),
                    body: const InvoiceCardWidget(),
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
                          ElevatedButton.icon(
                            onPressed: () => _downloadInvoice(),
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue.shade800),
                            ),
                            label: const Text(
                              "Descargar boleta",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            icon: _invoiceProvider.isDownloadingInvoice
                                ? const CircularProgressIndicator(color: Colors.white, constraints: BoxConstraints.tightFor(width: 16, height: 16))
                                : const Icon(FontAwesomeIcons.download, size: 16),
                            iconAlignment: IconAlignment.end,
                          ),
                          if (OrderStatusEnum.fromName(_invoiceProvider.order.status).isActive())
                            ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => OrderTrackingPage()),
                              ),
                              child: const Text(
                                'Ver seguimiento',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              context.read<InvoiceProvider>().clearOrder();
                              if (widget._order != null) {
                                Navigator.pop(context);
                                return;
                              }
                              context.read<BottomNavigationBarProvider>().showHome();
                              _navigateHome(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
                              foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
                            ),
                            child: Text(
                              widget._order == null ? "Volver a la tienda" : "Volver al historial",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        } else {
          return ErrorScreenWidget(errorMessage: _errorMessage);
        }
      },
    );
  }

  void _navigateHome(BuildContext context) {
    context.read<BottomNavigationBarProvider>().showHome();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  void _downloadInvoice() async {
    _invoiceProvider.setIsDownloadingInvoice(true);
    try {
      final order = _invoiceProvider.order;
      final pdfDocument = await generateInvoicePdf(
        order,
        context.read<RestaurantInfoProvider>().restaurantInfo,
      );
      if (!context.mounted) return;
      final pdfBytes = await pdfDocument.save();
      final directory = await getTemporaryDirectory();
      final tempFile = File('${directory.path}/orden-${order.publicId}-${order.timestampChile.toIso8601String()}.pdf');
      await tempFile.writeAsBytes(pdfBytes);
      OpenFilex.open(tempFile.path);
      if (!context.mounted) {
        return;
      }
    } catch (e, stackTrace) {
      log("Error in invoice_page, downloadInvoice: ${e.toString()}");
      log("Stack trace: $stackTrace");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al descargar la boleta: ${e.toString()}'),
        ),
      );
    } finally {
      _invoiceProvider.setIsDownloadingInvoice(false);
    }
  }
}
