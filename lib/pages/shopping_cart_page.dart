import 'package:cached_network_image/cached_network_image.dart';
import 'package:chifa_el_meson/pages/order_summary_page.dart';
import 'package:chifa_el_meson/provider/bottom_navigation_bar_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/widget/expandable_text_widget.dart';
import 'package:chifa_el_meson/widget/note_dialog_widget.dart';
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
            ? Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const Center(
                          child: Text(
                            "CARRITO",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 550,
                                child: ListView(
                                  children: shoppingCartProvider.cardItems
                                      .map((cartItem) {
                                    return Dismissible(
                                        key: Key(cartItem.id),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          shoppingCartProvider
                                              .removeCardItem(cartItem.id);
                                        },
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Icon(Icons.delete,
                                                color: Colors.white),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  cartItem.dish.name,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Row(
                                                  children: [
                                                    OutlinedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.black,
                                                          overlayColor:
                                                              Colors.blue,
                                                          shape:
                                                              const CircleBorder(),
                                                        ),
                                                        onPressed: () {
                                                          shoppingCartProvider
                                                              .decrementQuantity(
                                                                  cartItem);
                                                        },
                                                        child: const Icon(
                                                          FontAwesomeIcons
                                                              .minus,
                                                          size: 15,
                                                        )),
                                                    Text(
                                                      cartItem.quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                    ),
                                                    OutlinedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          foregroundColor:
                                                              Colors.black,
                                                          overlayColor:
                                                              Colors.blue,
                                                          shape:
                                                              const CircleBorder(),
                                                        ),
                                                        onPressed: () {
                                                          shoppingCartProvider
                                                              .incrementQuantity(
                                                                  cartItem);
                                                        },
                                                        child: const Icon(
                                                          FontAwesomeIcons.plus,
                                                          size: 15,
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        cartItem.dish.imageUrl,
                                                    height: 100,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 100,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                          width: 200,
                                                          child: ExpandableText(
                                                              text: cartItem
                                                                  .dish
                                                                  .description)),
                                                      cartItem.dish
                                                                  .discountPrice !=
                                                              null
                                                          ? Container(
                                                              color:
                                                                  Colors.green,
                                                              child: Text(
                                                                "Ahorras un ${(((cartItem.dish.discountPrice ?? 0) / ((cartItem.dish.discountPrice ?? 0) + cartItem.dish.unitPrice)) * 100).toStringAsFixed(0)}% DTO",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                      cartItem.dish
                                                                  .discountPrice !=
                                                              null
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Text(
                                                                  "\$${(cartItem.dish.unitPrice + (cartItem.dish.discountPrice ?? 0)).toStringAsFixed(0)}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: const TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough),
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  "\$${(cartItem.dish.unitPrice * cartItem.quantity).toStringAsFixed(0)}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .end,
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          25,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ],
                                                            )
                                                          : Text(
                                                              "\$${(cartItem.dish.unitPrice * cartItem.quantity).toStringAsFixed(0)}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 25),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return NoteDialog(
                                                          cartItem: cartItem);
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  cartItem.preferenceNote
                                                          .isNotEmpty
                                                      ? "Ver notas"
                                                      : "Añadir notas",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                            const Divider()
                                          ],
                                        ));
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                              Text(
                                "\$${shoppingCartProvider.subTotal.toStringAsFixed(0)}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                ),
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
