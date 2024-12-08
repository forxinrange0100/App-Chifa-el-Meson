import 'package:chifa_el_meson/model/cart_item_model.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoteDialog extends StatefulWidget {
  final CartItem cartItem;
  const NoteDialog({super.key, required this.cartItem});

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _notesController.text = widget.cartItem.preferenceNote.isEmpty
        ? ""
        : widget.cartItem.preferenceNote;
    return AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _notesController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Escribe tus notas aquí...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancelar",
            style: TextStyle(fontSize: 20),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context
                .read<ShoppingCartProvider>()
                .setPreference(widget.cartItem.id, _notesController.text);
            Navigator.of(context).pop();
          },
          child: const Text(
            "Guardar",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
