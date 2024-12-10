import 'package:chifa_el_meson/enum/delivery_detail_enum.dart';
import 'package:chifa_el_meson/model/order_summary_model.dart';
import 'package:chifa_el_meson/provider/delivery_details_provider.dart';
import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final TextEditingController _textEditingControllerAddress =
      TextEditingController();
  final TextEditingController _textEditingControllerFullName =
      TextEditingController();
  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final TextEditingController _textEditingControllerPhoneNumber =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          title: const Text(
            "RESUMEN DE COMPRA",
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Detalles de Entrega",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButtonTheme(
              data: const ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding:
                      WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16.0)),
                  foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                  backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            side: context
                                        .watch<DeliveryDetailsProvider>()
                                        .deliveryDetailEnum ==
                                    DeliveryDetailEnum.pickup
                                ? const BorderSide(
                                    color: Colors.black, width: 1)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<DeliveryDetailsProvider>()
                            .setDeliveryDetail(DeliveryDetailEnum.pickup);
                        context
                            .read<OrderSummaryProvider>()
                            .setDeliveryDetailsPickUp();
                      },
                      child: const Column(
                        children: [
                          Icon(FontAwesomeIcons.store),
                          Text("Retiro en tienda"),
                        ],
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                            side: context
                                        .watch<DeliveryDetailsProvider>()
                                        .deliveryDetailEnum ==
                                    DeliveryDetailEnum.homeDelivery
                                ? const BorderSide(
                                    color: Colors.black, width: 1)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                      onPressed: () {
                        context
                            .read<DeliveryDetailsProvider>()
                            .setDeliveryDetail(DeliveryDetailEnum.homeDelivery);
                      },
                      child: const Column(
                        children: [
                          Icon(FontAwesomeIcons.motorcycle),
                          Text("Envío a domicilio"),
                        ],
                      ))
                ],
              ),
            ),
            context.watch<DeliveryDetailsProvider>().deliveryDetailEnum ==
                    DeliveryDetailEnum.pickup
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(FontAwesomeIcons.mapLocationDot),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Dirección:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  context
                                      .watch<RestaurantInfoProvider>()
                                      .restaurantInfo
                                      .address,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Zona de envío:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            (context.watch<OrderSummaryProvider>().details
                                    is HomeDelivery)
                                ? TextButton.icon(
                                    icon: const Icon(
                                      FontAwesomeIcons.marker,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      context
                                          .read<OrderSummaryProvider>()
                                          .setDeliveryDetailsPickUp();
                                    },
                                    label: const Text(
                                      "Cambiar zona",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    ))
                                : const SizedBox()
                          ],
                        ),
                        (context.watch<OrderSummaryProvider>().details
                                is HomeDelivery)
                            ? Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        (context
                                                .watch<OrderSummaryProvider>()
                                                .details as HomeDelivery)
                                            .zone
                                            .name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "\$${(context.watch<OrderSummaryProvider>().details as HomeDelivery).zone.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 150,
                                child: ListView(
                                  children: context
                                      .watch<DeliveryDetailsProvider>()
                                      .deliveryZones
                                      .zones
                                      .map((zone) {
                                    return ElevatedButton(
                                        style: const ButtonStyle(
                                            foregroundColor:
                                                WidgetStatePropertyAll<Color>(
                                                    Colors.black),
                                            backgroundColor:
                                                WidgetStatePropertyAll<Color>(
                                                    Colors.white)),
                                        onPressed: () {
                                          context
                                              .read<OrderSummaryProvider>()
                                              .setDeliveryDetailsHomeDelivery(
                                                  HomeDelivery(
                                                      address: "", zone: zone));
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(zone.name),
                                            Text(
                                                "\$${zone.price.toStringAsFixed(0)}")
                                          ],
                                        ));
                                  }).toList(),
                                ),
                              ),
                        (context.watch<OrderSummaryProvider>().details
                                is HomeDelivery)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Dirección de envío:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextField(
                                      controller: _textEditingControllerAddress,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        hintText: 'Ingrese su dirección...',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
            const Divider(),
            const Text(
              "Medio de pago",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "assets/getnet.jpg",
                  height: 50,
                ),
              ),
            ),
            const Divider(),
            const Text(
              "Mis datos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text("Nombre y Apellido (*):"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _textEditingControllerFullName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            const Text("Email (*):"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _textEditingControllerEmail,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su correo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            const Text("Celular (*):"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: _textEditingControllerPhoneNumber,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su celular',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            const Divider(),
            const Text(
              "Resumen de compra",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text(
                    "\$${context.watch<ShoppingCartProvider>().subTotal.toStringAsFixed(0)}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Descuentos"),
                Text(
                    "-\$${context.watch<ShoppingCartProvider>().shoppingCart.shoppingCartDiscount.toStringAsFixed(0)}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Costo de Envío"),
                (context.watch<OrderSummaryProvider>().details is HomeDelivery)
                    ? Text(
                        "\$${(context.watch<OrderSummaryProvider>().details as HomeDelivery).zone.price.toStringAsFixed(0)}")
                    : const Text("\$0")
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL"),
                (context.watch<OrderSummaryProvider>().details is HomeDelivery)
                    ? Text(
                        "\$${(context.watch<ShoppingCartProvider>().shoppingCart.shoppingCartPrice + (context.watch<OrderSummaryProvider>().details as HomeDelivery).zone.price).toStringAsFixed(0)}")
                    : Text(
                        "\$${(context.watch<ShoppingCartProvider>().shoppingCart.shoppingCartPrice).toStringAsFixed(0)}")
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    context.read<OrderSummaryProvider>().setOrderSummary(
                        _textEditingControllerFullName.text,
                        _textEditingControllerEmail.text,
                        _textEditingControllerPhoneNumber.text);
                    if (context
                        .read<OrderSummaryProvider>()
                        .urlPayment
                        .isNotEmpty) {
                      final url =
                          context.read<OrderSummaryProvider>().urlPayment;
                      final Uri uri = Uri.parse(url);

                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {}
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Finalizar Pago",
                        style: TextStyle(fontSize: 20),
                      ),
                      Icon(FontAwesomeIcons.arrowRight)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
