import 'package:pdf/widgets.dart' as pw;

pw.Document generateInvoicePdf() {
  final pw.Document pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) => pw.Center(child: pw.Text('Hello World!')),
    ),
  );
  return pdf;
}
