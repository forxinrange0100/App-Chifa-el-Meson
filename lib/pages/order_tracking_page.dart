import 'package:cached_network_image/cached_network_image.dart' show CachedNetworkImage;
import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/provider/invoice_provider.dart';
import 'package:delivera/widget/expandable_text_widget.dart' show ExpandableText;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderTrackingPage extends StatelessWidget {
  final Order _order;

  const OrderTrackingPage({super.key, required Order order}) : _order = order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color.fromARGB(255, 89, 81, 81),
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text("SEGUIMIENTO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<InvoiceProvider>(
          builder: (context, orderProvider, child) => Column(
            children: [
              Row(
                children: [
                  Icon(Icons.circle, size: 16, color: Colors.blue),
                  Container(width: 2, height: 50, color: Colors.blue),
                ],
              ),
              Text(
                OrderStatusEnum.fromName(orderProvider.order.status).label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Divider(height: 0, color: Colors.grey.shade300, thickness: 1),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Productos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: orderProvider.order.orderProducts.length,
                separatorBuilder: (_, __) => Divider(height: 5),
                itemBuilder: (context, index) {
                  final orderProduct = _order.enabledProducts[index];
                  return Row(
                    spacing: 8,
                    children: [
                      CachedNetworkImage(
                        imageUrl: orderProduct.product.imageUrl,
                        width: 50,
                        height: 50,
                        placeholder: (_, __) => CircularProgressIndicator(),
                        errorWidget: (_, __, ___) => Icon(Icons.error),
                      ),
                      Expanded(
                        child: ExpandableText(
                          orderProduct.product.name,
                          enabled: false,
                          maxLines: 3,
                        ),
                      ),
                      Text('x${orderProduct.quantity}'),
                      Text(orderProduct.formattedTotalPrice),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => InvoicePage(order: _order)),
              ),
              child: const Text(
                'Ver boleta',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(Colors.grey.shade400),
                foregroundColor: const WidgetStatePropertyAll<Color>(Colors.black),
              ),
              child: const Text(
                'Volver atrás',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
