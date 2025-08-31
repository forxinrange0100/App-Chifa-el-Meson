import 'package:delivera/model/order_product_model.dart';
import 'package:delivera/model/payment_status_style_model.dart';
import 'package:delivera/utils/date_time_chile.dart';

enum StatusEnum {
  pending('Pendiente'),
  completed('Completado'),
  canceled('Cancelado'),
  unknown('Desconocido');

  final String label;
  const StatusEnum(this.label);

  static StatusEnum fromName(String name) {
    if (name.isEmpty) return StatusEnum.unknown;
    return StatusEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => StatusEnum.unknown,
    );
  }
}

/// Represents an order that's retrieved from the server
class Order {
  final int _id;
  final int publicId;
  final int subtotal;
  final int total;
  final DateTime timestamp;
  final String deliveryType;
  final int deliveryCost;
  String status;
  final String paymentStatus;
  final PaymentStatusStyle paymentStatusStyle;
  final String paymentType;
  final String clientAddress;
  final String clientPhone;
  final String clientEmail;
  final String clientName;
  final List<OrderProduct> orderProducts;
  DateTime get timestampChile => dateTimeChile(timestamp);

  Order(
      {required int id,
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
      : paymentStatusStyle = PaymentStatusStyle(paymentStatus),
        _id = id;

  /// Factory constructor to create an Order with default values
  factory Order.empty() => Order(
      id: 0,
      publicId: 0,
      subtotal: 0,
      total: 0,
      timestamp: DateTime.now(),
      deliveryType: '',
      deliveryCost: 0,
      status: '',
      paymentStatus: '',
      paymentType: '',
      clientAddress: '',
      clientPhone: '',
      clientEmail: '',
      clientName: '',
      orderProducts: []);

  /// Factory constructor to create an Order with values for some attributes, and the rest with default values
  factory Order.some({
    int id = 0,
    int publicId = 0,
    int subtotal = 0,
    int total = 0,
    DateTime? timestamp,
    String deliveryType = '',
    int deliveryCost = 0,
    String status = '',
    String paymentStatus = '',
    String paymentType = '',
    String clientAddress = '',
    String clientPhone = '',
    String clientEmail = '',
    String clientName = '',
    List<OrderProduct> orderProducts = const [],
  }) =>
      Order(
        id: id,
        publicId: publicId,
        subtotal: subtotal,
        total: total,
        timestamp: timestamp ?? DateTime.now(),
        deliveryType: deliveryType,
        deliveryCost: deliveryCost,
        status: status,
        paymentStatus: paymentStatus,
        paymentType: paymentType,
        clientAddress: clientAddress,
        clientPhone: clientPhone,
        clientEmail: clientEmail,
        clientName: clientName,
        orderProducts: orderProducts,
      );

  /// Factory constructor to create an Order from a JSON
  factory Order.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return Order(
      id: map['id'] as int,
      publicId: map['public_id'] as int,
      subtotal: map['subtotal'] as int,
      total: map['total'] as int,
      timestamp: DateTime.parse(map['timestamp']),
      deliveryType: map['delivery_type'] as String,
      deliveryCost: map['delivery_cost'] as int,
      status: map['status'] as String,
      paymentStatus: map['payment_status'] as String,
      paymentType: map['payment_type'] as String,
      clientAddress: map['client_address'] as String,
      clientPhone: map['client_phone'] as String,
      clientEmail: map['client_email'] as String,
      clientName: map['client_name'] as String,
      orderProducts: List<OrderProduct>.from(map['order_products'].map((x) => OrderProduct.fromJson(x))),
    );
  }

  /// Converts an Order to a JSON Map
  Map<String, dynamic> toJson() => {
        'id': _id,
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
        'order_products': orderProducts.map((orderProduct) => orderProduct.toJson()).toList(),
      };
}
