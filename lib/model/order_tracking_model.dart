import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/order_model.dart';
import 'package:hive/hive.dart' show Hive;

class OrderTracking {
  final int orderPublicId;
  final Map<OrderStatusEnum, DateTime> timestamps;

  OrderTracking({required this.orderPublicId, required this.timestamps});

  factory OrderTracking.empty() => OrderTracking(orderPublicId: 0, timestamps: {});

  factory OrderTracking.some({
    int? orderPublicId,
    Map<OrderStatusEnum, DateTime>? timestamps,
  }) =>
      OrderTracking.empty().copyWith(
        orderPublicId: orderPublicId,
        timestamps: timestamps,
      );

  OrderTracking copyWith({
    int? orderPublicId,
    Map<OrderStatusEnum, DateTime>? timestamps,
  }) =>
      OrderTracking(
        orderPublicId: orderPublicId ?? this.orderPublicId,
        timestamps: timestamps ?? this.timestamps,
      );

  factory OrderTracking.fromOrder(Order order) {
    return OrderTracking(
      orderPublicId: order.publicId,
      timestamps: {
        OrderStatusEnum.fromName(order.status): order.updatedAt!,
      },
    );
  }

  /// Devuelve el OrderStatusEnum sin cancelar con el timestamp mas reciente
  OrderStatusEnum lastActiveStatus() {
    if (timestamps.isEmpty) return OrderStatusEnum.pending;
    return timestamps.entries.reduce((a, b) => a.value.isAfter(b.value) || b.key == OrderStatusEnum.canceled ? a : b).key;
  }

  /// Guarda el OrderTracking en el almacenamiento local (Hive).
  /// Si ya existe, lo actualiza anadiendo el nuevo timestamp.
  /// Debe usarse con el OrderTracking obtenido de fromOrder.
  void store(DeliveryTypeEnum deliveryType) {
    final hiveBox = Hive.box<OrderTracking>(name: 'ordersTracking');
    // Si ya existe, lo actualiza añadiendo el nuevo timestamp
    final orderTracking = hiveBox.get(orderPublicId.toString());
    if (orderTracking == null) {
      hiveBox.put(orderPublicId.toString(), this);
      hiveBox.close();
      return;
    }

    OrderStatusEnum thisOrderStatus = timestamps.keys.first;
    // Si no es OrderStatusEnum.canceled, borra canceled y los timestamps posteriores al proceso
    if (thisOrderStatus != OrderStatusEnum.canceled) {
      final orderProcess = OrderStatusEnum.getStatusProcess(deliveryType);
      final orderProcessIndex = orderProcess.indexOf(thisOrderStatus);
      orderTracking.timestamps.removeWhere((key, value) => orderProcess.indexOf(key) > orderProcessIndex || key == OrderStatusEnum.canceled);
    }

    orderTracking.timestamps.addAll(timestamps);
    hiveBox.put(orderPublicId.toString(), orderTracking);
    hiveBox.close();
  }

  static OrderTracking? fromStorage(int orderPublicId) {
    final hiveBox = Hive.box<OrderTracking>(name: 'ordersTracking');
    final orderTracking = hiveBox.get(orderPublicId.toString());
    hiveBox.close();
    return orderTracking;
  }

  factory OrderTracking.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;

    return OrderTracking(
      orderPublicId: map['order_public_id'] as int,
      timestamps: map['timestamps'].map<OrderStatusEnum, DateTime>(
        (key, value) => MapEntry(OrderStatusEnum.fromName(key), DateTime.parse(value)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'order_public_id': orderPublicId,
        'timestamps': timestamps.map(
          (key, value) => MapEntry(key.name, value.toIso8601String()),
        ),
      };
}
