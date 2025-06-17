class PaymentType{
  final String string;
  final String imgSrc;

  const PaymentType({required this.string, required this.imgSrc});
}

const List<PaymentType> paymentTypes = [
  PaymentType(string: 'transbank', imgSrc: 'assets/transbank.png'),
  PaymentType(string: 'getnet', imgSrc: 'assets/getnet.jpg'),
];
