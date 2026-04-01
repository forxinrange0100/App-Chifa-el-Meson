import 'dart:developer';
import 'package:delivera/environment.dart' show Urls;
import 'package:delivera/provider/payment_provider.dart' show PaymentProvider;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:app_links/app_links.dart';
import 'package:provider/provider.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/pages/invoice_page.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'dart:async';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends State<PaymentPage> {
  late final AppLinks _appLinks;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializePayment();
      listenForAppLinks();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initializePayment() async {
    final paymentData = context.read<OrderSummaryProvider>().orderResult?.paymentData;
    final paymentProvider = context.read<PaymentProvider>();

    if (paymentData == null) {
      paymentProvider.onError();
      return;
    }

    await openBrowser(paymentProvider, paymentData);
  }

  Future<void> listenForAppLinks() async {
    // Caso cuando la app ya está abierta
    _sub = _appLinks.uriLinkStream.listen((uri) {
      log('cambios');
      _handleAppLink(uri);
    }, onError: (err) {
      log("Error en app link stream: $err");
    });
  }

  void _handleAppLink(Uri uri) {
    if (uri.scheme != 'chifaelmeson') return;

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
    return Consumer<PaymentProvider>(
      builder: (context, paymentProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              if (paymentProvider.isLoading)
                const RedirectingWidget()
              else if (paymentProvider.hasError)
                const _ErrorWidget()
              else if (paymentProvider.paymentOpened)
                const _BrowserOpenedWidget(),
            ],
          ),
          bottomNavigationBar: paymentProvider.isLoading
              ? null
              : ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Volver atrás'),
                ),
        );
      },
    );
  }
}

class _BrowserOpenedWidget extends StatelessWidget {
  const _BrowserOpenedWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Text(
              "Se ha abierto un navegador para completar el pago.",
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () => _retryPayment(context),
              child: Text('Reintentar pago'),
            ),
          ],
        ),
      ),
    );
  }

  void _retryPayment(BuildContext context) async {
    final orderSummaryProvider = context.read<OrderSummaryProvider>();
    final paymentProvider = context.read<PaymentProvider>();

    if (orderSummaryProvider.orderResult == null) return;

    paymentProvider.onLoading();

    final paymentData = orderSummaryProvider.orderResult!.paymentData;

    Future<void> caseTransbank() async {
      bool success = await orderSummaryProvider.postOrder();
      if (!success) {
        paymentProvider.setHasError(true);
        paymentProvider.setIsLoading(false);
        return;
      }
    }

    await openBrowser(paymentProvider, paymentData, caseTransbank: caseTransbank);
  }
}

/// Abre una URL en una custom tab con tema consistente
/// Configurado para Getnet y Transbank
Future<void> _launchPaymentCustomTab(Uri uri) async {
  try {
    await launchUrl(
      uri,
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: const Color(0xFF557819),
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
      safariVCOptions: const SafariViewControllerOptions(
        preferredBarTintColor: Color(0xFF557819),
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    log('Error opening payment URL: $e');
    rethrow;
  }
}

Future<void> openBrowserGetnet(String paymentUrl) async {
  final uri = Uri.parse(paymentUrl);
  await _launchPaymentCustomTab(uri);
}

Future<void> openBrowserTransbank(
  String paymentUrl,
  String token,
) async {
  final uri = Uri.parse(
    '${Urls.apiUrl}/api/transbank/form?payment_url=$paymentUrl&token_ws=$token',
  );
  await _launchPaymentCustomTab(uri);
}

/// Abre el navegador para completar el pago, dependiendo del tipo de pago.
/// Los callback [caseGetnet] y [caseTransbank] son llamados antes de sus respectivos casos.
Future<void> openBrowser(
  PaymentProvider paymentProvider,
  PaymentData paymentData, {
  Future<void> Function()? caseGetnet,
  Future<void> Function()? caseTransbank,
}) async {
  try {
    switch (paymentData.paymentType) {
      case 'getnet':
        await caseGetnet?.call();
        await openBrowserGetnet(paymentData.paymentUrl);
        break;
      case 'transbank':
        await caseTransbank?.call();
        await openBrowserTransbank(paymentData.paymentUrl, paymentData.token!);
        break;
    }
    paymentProvider.onOpened();
  } catch (e, s) {
    log("Error al abrir el navegador: $e", stackTrace: s);
    paymentProvider.onError();
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
