import 'package:chifa_el_meson/pages/home_info_page.dart';
import 'package:chifa_el_meson/pages/shopping_cart_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/data_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeInfoPage(),
      const ShoppingCartPage(),
    ];
    Future<bool> getData() async {
      try {
        await context.read<DataProvider>().getData();
        return true;
      } catch (_) {
        return false;
      }
    }

    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Consumer<BottomNavigationBarProvider>(
            builder: (context, bottomNavigationProvider, child) {
              return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: [
                    pages[bottomNavigationProvider.index],
                    if (bottomNavigationProvider.isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: bottomNavigationProvider.index,
                  onTap: (int index) {
                    bottomNavigationProvider.setIndex(index);
                  },
                  items: [
                    const BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Inicio",
                    ),
                    BottomNavigationBarItem(
                      icon: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: CircleAvatar(
                              radius: 8,
                              backgroundColor: Colors.red,
                              child: Text(
                                context
                                    .watch<ShoppingCartProvider>()
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      label: "Carrito",
                    )
                  ],
                ),
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Center(
                  child: Text(
                      "Error ${context.watch<DataProvider>().errorMessage}")),
            ),
          );
        }
      },
    );
  }
}
