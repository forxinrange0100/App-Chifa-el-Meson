import 'dart:convert' show jsonEncode, jsonDecode;
import 'dart:developer';
import 'package:delivera/toast/toast.dart' show serverErrorToast;
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/services/firebase_messaging_service.dart' show FirebaseMessagingService;

/// Realiza la peticion para crear el pedido y devuelve el resultado. La petición incluye el token FCM para notificaciones push.
Future<PaymentResult?> fetchOrder(OrderSummary orderSummary) async {
  final String? fcmToken = FirebaseMessagingService.instance().token;

  try {
    final body = jsonEncode({
      "delivery_type": orderSummary.deliveryDetails.name,
      "payment_type": orderSummary.paymentType,
      "dispatch_zone_id": orderSummary.deliveryDetails.zone?.id,
      "order_products": orderSummary.shoppingCart.cartItems.map((cartItem) {
        return {
          "product_id": cartItem.dish.id,
          "quantity": cartItem.quantity,
          "product_note": cartItem.notes,
        };
      }).toList(),
      "client": {
        "name": orderSummary.userDetails.fullName,
        "email": orderSummary.userDetails.email,
        "phone": orderSummary.userDetails.phoneNumber,
        "address": orderSummary.deliveryDetails.address,
      },
      "device_token": fcmToken,
    });

    log("fetchOrder iniciado");
    final response = await http.post(
      Uri.parse(
        "${Urls.apiUrl}/api/orders/${Urls.companyId}",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );

    log("fetchOrder Response status: ${response.statusCode}");
    
    late final dynamic result;

    try {
      result = jsonDecode(response.body);
    } catch (e) {
      throw ResponseParsingException(details: e.toString());
    }

    if (response.statusCode != 201) {
      final errorMessage = "Ocurrió un error en la solicitud: ${result['message']}";
      // stats code
      serverErrorToast(errorMessage);
      throw ServerException(message: errorMessage);
    }

    final paymentData = PaymentData.fromJson(result['payment_data']);

    if (result['order'] == null) {
      throw ResponseParsingException(details: "order es null");
    }

    final int publicId = result['order']['public_id'];

    return PaymentResult(paymentData: paymentData, publicId: publicId);
  } catch (e) {
    throw FetchOrderException(e.toString());
  } finally {
    log('fetchOrder finalizado');
  }
}
