import 'dart:developer' show log;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/cart_item_model.dart' show CartItem;
import 'package:delivera/model/dish_model.dart' show Dish;
import 'package:delivera/model/payment_result_model.dart' show PaymentResult;
import 'package:delivera/provider/dish_categories_provider.dart';
import 'package:delivera/provider/dishes_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart' show OrderSummaryProvider;
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/scroll_controller_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart' show ShoppingCartProvider;
import 'package:delivera/toast/toast.dart' show addingCartItemsToast;
import 'package:delivera/utils/navigation.dart' show navigatePayment;
import 'package:delivera/widget/dish_dialog_widget.dart';
import 'package:delivera/widget/expandable_text_widget.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../model/order_model.dart' show Order;

class HomeInfoPage extends StatelessWidget {
  const HomeInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Order? lastOrder = Order.getLastOrder();

    return Scaffold(
      body: CustomScrollView(
        controller: context.watch<ScrollControllerProvider>().scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: HeaderWidget(),
          ),
          if (lastOrder != null)
            SliverToBoxAdapter(
              child: _LastOrderWidget(lastOrder),
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
              title: CategoriesScrollerWidget(),
              titlePadding: EdgeInsets.zero,
            ),
          ),
          StoreProductsWidget(),
        ],
      ),
      floatingActionButton: _ContinuePayment(),
    );
  }
}

class _ContinuePayment extends StatefulWidget {
  const _ContinuePayment({
    super.key,
  });

  @override
  State<_ContinuePayment> createState() => _ContinuePaymentState();
}

class _ContinuePaymentState extends State<_ContinuePayment> {
  PaymentResult? _orderResult;
  bool _hasOrderResult = false;
  bool _modalShowing = false;

  // context.read<InvoiceProvider>().publicId = _orderResult.publicId;
  // context.read<OrderSummaryProvider>().setOrderResult(_orderResult);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orderResult = PaymentResult.fromStorage();
      _hasOrderResult = _orderResult != null;

