import 'dart:convert';
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/dish_categories_model.dart';
import 'package:delivera/model/dish_category_model.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';

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
      // Add default category "Sin categoría" with id 0 at the end
      categories.add(DishCategory(
          id: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          name: "Sin categoría",
          description: "Sin categoría",
          displayOrder: 9999));
      return DishCategories(categories: categories);
    } else {
      throw FetchDishCategoriesException(response.body.toString());
    }
  } catch (e) {
    throw FetchDishCategoriesException(e.toString());
  }
}
