class FetchDeliveryZonesException implements Exception {
  final String message;

  FetchDeliveryZonesException([this.message = 'Failed to fetch delivery zones']);

  @override
  String toString() {
    return 'FetchDeliveryZonesException: $message';
  }
}

class FetchDispatchEnabledException implements Exception {
  final String message;

  FetchDispatchEnabledException([this.message = 'No se pudo obtener la configuración de envíos del restaurante, inténtelo más tarde.']);

  @override
  String toString() {
    return "FetchDispatchEnabledException: $message";
  }
}

class FetchProductsException implements Exception {
  final String message;

  FetchProductsException([this.message = 'Failed to fetch products']);

  @override
  String toString() {
    return 'FetchProductsException: $message';
  }
}

class FetchDishCategoriesException implements Exception {
  final String message;

  FetchDishCategoriesException([this.message = 'Failed to fetch dish categories']);

  @override
  String toString() {
    return 'FetchDishCategoriesException: $message';
  }
}

class FetchRestaurantInfoException implements Exception {
  final String message;

  FetchRestaurantInfoException([this.message = 'Failed to fetch restaurant info']);

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

class FetchOrderFullException implements Exception {
  final String message;

  FetchOrderFullException([this.message = 'Failed to fetch order full']);

  @override
  String toString() {
    return 'FetchOrderFullException: $message';
  }
}

class CustomException implements Exception {
  String message;
  String? details;

  CustomException({this.message = '', this.details});

  String _getDetails() {
    if (details == null) return '';
    return ' Detalles: $details';
  }

  @override
  String toString() {
    return '$runtimeType: $message.${_getDetails()}';
  }
}

class ServerException extends CustomException {
  ServerException({super.message = 'Error del servidor, intente más tarde', super.details});
}

class ConnectionErrorException extends CustomException {
  ConnectionErrorException({super.message = 'Error de conexión, verifique su conexión a internet', super.details});
}

class ResponseParsingException extends CustomException {
  ResponseParsingException({super.message = 'Error al parsear la respuesta del servidor', super.details});
}
