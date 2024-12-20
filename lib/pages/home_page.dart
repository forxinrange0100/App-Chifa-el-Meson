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

class _HomePageState extends State<HomePage> {
  Future<bool> getData() async {
    await context.read<DataProvider>().getData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressedAt;
    final List<Widget> pages = [
      const HomeInfoPage(),
      const ShoppingCartPage(),
    ];
    return FutureBuilder<bool>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
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
                  Text("Estamos cargando todo para ti, espera un momento...")
                ],
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
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
                        backgroundColor: Colors.white,
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
                            if (index ==
                                BottomNavigationBarEnum.shoppingCar.index) {
                              await context
                                  .read<ShiftProvider>()
                                  .updateIsOpen();
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
                                      backgroundColor: Colors.black,
                                      child: CircleAvatar(
                                        radius: 7,
                                        backgroundColor: Colors.white,
                                        child: Center(
                                          child: Text(
                                            context
                                                .watch<ShoppingCartProvider>()
                                                .length
                                                .toString(),
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
                              ),
                              label: "Carrito",
                            )
                          ],
                        ),
                      );
                    },
                  )
                : !context.watch<DataProvider>().done
                    ? const Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: CircularProgressIndicator(
                              color: Colors.blue, backgroundColor: Colors.grey),
                        ),
                      )
                    : Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: Text(
                              "Error ${context.watch<DataProvider>().errorMessage}"),
                        ),
                      ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Text("Error"),
            ),
          );
        }
      },
    );
  }
}
