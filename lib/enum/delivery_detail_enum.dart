enum DeliveryDetailEnum { 
  pickup, 
  dispatch,
  unknown;

  // No necesita un label, ya que cambia según el contexto de uso
  const DeliveryDetailEnum();

  static DeliveryDetailEnum fromName(String name) {
    if (name.isEmpty) return DeliveryDetailEnum.unknown;
    return DeliveryDetailEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => DeliveryDetailEnum.pickup,
    );
  }
}
