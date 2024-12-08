import 'package:chifa_el_meson/pages/home_page.dart';
import 'package:chifa_el_meson/provider/dish_categories_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => RestaurantInfoProvider()),
          ChangeNotifierProvider(create: (_) => DishCategoriesProvider())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ));
  }
}
