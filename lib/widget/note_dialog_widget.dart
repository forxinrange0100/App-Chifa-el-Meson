import 'package:delivera/model/cart_item_model.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
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
    _notesController.text = widget.cartItem.notes.isEmpty ? "" : widget.cartItem.notes;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.zero,
      content: Padding(
        padding: const EdgeInsets.all(2.0),
        child: TextField(
          controller: _notesController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Escribe tus notas aquí...",
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(8.0),
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
            context.read<ShoppingCartProvider>().setNotes(widget.cartItem.id, _notesController.text);
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
