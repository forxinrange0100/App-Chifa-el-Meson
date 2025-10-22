import 'package:delivera/model/dish_model.dart' show Dish;
import 'package:delivera/model/order_product_model.dart';
import 'package:delivera/model/payment_status_style_model.dart';
import 'package:delivera/utils/date_time_chile.dart';
import 'package:delivera/utils/format_price.dart';

/// Represents an order that's retrieved from the server
class Order {
  final int _id;
  final int publicId;
  int subtotal;
  int total;
  final DateTime timestamp;
  final String deliveryType;
  final int deliveryCost;
  String status;
  String paymentStatus;
  final PaymentStatusStyle paymentStatusStyle;
  final String paymentType;
  final String clientAddress;
  final String clientPhone;
  final String clientEmail;
  final String clientName;
  List<OrderProduct> orderProducts;
  DateTime get timestampChile => dateTimeChile(timestamp);

  String get formattedSubtotal => formatPrice(subtotal);
  List<OrderProduct> get enabledProducts => orderProducts.where((orderProduct) => orderProduct.enabled).toList();

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
      orderProducts: const []);

  /// Factory constructor to create an Order with values for some attributes, and the rest with default values
  factory Order.some({
    int? id,
    int? publicId,
    int? subtotal,
    int? total,
    DateTime? timestamp,
    String? deliveryType,
    int? deliveryCost,
    String? status,
    String? paymentStatus,
    String? paymentType,
    String? clientAddress,
    String? clientPhone,
    String? clientEmail,
    String? clientName,
    List<OrderProduct>? orderProducts,
  }) =>
      Order.empty().copyWith(
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
        orderProducts: orderProducts,
      );

  Order copyWith({
    int? id,
    int? publicId,
    int? subtotal,
    int? total,
    DateTime? timestamp,
    String? deliveryType,
    int? deliveryCost,
    String? status,
    String? paymentStatus,
    String? paymentType,
    String? clientAddress,
    String? clientPhone,
    String? clientEmail,
    String? clientName,
    List<OrderProduct>? orderProducts,
  }) =>
      Order(
        id: id ?? _id,
        publicId: publicId ?? this.publicId,
        subtotal: subtotal ?? this.subtotal,
        total: total ?? this.total,
        timestamp: timestamp ?? this.timestamp,
        deliveryType: deliveryType ?? this.deliveryType,
        deliveryCost: deliveryCost ?? this.deliveryCost,
        status: status ?? this.status,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        paymentType: paymentType ?? this.paymentType,
        clientAddress: clientAddress ?? this.clientAddress,
        clientPhone: clientPhone ?? this.clientPhone,
        clientEmail: clientEmail ?? this.clientEmail,
        clientName: clientName ?? this.clientName,
        orderProducts: orderProducts ?? this.orderProducts,
      );

  /// Remplaza los datos de los productos existentes en orderProducts con otros orderProducts (segun su id).
  /// Añade los que no estaban antes, y desactiva los que no se encuentren ahora
  void updateProducts(List<Dish> updatedProducts, {bool clearNotes = false}) {
    // Busca los productos a actualizar
    final List<OrderProduct> updatedOrderProducts = orderProducts.map((orderProduct) {
      // Obtiene el indice del producto en la lista
      int foundIndex = updatedProducts.indexWhere((p) => p.id == orderProduct.product.id);
      // Si no se encuentra el producto, lo desactiva
      if (foundIndex == -1) {
        return orderProduct.copyWith(
          product: orderProduct.product.copyWith(enabled: false),
          note: clearNotes ? '' : null,
        );
      }
      // Si se encuentra el producto, crea un nuevo OrderProduct con el producto actualizado
      final updatedOrderProduct = OrderProduct(
        product: updatedProducts.elementAt(foundIndex),
        quantity: orderProduct.quantity,
        note: orderProduct.note,
      );
      // Remueve el producto de la lista para reducir la busqueda
      updatedProducts.removeAt(foundIndex);
      return updatedOrderProduct;
    }).toList();

    orderProducts = updatedOrderProducts;
  }

  // Actualiza subtotal y total segun los OrderProducts que estan activados
  void updateTotals() {
    subtotal = orderProducts.fold(0, (prev, orderProduct) {
      return prev + (orderProduct.enabled ? orderProduct.totalPrice : 0);
    });

    total = subtotal + deliveryCost;
  }

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
