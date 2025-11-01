enum PaymentStatusEnum {
  pending('Pendiente'),
  completed('Completado'),
  failed('Incompleto'),
  refunded('Reembolsado'),
  unknown('Desconocido');

  final String label;
  const PaymentStatusEnum(this.label);

  static PaymentStatusEnum fromName(String name) {
    // Convierte el nombre a minúsculas y busca el enum correspondiente
    if (name.isEmpty) return PaymentStatusEnum.unknown;
    // Obtener el enum por su nombre
    return PaymentStatusEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => PaymentStatusEnum.unknown,
    );
  }
}
