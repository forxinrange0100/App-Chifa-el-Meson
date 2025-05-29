import 'package:delivera/model/dish_category_model.dart';

class DishCategories {
  final List<DishCategory> categories;

  DishCategories({
    required this.categories,
  }) {
    categories.sort((a, b) => a.displayOrder - b.displayOrder);
  }

  DishCategories.example() : categories = [];
}
