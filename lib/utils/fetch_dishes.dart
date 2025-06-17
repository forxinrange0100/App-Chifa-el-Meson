import 'dart:convert';
import 'package:delivera/environment.dart';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/dish_model.dart';
import 'package:delivera/model/dishes_model.dart';
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
            createdAt: DateTime.parse(product['created_at']),
            updatedAt: DateTime.parse(product['updated_at']),
            name: product['name'],
            description: product['description'],
            regularPrice: product['regular_price'],
            discountedPrice: product['discounted_price'],
            image: "${Urls.apiUrl}/storage/${product['image']}",
            categoryId: product['category_id'],
            enabled: product['enabled'] == 1 ? true : false,
            displayOrder: product['display_order'],
            units: product['units']));
      }
      return Dishes(dishes: dishes);
    } else {
      throw FetchDishesException(response.body.toString());
    }
  } catch (e) {
    throw FetchDishesException(e.toString());
  }
}
