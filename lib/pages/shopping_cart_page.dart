import 'package:delivera/pages/order_summary_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/widget/cart_item_widget.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, shoppingCartProvider, child) {
        if (shoppingCartProvider.length > 0) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              shadowColor: Colors.black,
              elevation: 2,
              leading: IconButton(
                onPressed: () => context.read<BottomNavigationBarProvider>().showHome(),
                icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
              ),
              centerTitle: true,
              title: const Text(
                "CARRITO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            body: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.68,
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                      thickness: 2,
                    ),
                    itemCount: shoppingCartProvider.shoppingCart.cartItems.length,
                    itemBuilder: (context, index) => CartItemWidget(cartItem: shoppingCartProvider.shoppingCart.cartItems[index]),
                  ),
                ),
                Expanded(child: Container(color: Colors.grey.shade300)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: () => shoppingCartProvider.cleanShoppingCart(),
                        label: Text('Vaciar carrito', style: TextStyle(color: Colors.red.shade700, fontSize: 16)),
                        icon: Icon(
                          FontAwesomeIcons.trash,
                          color: Colors.red.shade700,
                          size: 16,
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: Size(double.infinity, 32),
                        ),
                      ),
                      const Divider(
                        height: 0,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            PriceWidget(
                              price: shoppingCartProvider.shoppingCart.discountedPrice,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const OrderSummaryPage();
                            },
                          ));
                        },
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(FontAwesomeIcons.arrowRight),
                        label: SizedBox(
                          width: double.infinity,
                          child: const Text(
                            "Realizar pedido",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
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
            ),
          );
        }
      },
    );
  }
}
