class PaymentData {
  String paymentType = '';
  String paymentUrl = '';
  String? token;

  PaymentData(
      {required this.paymentType,
      required this.paymentUrl,
      this.token});

  static PaymentData fromJson(result) {
    return PaymentData(
        paymentType: result['payment_type'],
        paymentUrl: result['payment_url'],
        token: result['token']);
  }
}


class OrderResult {
  PaymentData? paymentData;
  int publicId;

  OrderResult({this.paymentData, required this.publicId});
}
