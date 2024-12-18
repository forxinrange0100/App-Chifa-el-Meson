import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PricePWWidget extends pw.StatelessWidget {
  final int price;
  final PdfColor color;
  final double fontSize;
  final pw.FontWeight fontWeight;
  final String prefix;
  final String postfix;
  final pw.TextDecoration textDecoration;

  PricePWWidget({
    required this.price,
    this.color = PdfColors.black,
    this.fontSize = 14,
    this.fontWeight = pw.FontWeight.normal,
    this.prefix = "",
    this.postfix = "",
    this.textDecoration = pw.TextDecoration.none,
  });

  @override
  pw.Widget build(pw.Context context) {
    return pw.Text(
      "$prefix\$${NumberFormat.decimalPattern('es').format(price)}$postfix",
      style: pw.TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
      ),
    );
  }
}
