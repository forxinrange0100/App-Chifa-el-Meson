import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart' show OpenFilex;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import 'package:provider/provider.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/pages/invoice_page.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'dart:async';

class PaymentPage extends StatefulWidget {
  final PaymentData? paymentData;

  const PaymentPage({
    super.key,
    this.paymentData,
  });

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  bool _isLoading = true;
  bool _hasError = false;
  bool _paymentOpened = false;

  late final AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    initializePayment();
    listenForAppLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initializePayment() async {
    final paymentData = widget.paymentData;
    if (paymentData == null) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }

    try {
      final uri = paymentData.paymentUrl;
      final paymentType = paymentData.paymentType;
      final token = paymentData.token;

      await _openPaymentInBrowser(
        paymentUrl: uri,
        paymentType: paymentType,
        token: token,
      );

      setState(() {
        _paymentOpened = true;
        _isLoading = false;
      });
    } catch (e, s) {
      log("Error al abrir el navegador: $e");
      log(s.toString());
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> listenForAppLinks() async {
    // Caso cuando la app se abre desde un link estando cerrada
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        log('el cuidao');
        _handleAppLink(initialLink);
      }
    } catch (e) {
      log("Error leyendo initial app link: $e");
    }

    // Caso cuando la app ya está abierta
    _sub = _appLinks.uriLinkStream.listen((uri) {
      log('cambios');
      _handleAppLink(uri);
    }, onError: (err) {
      log("Error en app link stream: $err");
    });
  }

  void _handleAppLink(Uri uri) {
    if (uri.scheme != 'delivera') return;

    final host = uri.host;
    final pathSegments = uri.pathSegments;
    log('path segments: $pathSegments');
    switch (host) {
      case 'invoice':
        final publicId = int.parse(pathSegments.first);
        log('public id: $publicId');
        _navigateInvoice(publicId);
        break;
      default:
        log("DeepLin host desconocido: $host");
    }
  }

  Future<void> _openPaymentInBrowser({
    required String paymentUrl,
    required String paymentType,
    String? token,
  }) async {
    if (paymentType == 'getnet') {
      final uri = Uri.parse(paymentUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }

    // Transbank POST con formulario HTML temporal
    final htmlContent = '''
        <html>
          <body onload="document.forms[0].submit()">
            <form action="$paymentUrl" method="POST">
              <input type="hidden" name="token_ws" value="$token" />
              <input type="submit" value="Pagar" />
            </form>
          </body>
        </html>
      ''';

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/payment_form.html');
    await file.writeAsString(htmlContent);

    if (Platform.isAndroid) {
      await OpenFilex.open(file.path, type: "text/html");
    } else if (Platform.isIOS) {
      final uri = Uri.parse(paymentUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _navigateInvoice(int publicId) {
    context.read<ShoppingCartProvider>().cleanShoppingCart();
    final orderSummaryProvider = context.read<OrderSummaryProvider>();
    orderSummaryProvider.clearOrderSummary();
    orderSummaryProvider.clearPaymentData();
    context.read<InvoiceProvider>().publicId = publicId;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const InvoicePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (_isLoading)
            const RedirectingWidget()
          else if (_hasError)
            const _ErrorWidget()
          else if (_paymentOpened)
            Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 20,
                  children: [
                    Text(
                      "Se ha abierto un navegador para completar el pago.\n",
                      textAlign: TextAlign.center,
                    ),
                    ElevatedButton(
                      onPressed: () => _openPaymentInBrowser(
                        paymentUrl: widget.paymentData!.paymentUrl,
                        paymentType: widget.paymentData!.paymentType,
                        token: widget.paymentData!.token,
                      ),
                      child: Text('Reintentar pago'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _isLoading
          ? null
          : ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Volver atrás'),
            ),
    );
  }
}

class RedirectingWidget extends StatelessWidget {
  const RedirectingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          CircularProgressIndicator(color: Colors.blue, backgroundColor: Colors.grey),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Estamos redirigiéndote al portal de pago...", textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Text(
          "Ocurrió un error al iniciar el proceso de pago.\n"
          "Por favor, inténtalo nuevamente.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
