import 'package:chifa_el_meson/pages/invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatelessWidget {
  final Uri uri;
  const PaymentPage({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://meson.simsis.cl')) {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const InvoicePage();
                },
              ));
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(uri);

    return Scaffold(
      backgroundColor: Colors.redAccent.shade700,
      body: WebViewWidget(controller: controller),
    );
  }
}
