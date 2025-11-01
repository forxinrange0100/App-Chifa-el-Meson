import 'package:delivera/enum/payment_status_enum.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class PaymentStatusStyle {
  late final String label;
  late final Color color;
  late final Color backgroundColor;
  late final PdfColor colorPdf;
  late final PdfColor backgroundColorPdf;

  PaymentStatusStyle(String name) {
    final nameEnum = PaymentStatusEnum.fromName(name);
    switch (nameEnum) {
      case PaymentStatusEnum.pending:
        label = PaymentStatusEnum.pending.label;
        color = Colors.black;
        backgroundColor = Colors.yellowAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.yellowAccent100;
        break;
      case PaymentStatusEnum.completed:
        label = PaymentStatusEnum.completed.label;
        color = Colors.black;
        backgroundColor = Colors.greenAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.greenAccent100;
        break;
      case PaymentStatusEnum.failed:
        label = PaymentStatusEnum.failed.label;
        color = Colors.black;
        backgroundColor = Colors.redAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.redAccent100;
        break;
      case PaymentStatusEnum.refunded:
        label = PaymentStatusEnum.refunded.label;
        color = Colors.white;
        backgroundColor = Colors.black;
        colorPdf = PdfColors.white;
        backgroundColorPdf = PdfColors.black;
        break;
      default:
        label = PaymentStatusEnum.unknown.label;
        color = Colors.black;
        backgroundColor = Colors.tealAccent.shade100;
        colorPdf = PdfColors.black;
        backgroundColorPdf = PdfColors.tealAccent100;
    }
  }
}