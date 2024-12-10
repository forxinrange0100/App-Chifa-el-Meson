class FetchDeliveryZonesException implements Exception {
  final String message;

  FetchDeliveryZonesException(
      [this.message = 'Failed to fetch delivery zones']);

  @override
  String toString() {
    return 'FetchDeliveryZonesException: $message';
  }
}

class FetchDishesException implements Exception {
  final String message;

  FetchDishesException([this.message = 'Failed to fetch dishes']);

  @override
  String toString() {
    return 'FetchDishesException: $message';
  }
}

class FetchDishCategoriesException implements Exception {
  final String message;

  FetchDishCategoriesException(
      [this.message = 'Failed to fetch dish categories']);

  @override
  String toString() {
    return 'FetchDishCategoriesException: $message';
  }
}

class FetchRestaurantInfoException implements Exception {
  final String message;

  FetchRestaurantInfoException(
      [this.message = 'Failed to fetch restaurant info']);

  @override
  String toString() {
    return 'FetchRestaurantInfoException: $message';
  }
}

class FetchOrderException implements Exception {
  final String message;

  FetchOrderException([this.message = 'Failed to fetch order']);

  @override
  String toString() {
    return 'FetchOrderException: $message';
  }
}
