import 'dart:convert';

import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/product_model.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  try {
    final response = await http.get(Uri.parse("${Urls.apiUrl}/api/products/${Urls.companyId}"));
    if (response.statusCode == 200) {
      // log("Fetch Dishes: ${response.body}");
      // headers
      // log("Fetch Dishes headers: ${response.headers}");
      // log("Decoded response: ${json.decode(utf8.decode(response.bodyBytes))}");
      // log("bodyBytes: ${utf8.decode(response.bodyBytes)}");
      // log("JsonDecode : ${jsonDecode(response.body)}");
      // log("Response body: ${response.body}");
      // log("Response body decode: ${json.decode(response.body)}");
      // log("Fetch Dishes length: ${response.body.length}");
      final result = json.decode(response.body);
      final productsJson = result['products'];
      List<Product> products = [];
      for (var product in productsJson) {
        products.add(Product.fromJson(product));
      }
      return products;
    } else {
      throw FetchProductsException(response.body.toString());
    }
  } catch (e) {
    throw FetchProductsException(e.toString());
  }
}
