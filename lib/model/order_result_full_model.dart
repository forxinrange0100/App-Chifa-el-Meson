import 'package:chifa_el_meson/model/order_product_result_full_model.dart';

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
      required this.orderProducts});
}
