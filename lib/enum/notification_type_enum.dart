enum NotificationTypeEnum {
  orderTracking,
  unknown;

  const NotificationTypeEnum();

  static NotificationTypeEnum fromName(String name) {
    if (name.isEmpty) return NotificationTypeEnum.unknown;
    return NotificationTypeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => NotificationTypeEnum.unknown,
    );
  }
}
