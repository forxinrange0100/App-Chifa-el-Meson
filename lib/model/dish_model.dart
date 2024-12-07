class Dish {
  final int id;
  final String name;
  final String description;
  final double unitPrice;
  final double? discountPrice;
  final String imageUrl;
  final int categoryId;

  Dish({
    required this.id,
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.categoryId,
    this.discountPrice,
    required this.imageUrl,
  });
}
