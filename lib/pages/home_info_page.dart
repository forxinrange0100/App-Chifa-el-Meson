import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivera/model/cart_item_model.dart' show CartItem;
import 'package:delivera/model/dish_model.dart' show Dish;
import 'package:delivera/provider/dish_categories_provider.dart';
import 'package:delivera/provider/dishes_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/scroll_controller_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart' show ShoppingCartProvider;
import 'package:delivera/widget/dish_dialog_widget.dart';
import 'package:delivera/widget/expandable_text_widget.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:provider/provider.dart';

import '../model/order_model.dart' show Order;

class HomeInfoPage extends StatelessWidget {
  const HomeInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersBox = Hive.box<Order>(name: 'orders');
    final Order? lastOrder = ordersBox.get(ordersBox.keys.last);

    return CustomScrollView(
      controller: context.watch<ScrollControllerProvider>().scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeaderRestaurantInfo(context),
        ),
        if (lastOrder != null)
          SliverToBoxAdapter(
            child: _ShowLastOrder(lastOrder),
          ),
        SliverAppBar(
          pinned: true,
          floating: false,
          primary: false,
          expandedHeight: 50,
          collapsedHeight: 70,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
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

  Column _buildHeaderRestaurantInfo(BuildContext context) {
    // Using Consumer to listen to changes in RestaurantInfoProvider
    var restaurantInfoProvider = context.watch<RestaurantInfoProvider>();
    var imageUrl = restaurantInfoProvider.restaurantInfo.heroImage;
    var address = restaurantInfoProvider.restaurantInfo.address;
    var phone = restaurantInfoProvider.restaurantInfo.phone;
    var schedule = restaurantInfoProvider.restaurantInfo.schedule;
    var logoUrl = restaurantInfoProvider.restaurantInfo.logo;
    var name = restaurantInfoProvider.restaurantInfo.name;
    var description = restaurantInfoProvider.restaurantInfo.description;

    return Column(
      children: [
        Stack(children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
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
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    DefaultTextStyle(
                      style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      child: Column(
                        spacing: 5,
                        children: [
                          _showRowIconInfo(icon: FontAwesomeIcons.locationDot, text: address),
                          _showRowIconInfo(icon: FontAwesomeIcons.phone, text: phone),
                          _showRowIconInfo(icon: FontAwesomeIcons.solidClock, text: schedule),
                          context.watch<ShiftProvider>().isOpen
                              ? _showRowIconInfo(icon: FontAwesomeIcons.solidCircle, text: "Turno Abierto", color: Colors.green)
                              : _showRowIconInfo(icon: FontAwesomeIcons.solidCircle, text: "Turno Cerrado", color: Colors.red),
                        ],
                      ),
                    ),
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: logoUrl,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ]),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const Text(
                "Descripción:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ExpandableText(description)
            ],
          ),
        )
      ],
    );
  }

  Row _showRowIconInfo({required IconData icon, required String text, Color? color}) {
    return Row(
      spacing: 5,
      children: [
        Icon(icon, color: color ?? Colors.white),
        Expanded(
            child: Text(
          text.trim(),
          style: const TextStyle(color: Colors.white, overflow: TextOverflow.fade),
          maxLines: 2,
        )),
      ],
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
                  final context = dishCategoriesProvider.dishCategories.categories[index].categoryKey.currentContext;
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
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
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
                                padding: const EdgeInsets.symmetric(vertical: 3.0),
                                child: Center(
                                    child: Container(
                                  width: double.infinity,
                                  color: Colors.white,
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ),
                              Consumer<DishesProvider>(
                                builder: (context, dishProvider, child) {
                                  return Column(
                                    children: dishProvider.getDishesByCategory(category.id).map((dish) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            style: _cardItemStyle(),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
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
                                                              maxLines: 3,
                                                              style: const TextStyle(
                                                                  fontSize: 20, overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                                                            ),
                                                            ExpandableText(
                                                              dish.description,
                                                              maxLines: 3,
                                                              enabled: false,
                                                              style: TextStyle(color:Colors.grey),
                                                            ),
                                                            Center(
                                                                child: dish.discountedPrice != 0
                                                                    ? Row(
                                                                        children: [
                                                                          PriceWidget(
                                                                              price: dish.discountedPrice,
                                                                              color: Colors.green,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold),
                                                                          const SizedBox(
                                                                            width: 10,
                                                                          ),
                                                                          PriceWidget(
                                                                              price: dish.regularPrice, textDecoration: TextDecoration.lineThrough),
                                                                        ],
                                                                      )
                                                                    : PriceWidget(
                                                                        price: dish.regularPrice, fontWeight: FontWeight.bold, fontSize: 25)),
                                                          ],
                                                        ),
                                                      ),
                                                      CachedNetworkImage(
                                                        imageUrl: dish.imageUrl,
                                                        width: 170,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                                          return DishDialog(dish: dish);
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

  ButtonStyle _cardItemStyle() {
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

class _ShowLastOrder extends StatelessWidget {
  final Order _order;
  const _ShowLastOrder(Order order) : _order = order;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _lastOrderModal(context),
        style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
        iconAlignment: IconAlignment.end,
        icon: const Icon(Icons.open_in_new, color: Colors.white),
        label: Text('Ver último pedido', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _lastOrderModal(BuildContext context) {
    final Order order = _order;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          titlePadding: const EdgeInsets.only(top: 20),
          contentPadding: const EdgeInsets.all(10),
          actionsPadding: const EdgeInsets.all(0),
          title: Center(child: const Text('ÚLTIMA ORDEN')),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListBody(
                  children: order.orderProducts.map((orderProduct) {
                    return Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: orderProduct.product.imageUrl,
                          width: 50,
                          height: 50,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        Expanded(child: Text(orderProduct.product.name)),
                        VerticalDivider(),
                        Text('x${orderProduct.quantity}'),
                        VerticalDivider(),
                        Text(orderProduct.formattedTotalPrice),
                      ],
                    );
                  }).toList(),
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('Subtotal: ${order.formattedSubtotal}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Volver a pedir"),
              onPressed: () {
                final List<CartItem> cartItems = order.orderProducts
                    .map((orderProduct) => CartItem(dish: orderProduct.product, quantity: orderProduct.quantity, notes: ''))
                    .toList();
                context.read<ShoppingCartProvider>().cleanShoppingCart();
                context.read<ShoppingCartProvider>().addCartItems(cartItems);
                // Mostrar notificacion de que se ha añadido al carrito
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
