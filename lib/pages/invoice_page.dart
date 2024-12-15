import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Boleta"),
      ),
      body: Center(
        child: Text(
            "Invoice ${context.watch<OrderSummaryProvider>().orderResult.publicId}"),
      ),
    );
  }
}
