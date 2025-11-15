import 'dart:developer';

import 'package:delivera/enum/bottom_navigation_bar_enum.dart';
import 'package:delivera/model/notification_handler_model.dart' show NotificationHandler;
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/pages/home_info_page.dart';
import 'package:delivera/pages/shopping_cart_page.dart';
import 'package:delivera/pages/history_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/data_provider.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart' show OrderSummaryProvider;
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/toast/toast.dart';
import 'package:delivera/utils/navigation.dart';
import 'package:delivera/widget/error_screen_widget.dart';
import 'package:delivera/widget/loading_screen_widget.dart' show LoadingScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool>? _data;
  DateTime? lastPressedAt;

  Future<bool> _getData() async {
    await context.read<DataProvider>().getData();
    if (!mounted) return false;
    FlutterNativeSplash.remove();
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Quitar splash despues de 3 segundos o al cargar los datos
      Future.delayed(const Duration(seconds: 3), () async {
        if (mounted) {
          FlutterNativeSplash.remove();
        }
      });
      NotificationHandler.handleStoredNotification();
      _data = _getData();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingScreenWidget();
        } else if (snapshot.connectionState == ConnectionState.done && snapshot.data == true) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) => handlePop(didPop, context),
            child: Consumer<DataProvider>(builder: (context, dataProvider, child) {
              if (!dataProvider.done) {
                return LoadingScreenWidget();
              } else if (dataProvider.errorMessage.isNotEmpty) {
                return ErrorScreenWidget(errorMessage: dataProvider.errorMessage);
              }
              return _HomeBuilder();
            }),
          );
        } else {
          return ErrorScreenWidget(errorMessage: context.read<DataProvider>().errorMessage);
        }
      },
    );
  }

  void handlePop(bool didPop, BuildContext context) {
    if (didPop) return;

    if (context.read<BottomNavigationBarProvider>().index != BottomNavigationBarEnum.home.index) {
      context.read<BottomNavigationBarProvider>().showHome();
      return;
    }
    final now = DateTime.now();
    final isFirstBackPress = lastPressedAt == null || now.difference(lastPressedAt!) > const Duration(seconds: 5);

    if (isFirstBackPress) {
      lastPressedAt = now;
      closeAppToast();
    } else {
      SystemNavigator.pop();
    }
  }
}

class _HomeBuilder extends StatelessWidget {
  const _HomeBuilder();

  final List<Widget> pages = const [
    HomeInfoPage(),
    ShoppingCartPage(),
    HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingPaymentWidget = pendingPayment(context);
    return Consumer<BottomNavigationBarProvider>(
      builder: (context, bottomNavigationProvider, child) {
        child = pendingPaymentWidget;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: pages[bottomNavigationProvider.index],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
            ),
            child: NavigationBar(
              height: 60,
              backgroundColor: Colors.white,
              selectedIndex: bottomNavigationProvider.index,
              key: bottomNavigationProvider.index != 0 ? null : ValueKey(0),
              onDestinationSelected: (int index) async {
                final BottomNavigationBarEnum bottomNavigationBarEnum = BottomNavigationBarEnum.values[index];
                if (bottomNavigationBarEnum == BottomNavigationBarEnum.shoppingCar && !context.read<ShiftProvider>().isOpen) {
                  shiftClosedToast();
                  return;
                }
                bottomNavigationProvider.setIndex(bottomNavigationBarEnum);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Inicio",
                ),
                NavigationDestination(
                  icon: _CartIconWidget(),
                  label: "Carrito",
                ),
                NavigationDestination(
                  icon: Icon(Icons.history),
                  label: "Historial",
                )
              ],
            ),
          ),
          bottomSheet: child,
        );
      },
    );
  }

  Widget? pendingPayment(BuildContext context) {
    PaymentResult? orderResult = PaymentResult.fromStorage();

    final bool hasOrderResult = orderResult != null;
    log('Has pending payment: $hasOrderResult');
    if (!hasOrderResult) {
      return null;
    }
    log(
      'Url: ${orderResult.paymentData.paymentUrl} '
      'Token: ${orderResult.paymentData.token} '
      'Type: ${orderResult.paymentData.paymentType}',
    );

    context.read<InvoiceProvider>().publicId = orderResult.publicId;
    context.read<OrderSummaryProvider>().setOrderResult(orderResult);

    return ElevatedButton(
      onPressed: () => navigatePayment(Navigator.of(context)),
      child: Text('Continuar pago'),
    );
  }
}

class _CartIconWidget extends StatelessWidget {
  const _CartIconWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.shopping_cart),
        Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            radius: 8,
            backgroundColor: Colors.black,
            child: CircleAvatar(
              radius: 7,
              backgroundColor: Colors.white,
              child: Center(
                child: Text(
                  context.watch<ShoppingCartProvider>().length.toString(),
                  style: const TextStyle(
                    fontSize: 9,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