      log('Has pending payment: $_hasOrderResult');
      if (!_hasOrderResult) return;
      log(
        'Url: ${_orderResult!.paymentData.paymentUrl}\n'
        'Token: ${_orderResult!.paymentData.token}\n'
        'Type: ${_orderResult!.paymentData.paymentType}',
      );
      _continuePaymentModal();
    });
  }

  Future<void> _continuePaymentModal() {
    setState(() => _modalShowing = true);

    final buttonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(12),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pago pendiente'),
          content: const Text('Tiene un pago sin terminar.\n¿Desea continuar con el pago?'),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: buttonStyle,
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<OrderSummaryProvider>().setOrderResult(_orderResult!);
                navigatePayment(Navigator.of(context));
              },
              // style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.amber)),
              style: buttonStyle.copyWith(backgroundColor: WidgetStatePropertyAll(Colors.amber)),
              child: const Text('Continuar pago', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    ).then((_) {
      setState(() => _modalShowing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasOrderResult || _modalShowing) return SizedBox();

    return FloatingActionButton(
      onPressed: () => _continuePaymentModal(),
      tooltip: 'Continuar pago',
      mini: true,
      splashColor: Colors.white70,
      backgroundColor: Colors.amber.withValues(alpha: .9),
      child: Icon(Icons.attach_money, size: 24),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Using Consumer to listen to changes in RestaurantInfoProvider
    var restaurantInfoProvider = context.watch<RestaurantInfoProvider>();
    var imageUrl = restaurantInfoProvider.restaurantInfo.heroImage;
    var address = restaurantInfoProvider.restaurantInfo.address;
    var phone = restaurantInfoProvider.restaurantInfo.phone;
    var schedule = restaurantInfoProvider.restaurantInfo.schedule;
    var logoUrl = restaurantInfoProvider.restaurantInfo.logo;
    var name = restaurantInfoProvider.restaurantInfo.name;
    var description = restaurantInfoProvider.restaurantInfo.description;

    Row buildIconInfo({required IconData icon, required String text, Color? color}) {
      return Row(
        spacing: 5,
        children: [
          Icon(icon, color: color ?? Colors.white),
          Expanded(
            child: Text(
              text.trim(),
              style: const TextStyle(color: Colors.white, overflow: TextOverflow.fade),
              maxLines: 2,
            ),
          ),
        ],
      );
    }

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
                          buildIconInfo(icon: FontAwesomeIcons.locationDot, text: address),
                          buildIconInfo(icon: FontAwesomeIcons.phone, text: phone),
                          buildIconInfo(icon: FontAwesomeIcons.solidClock, text: schedule),
                          context.watch<ShiftProvider>().isOpen
                              ? buildIconInfo(icon: FontAwesomeIcons.solidCircle, text: "Turno Abierto", color: Colors.green)
                              : buildIconInfo(icon: FontAwesomeIcons.solidCircle, text: "Turno Cerrado", color: Colors.red),
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
}

class _LastOrderWidget extends StatelessWidget {
  final Order _order;
  const _LastOrderWidget(Order order) : _order = order;

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
    final List<Dish> newProducts = context.read<DishesProvider>().dishes.dishes.toList();
    _order.updateProducts(newProducts, clearNotes: true);
    _order.updateTotals();
    final textButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.all(8),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: Size(0, 0),
      maximumSize: Size(double.infinity, 32),
    );

    return showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxHeight = constraints.maxHeight * 0.7;
                final itemCount = _order.enabledProducts.length;

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text('Última orden', style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: itemCount,
                          separatorBuilder: (_, __) => Divider(height: 5),
                          itemBuilder: (context, index) {
                            final orderProduct = _order.enabledProducts[index];
                            return Row(
                              spacing: 8,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: orderProduct.product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  placeholder: (_, __) => CircularProgressIndicator(),
                                  errorWidget: (_, __, ___) => Icon(Icons.error),
                                ),
                                Expanded(
                                  child: ExpandableText(
                                    orderProduct.product.name,
                                    enabled: false,
                                    maxLines: 3,
                                  ),
                                ),
                                Text('x${orderProduct.quantity}'),
                                Text(orderProduct.formattedTotalPrice),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      const Divider(color: Colors.black, height: 0),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8.0),
                          child: Text(
                            'Subtotal: ${_order.formattedSubtotal}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: textButtonStyle,
                            child: Text(
                              'Cerrar',
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final cartItems = _order.enabledProducts
                                  .map((op) => CartItem(
                                        dish: op.product,
                                        quantity: op.quantity,
                                        notes: '',
                                      ))
                                  .toList();
                              context.read<ShoppingCartProvider>().cleanShoppingCart();
                              context.read<ShoppingCartProvider>().addCartItems(cartItems);
                              addingCartItemsToast();
                              Navigator.pop(context);
                            },
                            style: textButtonStyle,
                            child: Text('Volver a pedir'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CategoriesScrollerWidget extends StatelessWidget {
  const CategoriesScrollerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DishCategoriesProvider>(
      builder: (context, dishCategoriesProvider, child) {
        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dishCategoriesProvider.dishCategories.categories.length,
            itemBuilder: (context, index) {
              final category = dishCategoriesProvider.dishCategories.categories[index];

              return TextButton(
                onPressed: () {
                  final context = category.categoryKey.currentContext;
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
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class StoreProductsWidget extends StatelessWidget {
  const StoreProductsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Consumer<DishCategoriesProvider>(
            builder: (context, dishCategoriesProvider, child) {
              return Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: dishCategoriesProvider.dishCategories.categories.map((category) {
                    return Column(
                      key: category.categoryKey,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(vertical: 16),
                          color: Colors.white,
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                        CategoryProductsWidget(categoryId: category.id)
                      ],
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryProductsWidget extends StatelessWidget {
  final int categoryId;

  const CategoryProductsWidget({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DishesProvider>(
      builder: (context, dishProvider, child) {
        return Column(
          spacing: 16,
          children: dishProvider.getDishesByCategory(categoryId).map((dish) {
            return ProductCardWidget(dish: dish);
          }).toList(),
        );
      },
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final Dish dish;

  const ProductCardWidget({
    super.key,
    required this.dish,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DishDialog(dish: dish);
          },
        );
      },
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.white),
        foregroundColor: WidgetStatePropertyAll(Colors.black),
        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        )),
      ),
      child: Column(
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
                          fontSize: 20,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ExpandableText(
                        dish.description,
                        maxLines: 3,
                        enabled: false,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Center(
                        child: (dish.discountedPrice == 0)
                            ? PriceWidget(
                                price: dish.regularPrice,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              )
                            : Row(
                                children: [
                                  PriceWidget(
                                    price: dish.discountedPrice,
                                    color: Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(width: 10),
                                  PriceWidget(
                                    price: dish.regularPrice,
                                    textDecoration: TextDecoration.lineThrough,
                                  ),
                                ],
                              ),
                      ),
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
          const SizedBox(height: 10),
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
              spacing: 10,
              children: [
                Icon(FontAwesomeIcons.cartShopping),
                Text("AGREGAR AL CARRITO"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
