import 'package:chifa_el_meson/enum/delivery_detail_enum.dart';
import 'package:chifa_el_meson/enum/input_status_enum.dart';
import 'package:chifa_el_meson/model/input_status_model.dart';
import 'package:chifa_el_meson/model/order_summary_model.dart';
import 'package:chifa_el_meson/pages/payment_page.dart';
import 'package:chifa_el_meson/provider/delivery_details_provider.dart';
import 'package:chifa_el_meson/provider/order_summary_provider.dart';
import 'package:chifa_el_meson/provider/restaurant_info_provider.dart';
import 'package:chifa_el_meson/provider/shopping_cart_provider.dart';
import 'package:chifa_el_meson/toast/toast.dart';
import 'package:chifa_el_meson/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final InputStatus _inputStatusAddress = InputStatus(
      errorMessage: "Dirección debería tener al menos 5 caracteres",
      isValid: (String value) => (value.length > 4));
  final TextEditingController _textEditingControllerAddress =
      TextEditingController();
  final InputStatus _inputStatusFullName = InputStatus(
      errorMessage: "Nombre debería tener al menos 5 caracteres",
      isValid: (String value) => (value.length > 4));
  final TextEditingController _textEditingControllerFullName =
      TextEditingController();
  final InputStatus _inputStatusEmail = InputStatus(
      errorMessage: "Correo es inválido",
      isValid: (String value) {
        final RegExp emailRegex =
            RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        return emailRegex.hasMatch(value);
      });

  final TextEditingController _textEditingControllerEmail =
      TextEditingController();
  final InputStatus _inputStatusPhoneNumber = InputStatus(
    errorMessage: "Número de celular inválido. Ejemplo: 987654321",
    isValid: (String value) {
      final RegExp phoneRegex = RegExp(r'^\d{9,15}$');
      return phoneRegex.hasMatch(value);
    },
  );
  final TextEditingController _textEditingControllerPhoneNumber =
      TextEditingController();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
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
                                      PriceWidget(
                                          price: (context
                                                  .watch<OrderSummaryProvider>()
                                                  .details as HomeDelivery)
                                              .zone
                                              .price,
                                          fontWeight: FontWeight.w500),
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
                                            PriceWidget(price: zone.price)
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
                                    TextFormField(
                                      controller: _textEditingControllerAddress,
                                      onChanged: (value) {
                                        setState(() {
                                          _inputStatusAddress.verify(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey.shade200,
                                        hintText: 'Ingrese su dirección...',
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: _inputStatusAddress
                                                  .getStatusColor()),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              width: 2,
                                              color: _inputStatusAddress
                                                  .getStatusColor()),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0),
                                      ),
                                    ),
                                    (_inputStatusAddress.status ==
                                            InputStatusEnum.invalid)
                                        ? Text(
                                            _inputStatusAddress.errorMessage,
                                            style: const TextStyle(
                                                color: Colors.red),
                                          )
                                        : const SizedBox(),
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
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _inputStatusFullName.verify(value);
                  });
                },
                controller: _textEditingControllerFullName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su nombre',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2, color: _inputStatusFullName.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2, color: _inputStatusFullName.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusFullName.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusFullName.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
            const Text("Email (*):"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _inputStatusEmail.verify(value);
                  });
                },
                controller: _textEditingControllerEmail,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su correo',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2, color: _inputStatusEmail.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2, color: _inputStatusEmail.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusEmail.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusEmail.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
            const Text("Celular (*):"),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _inputStatusPhoneNumber.verify(value);
                  });
                },
                controller: _textEditingControllerPhoneNumber,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su celular. Ejemplo: 987654321',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2,
                        color: _inputStatusPhoneNumber.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                        width: 2,
                        color: _inputStatusPhoneNumber.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusPhoneNumber.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusPhoneNumber.errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
            const Divider(),
            const Text(
              "Resumen de compra",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                PriceWidget(
                    price: context.watch<ShoppingCartProvider>().subtotal)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Descuentos"),
                PriceWidget(
                    price: context.watch<ShoppingCartProvider>().discount)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Costo de Envío"),
                (context.watch<OrderSummaryProvider>().details is HomeDelivery)
                    ? PriceWidget(
                        price: (context.watch<OrderSummaryProvider>().details
                                as HomeDelivery)
                            .zone
                            .price)
                    : const PriceWidget(price: 0)
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL"),
                PriceWidget(
                    price: context.watch<OrderSummaryProvider>().details.cost +
                        context.watch<ShoppingCartProvider>().subtotal)
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: () async {
                    if (_isSubmitting) return;
                    if (_inputStatusFullName.status != InputStatusEnum.valid) {
                      errorOrderSummary(_inputStatusFullName.errorMessage);
                      return;
                    }
                    if (_inputStatusEmail.status != InputStatusEnum.valid) {
                      errorOrderSummary(_inputStatusEmail.errorMessage);
                      return;
                    }
                    if (_inputStatusPhoneNumber.status !=
                        InputStatusEnum.valid) {
                      errorOrderSummary(_inputStatusPhoneNumber.errorMessage);
                      return;
                    }
                    if (context.read<OrderSummaryProvider>().details
                        is HomeDelivery) {
                      if (_inputStatusAddress.status != InputStatusEnum.valid) {
                        errorOrderSummary(_inputStatusAddress.errorMessage);
                        return;
                      }
                      context.read<OrderSummaryProvider>().setDeliveryAddress(
                          _textEditingControllerAddress.text);
                    }
                    setState(() {
                      _isSubmitting = true;
                    });
                    await context.read<OrderSummaryProvider>().setOrderSummary(
                        _textEditingControllerFullName.text,
                        _textEditingControllerEmail.text,
                        _textEditingControllerPhoneNumber.text);
                    if (!context.mounted) return;
                    if (context
                        .read<OrderSummaryProvider>()
                        .orderResult
                        .urlPayment
                        .isNotEmpty) {
                      final url = context
                          .read<OrderSummaryProvider>()
                          .orderResult
                          .urlPayment;
                      final Uri uri = Uri.parse(url);
                      context.read<OrderSummaryProvider>().clearUrlPayment();
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PaymentPage(uri: uri);
                        },
                      ));
                    }
                    setState(() {
                      _isSubmitting = false;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Finalizar Pago",
                        style: TextStyle(fontSize: 20),
                      ),
                      _isSubmitting
                          ? const CircularProgressIndicator()
                          : const Icon(FontAwesomeIcons.arrowRight)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
