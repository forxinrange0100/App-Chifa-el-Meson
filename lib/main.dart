import 'dart:io' show HttpClient;
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/pages/home_page.dart' show HomePage;
import 'package:delivera/provider/bottom_navigation_bar_provider.dart' show BottomNavigationBarProvider;
import 'package:delivera/provider/data_provider.dart' show DataProvider;
import 'package:delivera/provider/delivery_details_provider.dart' show DeliveryDetailsProvider;
import 'package:delivera/provider/dish_categories_provider.dart' show DishCategoriesProvider;
import 'package:delivera/provider/dishes_provider.dart' show DishesProvider;
import 'package:delivera/provider/invoice_provider.dart' show InvoiceProvider;
import 'package:delivera/provider/order_summary_provider.dart' show OrderSummaryProvider;
import 'package:delivera/provider/payment_provider.dart' show PaymentProvider;
import 'package:delivera/provider/restaurant_info_provider.dart' show RestaurantInfoProvider;
import 'package:delivera/provider/scroll_controller_provider.dart' show ScrollControllerProvider;
import 'package:delivera/provider/shift_provider.dart' show ShiftProvider;
import 'package:delivera/provider/shopping_cart_provider.dart' show ShoppingCartProvider;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart' show FlutterNativeSplash;
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  Hive.registerAdapter('Order', Order.fromJson);
  if (kDebugMode) {
    HttpClient.enableTimelineLogging = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BottomNavigationBarProvider()),
          ChangeNotifierProvider(create: (_) => RestaurantInfoProvider()),
          ChangeNotifierProvider(create: (_) => DishesProvider()),
          ChangeNotifierProvider(create: (_) => DishCategoriesProvider()),
          ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
          ChangeNotifierProvider(create: (_) => ShoppingCartProvider()),
          ChangeNotifierProvider(create: (_) => DeliveryDetailsProvider()),
          ChangeNotifierProvider(create: (_) => ShiftProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(
              create: (context) => OrderSummaryProvider(
                    context.read<RestaurantInfoProvider>(),
                    context.read<ShoppingCartProvider>(),
                  )),
          ChangeNotifierProvider(
              create: (context) =>
                  InvoiceProvider(context.read<OrderSummaryProvider>())),
          ChangeNotifierProvider(
              create: (context) => DataProvider(
                    context.read<RestaurantInfoProvider>(),
                    context.read<DishesProvider>(),
                    context.read<DishCategoriesProvider>(),
                    context.read<DeliveryDetailsProvider>(),
                  ))
        ],
        child: ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              textButtonTheme: const TextButtonThemeData(
                  style: ButtonStyle(
                      foregroundColor:
                          WidgetStatePropertyAll<Color>(Colors.black))),
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  selectedItemColor: Colors.black),
              elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              )),
              useMaterial3: false,
            ),
            home: const HomePage(),
          ),
        ));
  }
}
