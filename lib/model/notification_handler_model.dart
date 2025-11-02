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
import 'package:provider/provider.dart';

abstract class NotificationHandler {
  factory NotificationHandler.fromType(NotificationTypeEnum typeEnum) {
    switch (typeEnum) {
      case NotificationTypeEnum.orderTracking:
        return OrderTrackingNotification();
      default:
        return DefaultNotification();
    }
  }

  void handleReceived(dynamic payload);
  void handleTapped(dynamic payload);
}

class OrderTrackingNotification implements NotificationHandler {
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
  void handleReceived(dynamic payload) {
    // TODO: implement handle
    log('Default Notification received');
  }

  @override
  void handleTapped(dynamic payload) {
    // TODO: implement handle
    log('Default Notification tapped');
  }
}
