import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class PaymentStatusStyle {
  late final String label;
  late final Color color;
  late final Color backgroundColor;
  late final PdfColor colorPdf;
  late final PdfColor backgroundColorPdf;

  PaymentStatusStyle(String name) {
    switch (name) {
      case 'pending':
        label = 'Pendiente';
        color = Colors.black;
        backgroundColor = Colors.yellowAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.yellowAccent100;
        break;
      case 'completed':
        label = 'Completado';
        color = Colors.black;
        backgroundColor = Colors.greenAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.greenAccent100;
        break;
      case 'failed':
        label = 'Incompleto';
        color = Colors.black;
        backgroundColor = Colors.redAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.redAccent100;
        break;
      case 'refunded':
        label = 'Reembolsado';
        color = Colors.white;
        backgroundColor = Colors.black;
        colorPdf = PdfColors.white;
        backgroundColorPdf = PdfColors.black;
        break;
      default:
        label = 'Desconocido';
        color = Colors.black;
        backgroundColor = Colors.tealAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.tealAccent100;
    }
  }
}