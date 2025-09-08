import 'package:delivera/firebase_options.dart';
import 'package:delivera/pages/home_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/data_provider.dart';
import 'package:delivera/provider/delivery_details_provider.dart';
import 'package:delivera/provider/dish_categories_provider.dart';
import 'package:delivera/provider/dishes_provider.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/provider/payment_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/scroll_controller_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/services/firebase_messaging_service.dart';
import 'package:delivera/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart' show FlutterNativeSplash;
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'dart:io' as io;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);
  
  FlutterNativeSplash.preserve(widgetsBinding: WidgetsFlutterBinding.ensureInitialized());
  if (kDebugMode) {
    io.HttpClient.enableTimelineLogging = true;
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
