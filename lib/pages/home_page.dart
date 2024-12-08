import 'package:cached_network_image/cached_network_image.dart';
import 'package:chifa_el_meson/provider/dish_categories_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/widget/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeaderRestaurantInfo(context),
          ),
          SliverAppBar(
            pinned: true,
            floating: false,
            toolbarHeight: 90,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: _buildCategories(context),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([_buildDishes(context)]))
        ],
      ),
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
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            itemCount: dishCategoriesProvider.dishCategories.categories.length,
            itemBuilder: (context, index) {
              return TextButton(
                onPressed: () {},
                child: Text(
                  dishCategoriesProvider.dishCategories.categories[index].name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDishes(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 400,
            color: Colors.blue,
            child: const Center(child: Text("Sección 1")),
          ),
          Container(
            height: 400,
            color: Colors.green,
            child: const Center(child: Text("Sección 2")),
          ),
          Container(
            height: 400,
            color: Colors.red,
            child: const Center(child: Text("Sección 3")),
          ),
        ],
      ),
    );
  }
}
