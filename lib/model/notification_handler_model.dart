import 'dart:convert' show jsonDecode;
import 'dart:developer';

import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/enum/notification_type_enum.dart' show NotificationTypeEnum;
import 'package:delivera/main.dart' show navigatorKey;
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
import 'package:delivera/pages/order_tracking_page.dart';
import 'package:delivera/provider/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:provider/provider.dart';

abstract class NotificationHandler {
  int? notificationId;
  factory NotificationHandler.fromType(NotificationTypeEnum typeEnum) {
    switch (typeEnum) {
      case NotificationTypeEnum.orderTracking:
        return OrderTrackingNotification();
      default:
        return DefaultNotification();
    }
  }

  factory NotificationHandler.fromRuntimeType(String runtimeType) {
    switch (runtimeType) {
      case 'OrderTrackingNotification':
        return OrderTrackingNotification();
      default:
        return DefaultNotification();
    }
  }

  void handleReceived(dynamic payload);
  void handleTapped(dynamic payload);
  
  /// Guarda el tipo de notification handler y el payload en el storage local.
  /// Para poder instanciar el mismo tipo de notification handler cuando se abre la app.
  static void store(NotificationHandler notificationHandler, dynamic payload) async {
    Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

    try {
      final notificationBox = Hive.box(name: 'notification');
      if (notificationBox.isNotEmpty) notificationBox.clear();
      notificationBox.put(notificationHandler.runtimeType.toString(), payload);
      notificationBox.close();
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }

  /// Busca la notificación en el storage local y ejecuta sus acciones si corresponde.
  /// Instancia el [NotificationHandler] correspondiente y ejecuta su metodo [NotificationHandler.handleTapped].
  static void handleStoredNotification() {
    try {
      final notificationBox = Hive.box(name: 'notification');
      log('notificationBox empty: ${notificationBox.isEmpty}');
      if (notificationBox.isEmpty) return;
      final String notificationHandlerType = notificationBox.keys.first;
      final dynamic payload = notificationBox.get(notificationHandlerType);
      final notificationHandler = NotificationHandler.fromRuntimeType(notificationHandlerType);
      notificationHandler.handleTapped(payload);
      notificationBox.clear();
      notificationBox.close();
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
    }
  }
}

class OrderTrackingNotification implements NotificationHandler {
  @override
  int? notificationId = 1;

  @override
  void handleReceived(dynamic payload) {
    log('OrderTracking Notification received');
    // Ver si existe la order en el storage local
    final orderJson = jsonDecode(payload['order']);
    final order = Order.fromJson(orderJson);
    order.storeOrder();
    final orderTracking = OrderTracking.fromOrder(order);
    orderTracking.store(DeliveryTypeEnum.fromName(order.deliveryType));
    final routeContext = navigatorKey.currentContext;
    if (routeContext == null) return;
    if (order.publicId != routeContext.read<InvoiceProvider>().order.publicId) return;
    routeContext.read<InvoiceProvider>().setOrder(order);
  }

  @override
  void handleTapped(dynamic payload) {
    log('OrderTracking Notification tapped');
    // Setear order en el provider
    final orderJson = jsonDecode(payload['order']);
    final order = Order.fromJson(orderJson);
    final currentRoute = navigatorKey.currentState;
    final routeContext = navigatorKey.currentContext;
    if (currentRoute == null || routeContext == null) return;
    routeContext.read<InvoiceProvider>().setOrder(order);
    currentRoute.push(MaterialPageRoute(builder: (routeContext) => OrderTrackingPage()));
  }
}

class DefaultNotification implements NotificationHandler {
  @override
  int? notificationId;

  @override
  void handleReceived(dynamic payload) {
    log('Default Notification received');
  }

  @override
  void handleTapped(dynamic payload) {
    log('Default Notification tapped');
  }
}
