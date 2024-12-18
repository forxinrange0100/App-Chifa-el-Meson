import 'package:chifa_el_meson/pages/home_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/data_provider.dart';
import 'package:chifa_el_meson/provider/delivery_details_provider.dart';
import 'package:chifa_el_meson/provider/dish_categories_provider.dart';
import 'package:chifa_el_meson/provider/dishes_provider.dart';
import 'package:chifa_el_meson/provider/invoice_provider.dart';
import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:chifa_el_meson/provider/payment_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/provider/scroll_controller_provider.dart';
import 'package:chifa_el_meson/provider/shift_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

void main() {
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
              useMaterial3: true,
            ),
            home: const HomePage(),
          ),
        ));
  }
}
