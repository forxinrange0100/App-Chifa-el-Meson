enum PaymentTypeEnum {
  transbank(
    imgSrc: 'assets/transbank.png',
  ),
  getnet(
    imgSrc: 'assets/getnet.jpg',
  ),
  unknown(
    imgSrc: '',
  );

  final String imgSrc;

  const PaymentTypeEnum({required this.imgSrc});

  factory PaymentTypeEnum.fromName(String name) {
    // Convierte el nombre a minúsculas y busca el enum correspondiente
    if (name.isEmpty) return PaymentTypeEnum.unknown;
    // Obtener el enum por su nombre
    return PaymentTypeEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => PaymentTypeEnum.unknown,
    );
  }
}

const List<PaymentTypeEnum> paymentTypesList = [
  PaymentTypeEnum.transbank,
  PaymentTypeEnum.getnet,
];
