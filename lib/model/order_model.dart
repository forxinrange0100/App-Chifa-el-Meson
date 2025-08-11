import 'package:delivera/model/order_product_model.dart';
import 'package:delivera/model/payment_status_style_model.dart';

class Order {
  final int id;
  final int publicId;
  final int subtotal;
  final int total;
  final DateTime timestamp;
  final String deliveryType;
  final int deliveryCost;
  final String status;
  final String paymentStatus;
  final PaymentStatusStyle paymentStatusStyle;
  final String paymentType;
  final String clientAddress;
  final String clientPhone;
  final String clientEmail;
  final String clientName;
  final List<OrderProduct> orderProducts;

  Order(
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
      required this.orderProducts})
      : paymentStatusStyle = PaymentStatusStyle(paymentStatus);

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json['id'],
      publicId: json['public_id'],
      subtotal: json['subtotal'],
      total: json['total'],
      timestamp: DateTime.parse(json['timestamp']),
      deliveryType: json['delivery_type'],
      deliveryCost: json['delivery_cost'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      paymentType: json['payment_type'],
      clientAddress: json['client_address'],
      clientPhone: json['client_phone'],
      clientEmail: json['client_email'],
      clientName: json['client_name'],
      orderProducts: List<OrderProduct>.from(json['order_products'].map((x) => OrderProduct.fromJson(x))));

  Map<String, dynamic> toJson() => {
        'id': id,
        'public_id': publicId,
        'subtotal': subtotal,
        'total': total,
        'timestamp': timestamp.toIso8601String(),
        'delivery_type': deliveryType,
        'delivery_cost': deliveryCost,
        'status': status,
        'payment_status': paymentStatus,
        'payment_type': paymentType,
        'client_address': clientAddress,
        'client_phone': clientPhone,
        'client_email': clientEmail,
        'client_name': clientName,
        'order_products': List<dynamic>.from(orderProducts.map((orderProduct) => orderProduct.toJson)),
      };
}
