import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivera/provider/dish_categories_provider.dart';
import 'package:delivera/provider/dishes_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/scroll_controller_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/widget/dish_dialog_widget.dart';
import 'package:delivera/widget/expandable_text_widget.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeInfoPage extends StatelessWidget {
  const HomeInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: context.watch<ScrollControllerProvider>().scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeaderRestaurantInfo(context),
        ),
        SliverAppBar(
          pinned: true,
          floating: false,
          primary: false,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          collapsedHeight: 80,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: _buildCategories(context),
            titlePadding: EdgeInsets.zero,
          ),
        ),
        SliverList(delegate: _buildDishes(context))
      ],
    );
  }

  Widget _buildHeaderRestaurantInfo(BuildContext context) {
    return Consumer<RestaurantInfoProvider>(
      builder: (context, restaurantInfoProvider, child) {
        return Column(
          children: [
            Stack(children: [
              CachedNetworkImage(
                imageUrl: restaurantInfoProvider.restaurantInfo.heroImage,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.redAccent.shade700,
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DefaultTextStyle(
                          style: const TextStyle(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(FontAwesomeIcons.locationDot,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(restaurantInfoProvider
                                      .restaurantInfo.address),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(restaurantInfoProvider
                                      .restaurantInfo.phone),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidClock,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(restaurantInfoProvider
                                      .restaurantInfo.schedule),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              context.watch<ShiftProvider>().isOpen
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCircle,
                                            color: Colors.green,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Turno Abierto"),
                                        ],
                                      ),
                                    )
                                  : const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            FontAwesomeIcons.solidCircle,
                                            color: Colors.red,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text("Turno Cerrado"),
                                        ],
                                      ),
                                    ),
                            ],
                          )),
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: restaurantInfoProvider.restaurantInfo.logo,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ))
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantInfoProvider.restaurantInfo.name.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const Text(
                    "Descripción:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  ExpandableText(
                      text: restaurantInfoProvider.restaurantInfo.description)
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context) {
    return Consumer<DishCategoriesProvider>(
      builder: (context, dishCategoriesProvider, child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dishCategoriesProvider.dishCategories.categories.length,
            itemBuilder: (context, index) {
              return TextButton(
                onPressed: () {
                  final context = dishCategoriesProvider.dishCategories
                      .categories[index].categoryKey.currentContext;
                  if (context != null) {
                    Scrollable.ensureVisible(
                      context,
                      duration: const Duration(seconds: 1),
                      curve: Curves.ease,
                      alignment: 0.0,
                    );
                  }
                },
                child: Text(
                  dishCategoriesProvider.dishCategories.categories[index].name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 20),
                ),
              );
            },
          ),
        );
      },
    );
  }

  SliverChildListDelegate _buildDishes(BuildContext context) {
    return SliverChildListDelegate(
      [
        Consumer<DishCategoriesProvider>(
          builder: (context, dishCategoriesProvider, child) {
            return Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: dishCategoriesProvider.dishCategories.categories
                      .map((category) => SizedBox(
                          key: category.categoryKey,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Center(
                                    child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
                              Consumer<DishesProvider>(
                                builder: (context, dishProvider, child) {
                                  return Column(
                                    children: dishProvider
                                        .getDishesByCategory(category.id)
                                        .map((dish) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: cardItemStyle(),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return DishDialog(dish: dish);
                                                },
                                              );
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 160,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      SizedBox(
                                                        width: 150,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              dish.name,
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            ExpandableText(
                                                              text: dish.description,
                                                              maxLines: 3,
                                                              enabled: false,
                                                              color: Colors.grey,
                                                            ),
                                                            Center(
                                                                child: dish.discountedPrice !=
                                                                        0
                                                                    ? Row(
                                                                        children: [
                                                                          PriceWidget(
                                                                              price: dish.discountedPrice,
                                                                              color: Colors.green,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold),
                                                                          const SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          PriceWidget(
                                                                              price: dish.regularPrice,
                                                                              textDecoration: TextDecoration.lineThrough),
                                                                        ],
                                                                      )
                                                                    : PriceWidget(
                                                                        price: dish.regularPrice,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize:25)
                                                                    ),
                                                          ],
                                                        ),
                                                      ),
                                                      CachedNetworkImage(
                                                        imageUrl: dish.image
                                                                .endsWith(
                                                                    "null")
                                                            ? "https://chifaelmeson.cl/img/default.webp"
                                                            : dish.image,
                                                        width: 170,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return DishDialog(
                                                              dish: dish);
                                                        },
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(FontAwesomeIcons.cartShopping),
                                                        SizedBox(width: 10),
                                                        Text("AGREGAR AL CARRITO"),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              )
                            ],
                          )))
                      .toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  ButtonStyle cardItemStyle() {
    return const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.white),
      foregroundColor: WidgetStatePropertyAll(Colors.black),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
