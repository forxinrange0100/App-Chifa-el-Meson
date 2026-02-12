import 'dart:developer' show log;

import 'package:hive_ce/hive_ce.dart' show Hive;

class PaymentData {
  final String paymentType;
  final String paymentUrl;
  final String? token;

  PaymentData({required this.paymentType, required this.paymentUrl, this.token});

  factory PaymentData.fromJson(dynamic json) {
    final map = Map<String, dynamic>.from(json);
    return PaymentData(
      paymentType: map['payment_type'],
      paymentUrl: map['payment_url'],
      token: map['token'],
    );
  }
}

class PaymentResult {
  PaymentData paymentData;
  int publicId;

  PaymentResult({required this.paymentData, required this.publicId});

  // Guarda el resultado de la order en el almacenamiento local
  // Solo si es tipo getnet
  void store() {
    final paymentBox = Hive.box('payment');
    paymentBox.putAll({
      'paymentType': paymentData.paymentType,
      'paymentUrl': paymentData.paymentUrl,
      'token': paymentData.token,
      'publicId': publicId,
    });
  }

  static PaymentResult? fromStorage() {
    final box = Hive.box('payment');
    if (box.isEmpty) {
      return null;
    }
    PaymentResult? orderResult;
    try {
      final paymentData = PaymentData(
        paymentType: box.get('paymentType'),
        paymentUrl: box.get('paymentUrl'),
        token: box.get('token'),
      );
      orderResult = PaymentResult(
        paymentData: paymentData,
        publicId: box.get('publicId'),
      );
    } catch (e, stackTrace) {
      log("Error retrieving PaymentResult from storage: $e", stackTrace: stackTrace);
    }
    return orderResult;
  }

  static void clearStorage() {
    final box = Hive.box('payment');
    box.clear();
  }
}
