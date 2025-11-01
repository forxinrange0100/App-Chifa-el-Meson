enum DeliveryTypeEnum { 
  pickup, 
  dispatch,
  unknown;

  // No necesita un label, ya que cambia según el contexto de uso
  const DeliveryTypeEnum();

  static DeliveryTypeEnum fromName(String name) {
    if (name.isEmpty) return DeliveryTypeEnum.unknown;
    return DeliveryTypeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => DeliveryTypeEnum.pickup,
    );
  }
}
