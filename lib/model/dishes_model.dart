import 'package:chifa_el_meson/model/dish_model.dart';

class Dishes {
  final List<Dish> dishes;
  Dishes({required this.dishes});
  Dishes.eample()
      : dishes = [
          Dish(
              id: 1,
              name: "Pollo mongoliano",
              description: "Pollo, cebollin, salsa de soya, caldo de pollo",
              unitPrice: 4000,
              categoryId: 1,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88ec3ad1ab.jpg"),
          Dish(
              id: 2,
              name: "chapsui especial",
              description:
                  "Verdura, carne, ave, algas, cebollín, camarones, champiñón, salsas chinas y almendras.",
              unitPrice: 9500,
              categoryId: 1,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f8ecdc39bcc.webp"),
          Dish(
              id: 3,
              name: "Chancho Mongoliano",
              description: "Chancho Mongoliano",
              unitPrice: 12990,
              previousPrice: 13990,
              categoryId: 2,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88e03b77ad.jpg"),
          Dish(
              id: 4,
              name: "Chancho Salsa Ajo",
              description: "Chancho Salsa Ajo",
              unitPrice: 12990,
              previousPrice: 14990,
              categoryId: 2,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88e03b77ad.jpg"),
          Dish(
              id: 5,
              name: "Carne salsa ajo",
              description:
                  "Filete Mignon, sal kasher, pimienta negra, ajo y romero",
              unitPrice: 7000,
              categoryId: 3,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f891c4d8c09.webp"),
          Dish(
              id: 6,
              name: "Carne champiñon",
              description: "carne, champiñon, algas",
              unitPrice: 6000,
              categoryId: 3,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f892973dcb6.jpg"),
          Dish(
              id: 7,
              name: "Pato Oriental",
              description: "Pato Oriental",
              unitPrice: 16990,
              categoryId: 4,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88dc9f01b3.jpg"),
          Dish(
              id: 8,
              name: "Pato Mongoliano",
              description: "Pato Mongoliano",
              unitPrice: 9990,
              previousPrice: 12000,
              categoryId: 4,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88e08e04a7.png"),
          Dish(
              id: 9,
              name: "Pollo con Piña",
              description: "Pollo, piña, arroz blanco o chaufa",
              unitPrice: 4000,
              categoryId: 5,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f887bd53123.jpg"),
          Dish(
              id: 10,
              name: "Pollo con champiñon",
              description: "Pollo, champiñon, arroz blanco o chaufa",
              unitPrice: 3800,
              categoryId: 5,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88e804bd5e.jpg"),
          Dish(
              id: 11,
              name: "Pescado tuasi",
              description:
                  "pescado, tuasi, salsa soja, jengibre, vino blanco, cilantro, aceite de sesamo, pimienta",
              unitPrice: 9000,
              categoryId: 6,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f88eb17e604.webp"),
          Dish(
              id: 12,
              name: "Pescado oriental",
              description:
                  "Filete de tilapia, salsa soya, cilantro, cebollin, jengibre",
              unitPrice: 8500,
              categoryId: 6,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66faa1645bc25.jpg"),
          Dish(
              id: 13,
              name: "Calamar salsa ajo",
              description: "calamares, diente de ajo, perejil y aceite oliva",
              unitPrice: 5000,
              categoryId: 7,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f887f318300.jpg"),
          Dish(
              id: 14,
              name: "Pulpo mongoliano",
              description:
                  "Filete de pollo furai con salsa oriental agridulce acompañado de arroz blanco y verduras salteadas.",
              unitPrice: 7000,
              categoryId: 7,
              imageUrl:
                  "https://delivera.autolistbeta.com/storage/products/66f888d43c4c1.webp"),
        ];
}
