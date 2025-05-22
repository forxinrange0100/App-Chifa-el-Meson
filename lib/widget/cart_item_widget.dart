import 'package:cached_network_image/cached_network_image.dart';
import 'package:chifa_el_meson/model/cart_item_model.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/widget/expandable_text_widget.dart';
import 'package:chifa_el_meson/widget/note_dialog_widget.dart';
import 'package:chifa_el_meson/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatefulWidget {
  final CartItem cartItem;
  const CartItemWidget({super.key, required this.cartItem});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    with SingleTickerProviderStateMixin {
  late final controller = SlidableController(this);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCartProvider>(
      builder: (context, shoppingCartProvider, child) {
        return Column(
          children: [
            Slidable(
                key: Key(widget.cartItem.id),
                controller: controller,
                endActionPane: ActionPane(
                    extentRatio: 0.25,
                    motion: const ScrollMotion(),
                    dragDismissible: false,
                    children: [
                      SlidableAction(
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.redAccent.shade700,
                        foregroundColor: Colors.white,
                        onPressed: (context) {
                          shoppingCartProvider
                              .removeCardItem(widget.cartItem.id);
                        },
                        icon: Icons.delete,
                        label: 'Eliminar',
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              widget.cartItem.dish.name.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            children: [
                              OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    overlayColor: Colors.blue,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    if (widget.cartItem.quantity == 1) {
                                      controller.openEndActionPane();
                                      return;
                                    }
                                    shoppingCartProvider
                                        .decrementQuantity(widget.cartItem);
                                  },
                                  child: const Icon(
                                    FontAwesomeIcons.minus,
                                    size: 15,
                                  )),
                              Text(
                                widget.cartItem.quantity.toString(),
                                style: const TextStyle(fontSize: 20),
                              ),
                              OutlinedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    overlayColor: Colors.blue,
                                    shape: const CircleBorder(),
                                  ),
                                  onPressed: () {
                                    controller.close();
                                    shoppingCartProvider
                                        .incrementQuantity(widget.cartItem);
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.cartItem.dish.image.endsWith("null")
                                  ? "https://chifaelmeson.cl/img/default.webp"
                                  : widget.cartItem.dish.image,
                              height: MediaQuery.of(context).size.height / 6.5,
                              width: MediaQuery.of(context).size.width / 3,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 6.5,
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    child: ExpandableText(
                                  text: widget.cartItem.dish.description,
                                  enabled: false,
                                )),
                                widget.cartItem.dish.discountedPrice != 0
                                    ? Container(
                                        color: Colors.green,
                                        child: Text(
                                          "Ahorras un ${(((1 - (widget.cartItem.dish.discountedPrice / widget.cartItem.dish.regularPrice))) * 100).toStringAsFixed(0)}% DTO",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : const SizedBox(),
                                widget.cartItem.dish.discountedPrice != 0
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          PriceWidget(
                                              price: widget
                                                  .cartItem.dish.regularPrice,
                                              textDecoration:
                                                  TextDecoration.lineThrough),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          PriceWidget(
                                            price: widget.cartItem.dish
                                                    .discountedPrice *
                                                widget.cartItem.quantity,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          PriceWidget(
                                            price: widget.cartItem.dish
                                                    .regularPrice *
                                                widget.cartItem.quantity,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return NoteDialog(cartItem: widget.cartItem);
                              },
                            );
                          },
                          child: Text(
                            widget.cartItem.preferenceNote.isNotEmpty
                                ? "Ver notas"
                                : "Añadir notas",
                            style: const TextStyle(
                                decoration: TextDecoration.underline),
                          )),
                    ],
                  ),
                )),
            const Divider(
              height: 1.0,
              thickness: 2.0,
              indent: 0.0,
              endIndent: 0.0,
            )
          ],
        );
      },
    );
  }
}
