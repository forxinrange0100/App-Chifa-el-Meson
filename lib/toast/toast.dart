import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

void addingCartItemToast() {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.solidCircleCheck),
    title: const Text('Producto añadido al carrito'),
    style: ToastificationStyle.flat,
    type: ToastificationType.success,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.green),
    autoCloseDuration: const Duration(seconds: 5),
  );
}
