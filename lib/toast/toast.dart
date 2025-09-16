import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

void successToast(String message, {Icon? icon}) {
  toastification.show(
    icon: icon ?? const Icon(FontAwesomeIcons.solidCircleCheck),
    title: Text(message),
    style: ToastificationStyle.flat,
    type: ToastificationType.success,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.green),
    autoCloseDuration: const Duration(seconds: 3),
  );
}

void errorToast(String message, {Icon? icon}) {
  toastification.show(
    icon: icon ?? const Icon(FontAwesomeIcons.triangleExclamation),
    title: Text(message),
    style: ToastificationStyle.flat,
    type: ToastificationType.error,
    showProgressBar: true,
    progressBarTheme: const ProgressIndicatorThemeData(color: Colors.red),
    autoCloseDuration: const Duration(seconds: 5),
  );
}

void warningToast(String message, {Icon? icon}) {
  toastification.show(
    icon: icon ?? const Icon(FontAwesomeIcons.triangleExclamation),
    title: Text(
      message,
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

void closeAppToast() {
  warningToast('Si presionas nuevamente hacia atrás, se cerrará la aplicación');
}

void shiftClosedToast() {
  errorToast('Restaurant cerrado');
}

void addingCartItemToast() {
  successToast('Producto añadido al carrito');
}

void addingCartItemsToast() {
  successToast('Productos agregados al carrito');
}

void cleanCartToast() {
  successToast('Carrito vaciado');
}

void errorOrderSummary(String error) {
  errorToast('Faltan campos', icon: const Icon(FontAwesomeIcons.circleXmark));
}

void savedInvoice() {
  successToast('Boleta guardada', icon: const Icon(FontAwesomeIcons.file));
}

void unsavedInvoice() {
  errorToast('Boleta no guardada', icon: const Icon(FontAwesomeIcons.file));
}

// Toast for server error
void serverErrorToast(String error) {
  errorToast('Error del servidor');
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
