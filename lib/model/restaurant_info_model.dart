class RestaurantInfo {
  final String name;
  final String description;
  final String address;
  final String phoneNumber;
  final String openingHour;
  final String iconUrl;
  final String backgroundUrl;

  RestaurantInfo({
    required this.name,
    required this.description,
    required this.address,
    required this.phoneNumber,
    required this.openingHour,
    required this.iconUrl,
    required this.backgroundUrl,
  });

  RestaurantInfo.example()
      : name = "CHIFA EL MESÓN",
        description =
            "Te ofrecemos una experiencia culinaria que mezcla lo mejor de la cocina china. Cada plato que servimos, desde el clásico arroz chaufa hasta los deliciosos tallarines saltados, está preparado con ingredientes frescos y lleno de sabor. Queremos que te sientas como en casa cuando nos visites, disfrutando de porciones generosas en un ambiente cálido y familiar. Nos enorgullece combinar tradición y modernidad en cada bocado, para que siempre quieras volver a probar algo nuevo o disfrutar de tus favoritos. ¡Te esperamos con los brazos abiertos!",
        address = "Av. Sta. María 1364",
        phoneNumber = "(58) 222 5443",
        openingHour = "12:00-03:30pm / 07:30-12:00am",
        iconUrl =
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO1njC8_1isD088zFCt7T6DMBqZfQDlLUFdQ&s",
        backgroundUrl =
            "https://lh3.googleusercontent.com/p/AF1QipMMzO260Pj_togHeSxCR5sQJS_nTTW_bwTiMgCh=s680-w680-h510";
}
