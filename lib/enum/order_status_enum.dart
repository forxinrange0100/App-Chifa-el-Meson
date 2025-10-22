enum OrderStatusEnum {
  pending('Pendiente'),
  completed('Completado'),
  canceled('Cancelado'),
  unknown('Desconocido');

  final String label;
  const OrderStatusEnum(this.label);

  static OrderStatusEnum fromName(String name) {
    if (name.isEmpty) return OrderStatusEnum.unknown;
    return OrderStatusEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => OrderStatusEnum.unknown,
    );
  }
}
