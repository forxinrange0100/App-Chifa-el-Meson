import 'dart:convert';
import 'dart:developer' show log;
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/dish_model.dart';
import 'package:delivera/model/order_product_model.dart';
import 'package:delivera/model/order_model.dart';
import 'package:delivera/utils/date_time_chile.dart';
import 'package:http/http.dart' as http;

Future<Order> fetchOrderFull(int publicId) async {
  try {
    final response = await http.get(Uri.parse(
      "${Urls.apiUrl}/api/orders/public/$publicId",
    ));

    if (response.statusCode != 200) {
      throw FetchOrderFullException(response.body.toString());
    }
    
    final result = json.decode(response.body);
    final int id = result['order']['id'];
    final int subtotal = result['order']['subtotal'];
    final int total = result['order']['total'];
    final DateTime timestamp = dateTimeChile(DateTime.parse(result['order']['timestamp']));
    final String deliveryType = result['order']['delivery_type'];
    final int deliveryCost = result['order']['delivery_cost'];
    final String status = result['order']['status'];
    final String paymentStatus = result['order']['payment_status'];
    final String paymentType = result['order']['payment_type'];
    final String clientAddress = result['order']['client_address'];
    final String clientPhone = result['order']['client_phone'];
    final String clientEmail = result['order']['client_email'];
    final String clientName = result['order']['client_name'];
    final List<OrderProduct> orderProducts = [];

    for (var orderProduct in result['order']['order_products']) {
      final int id = orderProduct['product']['id'];
      final String name = orderProduct['product']['name'];
      final String description = orderProduct['product']['description'];
      final int regularPrice = orderProduct['product']['regular_price'];
      final int discountedPrice = orderProduct['product']['discounted_price'];
      final String image = orderProduct['product']['image'] ?? '';
      final int displayOrder = orderProduct['product']['display_order'];
      final int quantity = orderProduct['quantity'];
      final String note = orderProduct['note'] ?? '';

      orderProducts.add(OrderProduct(
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

    Order order= Order(
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

    log('Order: ${order.toJson()}');
    log('Es orden?: ${order.runtimeType}');

    return order;
  } catch (e) {
    rethrow;
  }
}
