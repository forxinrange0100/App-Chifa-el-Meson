import 'package:chifa_el_meson/model/order_product_result_full_model.dart';
import 'package:chifa_el_meson/model/payment_status_model.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class OrderResultFull {
  final int id;
  final int publicId;
  final int subtotal;
  final int total;
  final DateTime timestamp;
  final String deliveryType;
  final int deliveryCost;
  final String status;
  final String paymentStatus;
  final PaymentStatus paymentStatusFull;
  final String paymentType;
  final String clientAddress;
  final String clientPhone;
  final String clientEmail;
  final String clientName;
  final List<OrderProductResultFull> orderProducts;

  OrderResultFull(
      {required this.id,
      required this.publicId,
      required this.subtotal,
      required this.total,
      required this.timestamp,
      required this.deliveryType,
      required this.deliveryCost,
      required this.status,
      required this.paymentStatus,
      required this.paymentType,
      required this.clientAddress,
      required this.clientPhone,
      required this.clientEmail,
      required this.clientName,
      required this.orderProducts})
      : paymentStatusFull = _paymentStatusFull(paymentStatus);

  static PaymentStatus _paymentStatusFull(String paymentStatus) {
    switch (paymentStatus) {
      case 'pending':
        return PaymentStatus(
            name: 'Pendiente',
            color: Colors.black,
            backgroundColor: Colors.yellow.shade300,
            colorPdf: PdfColors.black,
            backgroundColorPdf: PdfColors.yellow300);
      case 'completed':
        return PaymentStatus(
            name: 'Completado',
            color: Colors.black,
            backgroundColor: Colors.green.shade300,
            colorPdf: PdfColors.black,
            backgroundColorPdf: PdfColors.green300);
      case 'failed':
        return PaymentStatus(
            name: 'Error',
            color: Colors.black,
            backgroundColor: Colors.red.shade300,
            colorPdf: PdfColors.black,
            backgroundColorPdf: PdfColors.red300);
      case 'refunded':
        return PaymentStatus(
            name: 'Reembolsado',
            color: Colors.white,
            backgroundColor: Colors.black,
            colorPdf: PdfColors.white,
            backgroundColorPdf: PdfColors.black);
      default:
        return PaymentStatus(
            name: paymentStatus,
            color: Colors.black,
            backgroundColor: Colors.teal.shade300,
            colorPdf: PdfColors.black,
            backgroundColorPdf: PdfColors.teal300);
    }
  }
}
