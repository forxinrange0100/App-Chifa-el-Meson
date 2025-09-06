import 'dart:convert';
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/order_model.dart';
import 'package:http/http.dart' as http;

Future<Order> fetchOrderFull(int publicId) async {
  try {
    final response = await http.get(Uri.parse(
      "${Urls.apiUrl}/api/orders/public/$publicId",
    ));

    if (response.statusCode != 200) {
      throw FetchOrderFullException(response.body.toString());
    }
    
    final result = json.decode(response.body);

    return Order.fromJson(result['order']);
  } catch (e) {
    rethrow;
  }
}
