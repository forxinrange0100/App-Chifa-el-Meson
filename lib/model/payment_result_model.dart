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


class PaymentResult {
  PaymentData? paymentData;
  int publicId;

  PaymentResult({this.paymentData, required this.publicId});
}
