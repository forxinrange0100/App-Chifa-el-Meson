import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class PaymentStatus {
  final String name;
  final Color color;
  final Color backgroundColor;
  final PdfColor colorPdf;
  final PdfColor backgroundColorPdf;
  PaymentStatus(
      {required this.name,
      required this.color,
      required this.backgroundColor,
      required this.colorPdf,
      required this.backgroundColorPdf});
}
