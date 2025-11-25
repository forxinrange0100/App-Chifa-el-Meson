import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivera/model/cart_item_model.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/widget/expandable_text_widget.dart';
import 'package:delivera/widget/note_dialog_widget.dart';
import 'package:delivera/widget/price_widget.dart';
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

class _CartItemWidgetState extends State<CartItemWidget> with SingleTickerProviderStateMixin {
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
        final String discountPercentage = widget.cartItem.product.discountPercentage;

        final double imageWidth = MediaQuery.of(context).size.width / 3;

        return Slidable(
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
                  shoppingCartProvider.removeCartItem(widget.cartItem.id);
                },
                icon: FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: Colors.white,
                  size: 20,
                ).icon,
                label: 'Eliminar',
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.cartItem.product.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                ),
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(imageWidth),
                    1: const FixedColumnWidth(10),
                    2: const FlexColumnWidth(),
                  },
                  children: [
                    TableRow(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: widget.cartItem.product.imageUrl,
                            width: imageWidth,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(),
                        SizedBox(
                          height: imageWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ExpandableText(
                                    widget.cartItem.product.description,
                                    maxLines: 3,
                                    enabled: false,
                                  ),
                                ),
                              ),
                              discountPercentage.isNotEmpty
                                  ? Container(
                                      color: Colors.green,
                                      child: Text(
                                        "Ahorras un $discountPercentage% DTO",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  : const SizedBox(),
                              widget.cartItem.product.discountedPrice != 0
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        PriceWidget(
                                          price: widget.cartItem.product.regularPrice * widget.cartItem.quantity,
                                          textDecoration: TextDecoration.lineThrough,
                                        ),
                                        PriceWidget(
                                          price: widget.cartItem.product.discountedPrice * widget.cartItem.quantity,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        PriceWidget(
                                          price: widget.cartItem.product.regularPrice * widget.cartItem.quantity,
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
                    TableRow(
                      children: [
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
                            widget.cartItem.notes.isNotEmpty ? "Ver notas" : "Añadir notas",
                            style: const TextStyle(decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(),
                        _counterWidget(shoppingCartProvider),
                      ],
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

  Row _counterWidget(ShoppingCartProvider shoppingCartProvider) {
    final ButtonStyle circularButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      overlayColor: Colors.blue,
      shape: const CircleBorder(),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: circularButtonStyle,
          onPressed: () {
            if (widget.cartItem.quantity == 1) {
              controller.openEndActionPane();
              return;
            }
            shoppingCartProvider.decrementQuantity(widget.cartItem);
          },
          child: const Icon(
            FontAwesomeIcons.minus,
            size: 15,
          ),
        ),
        Text(
          widget.cartItem.quantity.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        OutlinedButton(
          style: circularButtonStyle,
          onPressed: () {
            controller.close();
            shoppingCartProvider.incrementQuantity(widget.cartItem);
          },
          child: const Icon(
            FontAwesomeIcons.plus,
            size: 15,
          ),
        ),
      ],
    );
  }
}
