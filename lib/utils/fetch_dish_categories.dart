import 'dart:convert';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:chifa_el_meson/model/dish_categories_model.dart';
import 'package:chifa_el_meson/model/dish_category_model.dart';
import 'package:http/http.dart' as http;
import 'package:chifa_el_meson/environment.dart';

Future<DishCategories> fetchDishCategories() async {
  try {
    final response = await http
        .get(Uri.parse("${Urls.apiUrl}/api/categories/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final categoriesResult = result['categories'];
      List<DishCategory> categories = [];
      for (var category in categoriesResult) {
        categories.add(DishCategory(
          id: category['id'],
          createdAt: DateTime.parse(category['created_at']),
          updatedAt: DateTime.parse(category['updated_at']),
          name: category['name'],
          description: category['description'],
          displayOrder: category['display_order'],
        ));
      }
      return DishCategories(categories: categories);
    } else {
      throw FetchDishCategoriesException(response.body.toString());
    }
  } catch (e) {
    throw FetchDishCategoriesException(e.toString());
  }
}
