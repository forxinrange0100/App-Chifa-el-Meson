import 'package:chifa_el_meson/pages/invoice_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final Uri uri;
  const PaymentPage({super.key, required this.uri});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://meson.simsis.cl')) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvoicePage(),
                ),
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(widget.uri);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const InvoicePage(),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
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
                    Text("Estamos redirigíendote al portal de pago...")
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
