import 'dart:developer';

import 'package:delivera/enum/notification_type_enum.dart' show NotificationTypeEnum;

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
    // TODO: implement handle
    log('OrderTracking Notification received');
  }

  @override
  void handleTapped(dynamic payload) {
    // TODO: implement handle
    log('OrderTracking Notification tapped');
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
