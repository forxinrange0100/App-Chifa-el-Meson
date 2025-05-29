import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

void closeAppToast() {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.triangleExclamation),
    title: const Text(
      'Si presionas nuevamente hacia atrás, se cerrará la aplicación',
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
    style: ToastificationStyle.flat,
    type: ToastificationType.warning,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.orange),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void shiftIsCloseToast() {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.solidCircleCheck),
    title: const Text('Restaurant Cerrado'),
    style: ToastificationStyle.flat,
    type: ToastificationType.error,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

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

void errorOrderSummary(String error) {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.circleXmark),
    title: const Text("Faltan campos"),
    description: Text(error),
    style: ToastificationStyle.flat,
    type: ToastificationType.error,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void savedInvoice() {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.file),
    title: const Text("Boleta guardada"),
    style: ToastificationStyle.flat,
    type: ToastificationType.success,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.green),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void unsavedInvoice() {
  toastification.show(
    icon: const Icon(FontAwesomeIcons.file),
    title: const Text("Boleta no guardada"),
    style: ToastificationStyle.flat,
    type: ToastificationType.error,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

// void storageNotGranted() {
//   toastification.show(
//     icon: const Icon(FontAwesomeIcons.solidFile),
//     title: const Text("Sin permiso de almacenamiento"),
//     style: ToastificationStyle.flat,
//     type: ToastificationType.error,
//     showProgressBar: true,
//     progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
//     autoCloseDuration: const Duration(seconds: 5),
//   );
// }
