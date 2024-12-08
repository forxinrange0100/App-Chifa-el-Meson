import 'package:cached_network_image/cached_network_image.dart';
import 'package:chifa_el_meson/provider/dish_categories_provider.dart';
import 'package:chifa_el_meson/provider/dishes_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/provider/scroll_controller_provider.dart';
import 'package:chifa_el_meson/widget/dish_dialog_widget.dart';
import 'package:chifa_el_meson/widget/expandable_text_widget.dart';
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
          surfaceTintColor: Colors.white,
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
                imageUrl: restaurantInfoProvider.restaurantInfo.backgroundUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
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
                                      .restaurantInfo.phoneNumber),
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
                                      .restaurantInfo.openingHour),
                                ],
                              )
                            ],
                          )),
                      ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                              restaurantInfoProvider.restaurantInfo.iconUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ))
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurantInfoProvider.restaurantInfo.name,
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
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: dishCategoriesProvider.dishCategories.categories
                  .map((category) => SizedBox(
                      key: category.categoryKey,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                            category.name,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                          Consumer<DishesProvider>(
                            builder: (context, dishProvider, child) {
                              return Column(
                                children: dishProvider
                                    .getDishesByCategory(category.id)
                                    .map((dish) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DishDialog(dish: dish);
                                          },
                                        );
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          dish.name,
                                                          style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 200,
                                                          child: Text(
                                                            dish.description,
                                                          ),
                                                        ),
                                                        dish.discountPrice !=
                                                                null
                                                            ? Row(
                                                                children: [
                                                                  Text(
                                                                    "\$${dish.unitPrice.toStringAsFixed(0)}",
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    "\$${(dish.unitPrice + (dish.discountPrice ?? 0)).toStringAsFixed(0)}",
                                                                    style: const TextStyle(
                                                                        decoration:
                                                                            TextDecoration.lineThrough),
                                                                  ),
                                                                ],
                                                              )
                                                            : Text(
                                                                "\$${dish.unitPrice.toStringAsFixed(0)}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        25),
                                                              )
                                                      ],
                                                    ),
                                                    CachedNetworkImage(
                                                      imageUrl: dish.imageUrl,
                                                      width: 150,
                                                      height: 150,
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
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton.icon(
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .cartShopping),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return DishDialog(
                                                              dish: dish);
                                                        },
                                                      );
                                                    },
                                                    label: const Text(
                                                        "AGREGAR AL CARRITO"))
                                              ],
                                            ),
                                          )),
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          )
                        ],
                      )))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
