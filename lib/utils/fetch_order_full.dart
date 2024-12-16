import 'dart:convert';
import 'package:chifa_el_meson/environment.dart';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:chifa_el_meson/model/dish_model.dart';
import 'package:chifa_el_meson/model/order_product_result_full_model.dart';
import 'package:chifa_el_meson/model/order_result_full_model.dart';
import 'package:http/http.dart' as http;

Future<OrderResultFull> fetchOrderFull(int publicId) async {
  try {
    final response = await http.get(Uri.parse(
      "${Urls.apiUrl}/api/orders/public/$publicId",
    ));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final int id = result['order']['id'];
      final int publicId = result['order']['public_id'];
      final int subtotal = result['order']['subtotal'];
      final int total = result['order']['total'];
      final DateTime timestamp = DateTime.parse(result['order']['timestamp']);
      final String deliveryType = result['order']['delivery_type'];
      final int deliveryCost = result['order']['delivery_cost'];
      final String status = result['order']['status'];
      final String paymentStatus = result['order']['payment_status'];
      final String paymentType = result['order']['payment_type'];
      final String clientAddress = result['order']['client_address'];
      final String clientPhone = result['order']['client_phone'];
      final String clientEmail = result['order']['client_email'];
      final String clientName = result['order']['client_name'];
      final List<OrderProductResultFull> orderProducts = [];
      for (var orderProduct in result['order']['order_products']) {
        final int id = orderProduct['product']['id'];
        final String name = orderProduct['product']['name'];
        final String description = orderProduct['product']['description'];
        final int regularPrice = orderProduct['product']['regular_price'];
        final int discountedPrice = orderProduct['product']['discounted_price'];
        final String image = orderProduct['product']['image'];
        final int displayOrder = orderProduct['product']['display_order'];
        final int quantity = orderProduct['quantity'];
        final String note = orderProduct['note'] ?? '';

        orderProducts.add(OrderProductResultFull(
            product: Dish(
                id: id,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                name: name,
                description: description,
                regularPrice: regularPrice,
                discountedPrice: discountedPrice,
                image: image,
                categoryId: 0,
                enabled: true,
                displayOrder: displayOrder,
                units: 0),
            quantity: quantity,
            note: note));
      }

      return OrderResultFull(
          id: id,
          publicId: publicId,
          subtotal: subtotal,
          total: total,
          timestamp: timestamp,
          deliveryType: deliveryType,
          deliveryCost: deliveryCost,
          status: status,
          paymentStatus: paymentStatus,
          paymentType: paymentType,
          clientAddress: clientAddress,
          clientPhone: clientPhone,
          clientEmail: clientEmail,
          clientName: clientName,
          orderProducts: orderProducts);
    } else {
      throw FetchOrderFullException(response.body.toString());
    }
  } catch (e) {
    throw FetchOrderFullException(e.toString());
  }
}
