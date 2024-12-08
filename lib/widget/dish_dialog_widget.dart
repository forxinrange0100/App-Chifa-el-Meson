import 'package:cached_network_image/cached_network_image.dart';
import 'package:chifa_el_meson/model/dish_model.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/widget/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DishDialog extends StatefulWidget {
  final Dish dish;
  const DishDialog({super.key, required this.dish});

  @override
  State<DishDialog> createState() => _DishDialogState();
}

class _DishDialogState extends State<DishDialog> {
  int _counter = 1;
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 600,
        width: 400,
        child: ListView(
          children: [
            CachedNetworkImage(
              imageUrl: widget.dish.imageUrl,
              width: 400,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.dish.discountPrice != null
                      ? Container(
                          color: Colors.green,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Ahorras un ${(((widget.dish.discountPrice ?? 0) / ((widget.dish.discountPrice ?? 0) + widget.dish.unitPrice)) * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    widget.dish.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ExpandableText(text: widget.dish.description),
                  widget.dish.discountPrice != null
                      ? Row(
                          children: [
                            Text(
                              "\$${widget.dish.unitPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "\$${(widget.dish.unitPrice + (widget.dish.discountPrice ?? 0)).toStringAsFixed(0)}",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        )
                      : Text(
                          "\$${widget.dish.unitPrice.toStringAsFixed(0)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                  const Divider(),
                  const Text("Cantidad",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                              onPressed: () {
                                if (_counter == 1) return;
                                setState(() {
                                  _counter--;
                                });
                              },
                              child: const Text("-")),
                          Text(_counter.toString()),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _counter++;
                                });
                              },
                              child: const Text("+"))
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const Text("Notas",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Escribe aquí tus notas...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.green)),
            onPressed: () {
              context
                  .read<ShoppingCartProvider>()
                  .addCardItem(widget.dish, _counter, _notesController.text);
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${(_counter * widget.dish.unitPrice).toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 20),
                ),
                const Text(
                  "AGREGAR",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
