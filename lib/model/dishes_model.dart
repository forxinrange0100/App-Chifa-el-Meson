import 'package:chifa_el_meson/model/dish_model.dart';

class Dishes {
  final List<Dish> dishes;
  Dishes({required this.dishes}) {
    dishes.sort((a, b) => a.displayOrder - b.displayOrder);
  }
  Dishes.example() : dishes = [];
}
