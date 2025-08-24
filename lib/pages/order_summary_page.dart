import 'package:delivera/enum/delivery_detail_enum.dart';
import 'package:delivera/enum/input_status_enum.dart';
import 'package:delivera/model/input_status_model.dart';
import 'package:delivera/model/payment_result_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/user_box_model.dart' show UserBox;
import 'package:delivera/pages/payment_page.dart';
import 'package:delivera/provider/delivery_details_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/toast/toast.dart';
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:provider/provider.dart';

import '../constants/payment_types_constant.dart' show PaymentType, paymentTypes;

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final userBox = Hive.box(name: 'user');
  late final UserBox lastInputs;

  // Input status for address
  final InputStatus _inputStatusAddress =
      InputStatus(errorMessage: "Dirección debería tener al menos 5 caracteres", isValid: (String value) => (value.length > 4));
  final TextEditingController _textEditingControllerAddress = TextEditingController();

  // Input status for full name, email, and phone number
  final InputStatus _inputStatusFullName =
      InputStatus(errorMessage: "Nombre debería tener al menos 5 caracteres", isValid: (String value) => (value.length > 4));
  final TextEditingController _textEditingControllerFullName = TextEditingController();

  final InputStatus _inputStatusEmail = InputStatus(
      errorMessage: "Correo es inválido",
      isValid: (String value) {
        final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        return emailRegex.hasMatch(value);
      });
  final TextEditingController _textEditingControllerEmail = TextEditingController();

  final InputStatus _inputStatusPhoneNumber = InputStatus(
    errorMessage: "Número de celular inválido. Ejemplo: 987654321",
    isValid: (String value) {
      final RegExp phoneRegex = RegExp(r'^\d{9,15}$');
      return phoneRegex.hasMatch(value);
    },
  );
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();

  // Flag to indicate if the form is currently submitting
  bool _isSubmitting = false;

  String _paymentType = paymentTypes.first.string; // Default payment type

  // Decorations
  final ButtonStyle selectedOptionButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Colors.black, width: 1),
      ),
    ),
  );

  final ButtonStyle unselectedOptionButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
    ),
  );

  // TextStyles
  static const _titleStyle = TextStyle(fontWeight: FontWeight.bold);
  static const _textInvalidStyle = TextStyle(color: Colors.red);

  late DeliveryDetailsProvider _deliveryDetailsProvider;
  late OrderSummaryProvider _orderSummaryProvider;

  @override
  void initState() {
    super.initState();
    // Llama al método update() del provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deliveryDetailsProvider.update();
      // Si userBox no está vacio, inicializar los campos name, email y phone con los valores guardados
      if (userBox.isNotEmpty) {
        lastInputs = UserBox.fromBox(userBox);
        _textEditingControllerFullName.text = lastInputs.name;
        _textEditingControllerEmail.text = lastInputs.email;
        _textEditingControllerPhoneNumber.text = lastInputs.phone;
      }
    });
  }

  @override
  void dispose() {
    // Usa la referencia guardada, no el context.read directamente
    _deliveryDetailsProvider.clearDeliveryDetailEnum();
    // Limpia los controladores
    _textEditingControllerAddress.dispose();
    _textEditingControllerFullName.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _deliveryDetailsProvider = context.watch<DeliveryDetailsProvider>();
    _orderSummaryProvider = context.watch<OrderSummaryProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          title: const Text(
            "RESUMEN DE COMPRA",
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            _showTitle("Detalles de entrega"),
            const SizedBox(
              height: 5,
            ),
            ElevatedButtonTheme(
              data: const ElevatedButtonThemeData(
                style: ButtonStyle(
                  padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16.0)),
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
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            side: _deliveryDetailsProvider.deliveryDetailEnum == DeliveryDetailEnum.pickup
                                ? const BorderSide(color: Colors.black, width: 1)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                      onPressed: () {
                        _deliveryDetailsProvider.setDeliveryDetailEnum(DeliveryDetailEnum.pickup);
                        _orderSummaryProvider.setDeliveryDetailsPickUp();
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
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            side: _deliveryDetailsProvider.deliveryDetailEnum == DeliveryDetailEnum.dispatch
                                ? const BorderSide(color: Colors.black, width: 1)
                                : BorderSide.none,
                          ),
                        ),
                        backgroundColor:
                            WidgetStatePropertyAll<Color>(_deliveryDetailsProvider.dispatchEnabled == false ? Colors.grey.shade100 : Colors.white),
                        foregroundColor:
                            WidgetStatePropertyAll<Color>(_deliveryDetailsProvider.dispatchEnabled == false ? Colors.grey.shade600 : Colors.black),
                      ),
                      onPressed: () {
                        _deliveryDetailsProvider.dispatchEnabled == false
                            ? errorOrderSummary("El envío a domicilio no está disponible en este momento.")
                            : _deliveryDetailsProvider.setDeliveryDetailEnum(DeliveryDetailEnum.dispatch);
                        // Don't set the OrderSummaryProvider delivery details here
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
            switch (_deliveryDetailsProvider.deliveryDetailEnum) {
              DeliveryDetailEnum.pickup => _deliveryPickupSelected(context),
              DeliveryDetailEnum.dispatch => _deliveryDispatchSelected(context),
              _ => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Por favor, seleccione un método de entrega.",
                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
            },
            const Divider(),
            _selectPaymentMethod(),
            const Divider(),
            const Text(
              "Mis datos",
              style: _titleStyle,
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
                    borderSide: BorderSide(width: 2, color: _inputStatusFullName.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 2, color: _inputStatusFullName.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusFullName.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusFullName.errorMessage,
                    style: _textInvalidStyle,
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
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Remove spaces from input
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su correo',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 2, color: _inputStatusEmail.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 2, color: _inputStatusEmail.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusEmail.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusEmail.errorMessage,
                    style: _textInvalidStyle,
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // Remove spaces from input
                ],
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  hintText: 'Ingrese su celular. Ejemplo: 912345678',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 2, color: _inputStatusPhoneNumber.getStatusColor()),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(width: 2, color: _inputStatusPhoneNumber.getStatusColor()),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
              ),
            ),
            (_inputStatusPhoneNumber.status == InputStatusEnum.invalid)
                ? Text(
                    _inputStatusPhoneNumber.errorMessage,
                    style: _textInvalidStyle,
                  )
                : const SizedBox(),
            const Divider(),
            const Text(
              "Resumen de compra",
              style: _titleStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Subtotal"), PriceWidget(price: context.watch<ShoppingCartProvider>().subtotal)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text("Descuentos"), PriceWidget(price: context.watch<ShoppingCartProvider>().discount)],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Costo de Envío"),
                (_orderSummaryProvider.details is HomeDelivery)
                    ? PriceWidget(price: (_orderSummaryProvider.details as HomeDelivery).zone.price)
                    : const PriceWidget(price: 0)
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("TOTAL"),
                PriceWidget(
                    price: _orderSummaryProvider.details.cost +
                        context.watch<ShoppingCartProvider>().subtotal -
                        context.watch<ShoppingCartProvider>().discount)
              ],
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  onPressed: () => _handleSubmit(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Finalizar Pago",
                        style: TextStyle(fontSize: 20),
                      ),
                      _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  backgroundColor: Colors.grey,
                                ),
                              ),
                            )
                          : const Icon(FontAwesomeIcons.arrowRight)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Padding _deliveryPickupSelected(BuildContext context) {
    return Padding(
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
                    style: _titleStyle,
                  ),
                  Text(
                    context.watch<RestaurantInfoProvider>().restaurantInfo.address,
                    style: _titleStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _deliveryDispatchSelected(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Zona de envío:",
                style: _titleStyle,
              ),
              (_orderSummaryProvider.details is HomeDelivery)
                  ? TextButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.marker,
                        size: 15,
                      ),
                      onPressed: () {
                        _orderSummaryProvider.setDeliveryDetailsPickUp();
                      },
                      label: const Text(
                        "Cambiar zona",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ))
                  : const SizedBox()
            ],
          ),
          (_orderSummaryProvider.details is HomeDelivery)
              ? Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (_orderSummaryProvider.details as HomeDelivery).zone.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        PriceWidget(price: (_orderSummaryProvider.details as HomeDelivery).zone.price, fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 150,
                  child: ListView(
                    children: _deliveryDetailsProvider.deliveryZones.zones.map((zone) {
                      return ElevatedButton(
                        style: const ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                            backgroundColor: WidgetStatePropertyAll<Color>(Colors.white)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(zone.name), PriceWidget(price: zone.price)],
                        ),
                        onPressed: () {
                          _orderSummaryProvider.setDeliveryDetailsHomeDelivery(HomeDelivery(address: "", zone: zone));
                          if (userBox.isNotEmpty && lastInputs.deliveryZoneId == zone.id) {
                            _textEditingControllerAddress.text = lastInputs.deliveryAddress!;
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
          (_orderSummaryProvider.details is HomeDelivery)
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dirección de envío (*):",
                        style: _titleStyle,
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
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(width: 2, color: _inputStatusAddress.getStatusColor()),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(width: 2, color: _inputStatusAddress.getStatusColor()),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                        ),
                      ),
                      (_inputStatusAddress.status == InputStatusEnum.invalid)
                          ? Text(
                              _inputStatusAddress.errorMessage,
                              style: _textInvalidStyle,
                            )
                          : const SizedBox(),
                    ],
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Column _selectPaymentMethod() {
    ElevatedButton paymentMethodCard(PaymentType paymentType) {
      final ButtonStyle getButtonStyle = (_paymentType == paymentType.string) ? selectedOptionButtonStyle : unselectedOptionButtonStyle;

      return ElevatedButton(
        style: getButtonStyle,
        onPressed: () => setState(() {
          _paymentType = paymentType.string;
        }),
        child: Image.asset(
          height: 50,
          width: 100,
          fit: BoxFit.scaleDown,
          paymentType.imgSrc,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showTitle("Medio de pago"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: paymentTypes.map((paymentType) {
            return paymentMethodCard(paymentType);
          }).toList(),
        ),
      ],
    );
  }

  Padding _showTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: _titleStyle,
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    // Check if the form is already submitting
    if (_isSubmitting) {
      serverErrorToast("Ya se está procesando su pedido. Por favor, espere.");
      return;
    }

    // Update the shift status before proceeding
    await context.read<ShiftProvider>().updateIsOpen();
    // Check if the context is still mounted before navigating (the user might have navigated away)
    if (!context.mounted) return;

    // Verify if the shift is open
    if (!context.read<ShiftProvider>().isOpen) {
      errorOrderSummary("El turno ha cerrado. Por favor, intente más tarde.");
      return;
    }

    // Update the delivery details before proceeding
    await _deliveryDetailsProvider.update();
    if (!context.mounted) return;

    // Check if a delivery method is selected
    if (_deliveryDetailsProvider.deliveryDetailEnum == null) {
      // Handle the case where no delivery method is selected
      errorOrderSummary("Método de entrega no seleccionado.");
      return;
    }

    // Check if the delivery method 'homeDelivery' (dispatch) is selected
    if (_deliveryDetailsProvider.deliveryDetailEnum == DeliveryDetailEnum.dispatch) {
      // Check if dispatch is enabled
      if (_deliveryDetailsProvider.dispatchEnabled == false) {
        errorOrderSummary("El envío a domicilio no está disponible en este momento.");
        _deliveryDetailsProvider.clearDeliveryDetailEnum(notify: true);
        _orderSummaryProvider.clearDeliveryDetails();
        return;
      }

      // Check if the zone is selected
      if (_orderSummaryProvider.details is! HomeDelivery) {
        errorOrderSummary("Zona de envío no seleccionada.");
        return;
      }

      // Check if the address is valid
      if (_inputStatusAddress.status != InputStatusEnum.valid) {
        errorOrderSummary(_inputStatusAddress.errorMessage);
        return;
      }
    }

    // Validate all input fields
    if (_inputStatusFullName.status != InputStatusEnum.valid) {
      errorOrderSummary(_inputStatusFullName.errorMessage);
      return;
    }
    if (_inputStatusEmail.status != InputStatusEnum.valid) {
      errorOrderSummary(_inputStatusEmail.errorMessage);
      return;
    }
    if (_inputStatusPhoneNumber.status != InputStatusEnum.valid) {
      errorOrderSummary(_inputStatusPhoneNumber.errorMessage);
      return;
    }

    // if the delivery method is homeDelivery, set the delivery address
    if (_deliveryDetailsProvider.deliveryDetailEnum == DeliveryDetailEnum.dispatch) {
      _orderSummaryProvider.setDeliveryAddress(_textEditingControllerAddress.text);
    }

    // Set is submitting to true to prevent multiple submissions
    setState(() {
      _isSubmitting = true;
    });

    // Set the order summary with the user inputs
    _orderSummaryProvider.setOrderSummary(
      _textEditingControllerFullName.text,
      _textEditingControllerEmail.text,
      _textEditingControllerPhoneNumber.text,
      _paymentType,
    );

    try {
      // Post the order
      await _orderSummaryProvider.postOrder();
    } catch (e) {
      if (!context.mounted) return;
      // If an error occurs, show a toast and set is submitting to false
      serverErrorToast(e.toString());
      setState(() {
        _isSubmitting = false;
      });
      return;
    }
    if (!context.mounted) return;

    // If the order result has a payment URL, navigate to the PaymentPage
    if (_orderSummaryProvider.orderResult.paymentData != null) {
      final PaymentData paymentData = _orderSummaryProvider.orderResult.paymentData!;
      final url = paymentData.paymentUrl;
      final paymentType = paymentData.paymentType;
      final token = paymentData.token;
      final Uri uri = Uri.parse(url);
      _orderSummaryProvider.clearPaymentData();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return PaymentPage(uri: uri, paymentType: paymentType, token: token);
        },
      ));
    }
    // Set is submitting to false, allowing the user to submit again
    setState(() {
      _isSubmitting = false;
    });
  }
}
