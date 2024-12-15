import 'package:chifa_el_meson/enum/bottom_navigation_bar_enum.dart';
import 'package:chifa_el_meson/pages/home_info_page.dart';
import 'package:chifa_el_meson/pages/shopping_cart_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/data_provider.dart';
import 'package:chifa_el_meson/provider/shift_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> getData() async {
    await context.read<DataProvider>().getData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getData();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressedAt;
    final List<Widget> pages = [
      const HomeInfoPage(),
      const ShoppingCartPage(),
    ];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (context.read<BottomNavigationBarProvider>().index ==
              BottomNavigationBarEnum.shoppingCar.index) {
            context.read<BottomNavigationBarProvider>().showHome();
            return;
          }
          final now = DateTime.now();
          final isFirstBackPress = lastPressedAt == null ||
              now.difference(lastPressedAt!) > const Duration(seconds: 5);

          if (isFirstBackPress) {
            lastPressedAt = now;
            context.read<DataProvider>().reset();
            closeAppToast();
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: context.watch<DataProvider>().done &&
              context.watch<DataProvider>().errorMessage.isEmpty
          ? Consumer<BottomNavigationBarProvider>(
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
                    onTap: (int index) async {
                      if (index == BottomNavigationBarEnum.shoppingCar.index) {
                        await context.read<ShiftProvider>().updateIsOpen();
                        if (!context.mounted) return;
                        if (!context.read<ShiftProvider>().isOpen) {
                          shiftIsCloseToast();
                          return;
                        }
                      }
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
            )
          : !context.watch<DataProvider>().done
              ? Scaffold(
                  backgroundColor: Colors.redAccent.shade700,
                  body: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : Scaffold(
                  backgroundColor: Colors.redAccent.shade700,
                  body: Center(
                    child: Text(
                        "Error ${context.watch<DataProvider>().errorMessage}"),
                  ),
                ),
    );
  }
}
