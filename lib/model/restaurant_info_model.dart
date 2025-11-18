class RestaurantInfo {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String description;
  final String logo;
  final String heroImage;
  final String instagram;
  final String facebook;
  final String whatsapp;
  final String address;
  final String phone;
  final String schedule;

  RestaurantInfo({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.logo,
    required this.heroImage,
    required this.instagram,
    required this.facebook,
    required this.whatsapp,
    required this.address,
    required this.phone,
    required this.schedule,
  });

  RestaurantInfo.example()
      : id = 1,
        createdAt = DateTime.parse("2024-10-12T16:37:13.000000Z"),
        updatedAt = DateTime.parse("2024-10-12T16:37:13.000000Z"),
        name = "Chifa El Mesón",
        description =
            "Te ofrecemos una experiencia culinaria que mezcla lo mejor de la cocina china. Cada plato que servimos, desde el clásico arroz chaufa hasta los deliciosos tallarines saltados, está preparado con ingredientes frescos y lleno de sabor. Queremos que te sientas como en casa cuando nos visites, disfrutando de porciones generosas en un ambiente cálido y familiar. Nos enorgullece combinar tradición y modernidad en cada bocado, para que siempre quieras volver a probar algo nuevo o disfrutar de tus favoritos. ¡Te esperamos con los brazos abiertos!",
        logo = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQO1njC8_1isD088zFCt7T6DMBqZfQDlLUFdQ&s",
        heroImage = "https://lh3.googleusercontent.com/p/AF1QipMMzO260Pj_togHeSxCR5sQJS_nTTW_bwTiMgCh=s680-w680-h510",
        instagram = "instagram",
        facebook =
            "https://web.facebook.com/profile.php?id=283060081707270&paipv=0&eav=Afb5LcORRibn-75uxGb3IBP_HYmbJyPCAlzLgCr9K-QTKdxZQcLuA2jsTKZH4M27YXg&_rdc=1&_rdr",
        whatsapp = "whatsapp",
        address = "Av. Sta. María 1364",
        phone = "(58) 222 5443",
        schedule = "12:00-03:30pm / 07:30-12:00am";

  factory RestaurantInfo.fromJson(dynamic json) {
    final map = json as Map<String, dynamic>;
    return RestaurantInfo(
      id: map['id'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      name: map['name'],
      description: map['description'],
      logo: map['logo'],
      heroImage: map['hero_image'],
      instagram: map['instagram'],
      facebook: map['facebook'],
      whatsapp: map['whatsapp'],
      address: map['address'],
      phone: map['phone'],
      schedule: map['schedule'],
    );
  }
}
