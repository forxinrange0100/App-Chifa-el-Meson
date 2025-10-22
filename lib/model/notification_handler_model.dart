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

  void handle(dynamic payload);
}

class OrderTrackingNotification implements NotificationHandler {
  @override
  void handle(dynamic payload) {
    // TODO: implement handle
  }
}

class DefaultNotification implements NotificationHandler {
  @override
  void handle(dynamic payload) {
    // TODO: implement handle
  }
}
