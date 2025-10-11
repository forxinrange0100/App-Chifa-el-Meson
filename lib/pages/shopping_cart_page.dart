import 'package:delivera/pages/order_summary_page.dart';
import 'package:delivera/provider/bottom_navigation_bar_provider.dart';
import 'package:delivera/provider/shift_provider.dart' show ShiftProvider;
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/toast/toast.dart' show cleanCartToast, serverErrorToast, shiftClosedToast;
import 'package:delivera/widget/cart_item_widget.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart' show SlidableAutoCloseBehavior;
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons, FaIcon;
import 'package:provider/provider.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, shoppingCartProvider, child) {
        if (shoppingCartProvider.length == 0) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.boxOpen,
                  size: 60,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 50),
                  child: Text("No hay productos en el carrito", style: TextStyle(fontSize: 20)),
                ),
                ElevatedButton.icon(
                  icon: const FaIcon(FontAwesomeIcons.cartShopping),
                  label: const Text("Ir a comprar"),
                  onPressed: () {
                    context.read<BottomNavigationBarProvider>().showHome();
                  },
                )
              ],
            ),
          );
        } else {
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
              actions: [
                IconButton(
                  onPressed: () => cleanCartDialog(context),
                  icon: const FaIcon(FontAwesomeIcons.solidTrashCan, color: Colors.red),
                ),
              ],
              centerTitle: true,
              title: const Text(
                "CARRITO",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            backgroundColor: Colors.grey.shade300,
            body: Container(
              color: Colors.white,
              child: SlidableAutoCloseBehavior(
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
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(
                    height: 2,
                    thickness: 2,
                    color: Colors.grey.shade300,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton.icon(
                      onPressed: () => _proceedToCheckout(context),
                      iconAlignment: IconAlignment.end,
                      icon: context.watch<ShiftProvider>().isFetching
                          ? const CircularProgressIndicator(color: Colors.white, constraints: BoxConstraints.tightFor(width: 24, height: 24))
                          : const Icon(FontAwesomeIcons.arrowRight),
                      label: SizedBox(
                        width: double.infinity,
                        child: const Text(
                          "Realizar pedido",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  void _proceedToCheckout(BuildContext context) async {
    // Check if the shift is open before navigating to the order summary page
    try {
      await context.read<ShiftProvider>().updateIsOpen();
    } catch (e) {
      if (!context.mounted) return;
      serverErrorToast();
      return;
    }

    if (!context.mounted) return;
    if (!context.read<ShiftProvider>().isOpen) {
      shiftClosedToast();
      return;
    }
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrderSummaryPage()),
    );
  }

  Future<void> cleanCartDialog(BuildContext context) {
    final textButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size(0, 0),
      maximumSize: Size(double.infinity, 32),
    );

    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(top: 10, bottom: 5),
                  child: Text(
                    '¿Desea vaciar el carrito?',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  height: 10,
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: textButtonStyle,
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ShoppingCartProvider>().cleanShoppingCart();
                        cleanCartToast();
                        Navigator.pop(context);
                      },
                      style: textButtonStyle.merge(ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.redAccent.shade700),
                      )),
                      child: const Text("Vaciar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
