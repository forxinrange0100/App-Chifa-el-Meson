import 'package:chifa_el_meson/pages/order_summary_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/widget/cart_item_widget.dart';
import 'package:chifa_el_meson/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, shoppingCartProvider, child) {
        return shoppingCartProvider.length > 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      AppBar(
                        surfaceTintColor: Colors.white,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 2,
                        leading: IconButton(
                            onPressed: () {
                              context
                                  .read<BottomNavigationBarProvider>()
                                  .showHome();
                            },
                            icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black,)),
                        centerTitle: true,
                        title: const Text(
                          "CARRITO",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: shoppingCartProvider.cardItems.map((cartItem) {
                        return CartItemWidget(cartItem: cartItem);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, bottom: 8.0),
                    child: Column(
                      children: [
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            PriceWidget(
                              price: shoppingCartProvider
                                  .shoppingCart.shoppingCartDiscountedPrice,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return const OrderSummaryPage();
                                },
                              ));
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Realizar pedido",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(FontAwesomeIcons.arrowRight)
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              )
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    FontAwesomeIcons.boxOpen,
                    size: 60,
                  ),
                  const Text(
                    "No hay productos en el carrito",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<BottomNavigationBarProvider>().showHome();
                    },
                    icon: const Icon(FontAwesomeIcons.cartShopping),
                    label: const Text("Ir a comprar"),
                  )
                ],
              ));
      },
    );
  }
}
