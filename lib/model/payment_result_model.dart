class PaymentData {
  String paymentType = '';
  String paymentUrl = '';
  String? token;

  PaymentData(
      {required this.paymentType,
      required this.paymentUrl,
      this.token});

  factory PaymentData.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json);
    return PaymentData(
        paymentType: map['payment_type'],
        paymentUrl: map['payment_url'],
        token: map['token']);
  }
}


class PaymentResult {
  PaymentData? paymentData;
  int publicId;

  PaymentResult({this.paymentData, required this.publicId});
}
