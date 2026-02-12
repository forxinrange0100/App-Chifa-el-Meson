import 'package:delivera/model/product_model.dart';

class Dishes {
  final List<Product> dishes;
  Dishes({required this.dishes}) {
    dishes.sort((a, b) => a.displayOrder - b.displayOrder);
  }
  Dishes.example() : dishes = [];
}
