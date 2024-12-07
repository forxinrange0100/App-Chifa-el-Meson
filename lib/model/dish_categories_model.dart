import 'package:chifa_el_meson/model/dish_category_model.dart';

class DishCategories {
  final List<DishCategory> categories;

  DishCategories({
    required this.categories,
  });

  DishCategories.example()
      : categories = [
          DishCategory(id: 1, name: "Especialidad"),
          DishCategory(id: 2, name: "Chancho"),
          DishCategory(id: 3, name: "Carnes"),
          DishCategory(id: 4, name: "Pato"),
          DishCategory(id: 5, name: "Pollos"),
          DishCategory(id: 6, name: "Pescado"),
          DishCategory(id: 7, name: "Mariscos")
        ];
}
