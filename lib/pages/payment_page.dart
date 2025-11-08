import 'dart:developer';

import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/provider/bottom_navigation_bar_provider.dart' show BottomNavigationBarProvider;
import 'package:delivera/provider/order_summary_provider.dart' show OrderSummaryProvider;
import 'package:delivera/provider/shopping_cart_provider.dart' show ShoppingCartProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A page that handles payment processing using the provided [uri].
///
/// This widget displays the payment UI and manages payment-related logic.
/// Pass a [Uri] to specify the payment endpoint or resource.
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
  late WebViewController _controller;
  bool _isLoading = true;
  late final Uri uri;
  late final String paymentType;
  late final String? token;

  @override
  void initState() {
    super.initState();
    // TODO: Mostrar error e implementar pantalla de error cuando ocurra un error en el webview
    if (widget.paymentData == null) return;
    uri = Uri.parse(widget.paymentData!.paymentUrl);
    paymentType = widget.paymentData!.paymentType;
    token = widget.paymentData!.token;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            context.read<ShoppingCartProvider>().cleanShoppingCart();
            context.read<OrderSummaryProvider>().clearOrderSummary();
            context.read<BottomNavigationBarProvider>().showHome();
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onUrlChange: (UrlChange change) => log('URL changed to: ${change.url}'),
          onWebResourceError: (WebResourceError error) {
            log('Web resource error: ${error.errorCode}');
            log('Web resource error description: ${error.description}');
            log('Web resource error failingUrl: ${error.errorType}');
          },
          onHttpError: (HttpResponseError error) {
            log('HTTP error: ${error.request}');
            log('HTTP error status code: ${error.response}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/order/')) {
              log('Navigating to invoice page: ${request.url}');
              _navigateInvoice(context);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    // Aquí la lógica para transbank
    if (paymentType == 'transbank' && token != null) {
      final html = '''
        <html>
          <body onload="document.forms[0].submit()">
            <form action="${uri.toString()}" method="POST">
              <input type="hidden" name="token_ws" value="$token"/>
            </form>
          </body>
        </html>
      ''';

      _controller.loadHtmlString(html);
    } else {
      _controller.loadRequest(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.grey,
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Estamos redirigíendote al portal de pago...", textAlign: TextAlign.center),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateInvoice(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        // Navigate to InvoicePage when payment is done or canceled
        builder: (context) => const InvoicePage(),
      ),
      ModalRoute.withName('HomePage'),
    );
  }
}
