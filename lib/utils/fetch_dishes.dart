import 'dart:convert';
import 'package:chifa_el_meson/environment.dart';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:chifa_el_meson/model/dish_model.dart';
import 'package:chifa_el_meson/model/dishes_model.dart';
import 'package:http/http.dart' as http;

Future<Dishes> fetchDishes() async {
  try {
    final response = await http
        .get(Uri.parse("${Urls.apiUrl}/api/products/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final products = result['products'];
      List<Dish> dishes = [];
      for (var product in products) {
        dishes.add(Dish(
            id: product['id'],
            name: product['name'],
            description: product['description'],
            categoryId: product['category_id'],
            unitPrice: (product['regular_price'] as num).toDouble(),
            discountPrice: product['discounted_price'] == 0
                ? null
                : (product['regular_price'] as num).toDouble() -
                    (product['discounted_price'] as num).toDouble(),
            imageUrl: "${Urls.apiUrl}/storage/${product['image']}"));
      }
      return Dishes(dishes: dishes);
    } else {
      throw FetchDishesException(response.body.toString());
    }
  } catch (e) {
    throw FetchDishesException(e.toString());
  }
}
