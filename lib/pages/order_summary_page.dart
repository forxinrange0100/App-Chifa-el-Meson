import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/enum/input_status_enum.dart';
import 'package:delivera/enum/payment_type_enum.dart' show PaymentTypeEnum, paymentTypesList;
import 'package:delivera/model/input_status_model.dart';
import 'package:delivera/model/order_summary_model.dart';
import 'package:delivera/model/user_box_model.dart' show UserBox;
import 'package:delivera/pages/home_page.dart' show HomePage;
import 'package:delivera/provider/bottom_navigation_bar_provider.dart' show BottomNavigationBarProvider;
import 'package:delivera/provider/delivery_details_provider.dart';
import 'package:delivera/provider/order_summary_provider.dart';
import 'package:delivera/provider/restaurant_info_provider.dart';
import 'package:delivera/provider/shift_provider.dart';
import 'package:delivera/provider/shopping_cart_provider.dart';
import 'package:delivera/toast/toast.dart';
import 'package:delivera/utils/navigation.dart' show navigatePayment;
import 'package:delivera/widget/price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  final UserBox? _lastInputs = UserBox.fromStorage();
  late final bool _hasLastInputs;

  // Focus nodes for form navigation
  late final FocusNode _focusNodeAddress;
  late final FocusNode _focusNodeFullName;
  late final FocusNode _focusNodeEmail;
  late final FocusNode _focusNodePhone;

  // Cached provider references (initialized in initState)
  late final DeliveryDetailsProvider _deliveryDetailsProvider;
  late final OrderSummaryProvider _orderSummaryProvider;
  late final ShiftProvider _shiftProvider;

  // Input status for address
  final InputStatus _inputStatusAddress = InputStatus(
    errorMessage: "Dirección debería tener al menos 5 caracteres",
    isValid: (String value) => (value.length > 4),
  );
  final TextEditingController _textEditingControllerAddress = TextEditingController();

  // Input status for full name, email, and phone number
  final InputStatus _inputStatusFullName = InputStatus(
    errorMessage: "Nombre debería tener al menos 5 caracteres",
    isValid: (String value) => (value.length > 4),
  );
  final TextEditingController _textEditingControllerFullName = TextEditingController();

  final InputStatus _inputStatusEmail = InputStatus(
    errorMessage: "Correo es inválido",
    isValid: (String value) {
      final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      return emailRegex.hasMatch(value);
    },
  );
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

  // Tipo de pago seleccionado, por defecto es 'transbank'
  PaymentTypeEnum _paymentType = PaymentTypeEnum.transbank;

  // TextStyles
  static const _titleStyle = TextStyle(fontWeight: FontWeight.bold);
  static const _textInvalidStyle = TextStyle(color: Colors.red);

  static final ButtonStyle selectedOptionButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Colors.black, width: 1.5),
      ),
    ),
  );

  static final ButtonStyle unselectedOptionButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Colors.grey, width: 1),
      ),
    ),
  );

  static final InputBorder _defaultInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    borderSide: BorderSide(width: 2, color: Colors.grey),
  );

  // Default input decoration
  static final InputDecoration _defaultInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade200,
    enabledBorder: _defaultInputBorder,
    focusedBorder: _defaultInputBorder,
    contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
  );

  @override
  void initState() {
    super.initState();
    // Cache provider references (safe to do in initState before context is deactivated)
    _deliveryDetailsProvider = context.read<DeliveryDetailsProvider>();
    _orderSummaryProvider = context.read<OrderSummaryProvider>();
    _shiftProvider = context.read<ShiftProvider>();

    // Initialize focus nodes
    _focusNodeAddress = FocusNode();
    _focusNodeFullName = FocusNode();
    _focusNodeEmail = FocusNode();
    _focusNodePhone = FocusNode();

    // Llama al método update() del provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _orderSummaryProvider.clearDeliveryDetails();
      _deliveryDetailsProvider.update();
      // Si _lastInputs no está vacio, inicializar los campos name, email y phone con los valores guardados
      _hasLastInputs = _lastInputs != null;
      if (_hasLastInputs) {
        _textEditingControllerFullName.text = _lastInputs!.name;
        _textEditingControllerEmail.text = _lastInputs.email;
        _textEditingControllerPhoneNumber.text = _lastInputs.phone;
        // Verificar validez de los inputs
        _inputStatusFullName.verify(_textEditingControllerFullName.text);
        _inputStatusEmail.verify(_textEditingControllerEmail.text);
        _inputStatusPhoneNumber.verify(_textEditingControllerPhoneNumber.text);
      }
    });
  }

  @override
  void dispose() {
    // Use cached provider for cleanup, NOT context.read()
    _deliveryDetailsProvider.clearDeliveryTypeEnum();
    // Limpia los controladores y focus nodes
    _textEditingControllerAddress.dispose();
    _textEditingControllerFullName.dispose();
    _textEditingControllerEmail.dispose();
    _textEditingControllerPhoneNumber.dispose();
    _focusNodeAddress.dispose();
    _focusNodeFullName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deliveryType = context.select((DeliveryDetailsProvider p) => p.deliveryTypeEnum);
    final deliveryDetails = context.select((OrderSummaryProvider p) => p.deliveryDetails);
    final subtotal = context.select((ShoppingCartProvider p) => p.subtotal);
    final discounts = context.select((ShoppingCartProvider p) => p.discounts);
    final cartTotal = context.select((ShoppingCartProvider p) => p.total);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 2,
        leading: const _AppBarBackButton(),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        title: const Text("RESUMEN DE COMPRA"),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _navigateBack(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ListView(
            children: [
              _showTitle("Detalles de entrega"),
              const SizedBox(height: 5),
              const _DeliveryMethodSelector(),
              switch (deliveryType) {
                DeliveryTypeEnum.pickup => const _DeliveryPickupSection(),
                DeliveryTypeEnum.dispatch => _DeliveryDispatchSection(
                  focusNodeAddress: _focusNodeAddress,
                  focusNodeFullName: _focusNodeFullName,
                  textEditingControllerAddress: _textEditingControllerAddress,
                  inputStatusAddress: _inputStatusAddress,
                ),
                _ => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Por favor, seleccione un método de entrega.",
                    style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              },
              (deliveryType == DeliveryTypeEnum.dispatch && deliveryDetails is Dispatch)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Dirección de envío (*):", style: _titleStyle),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              focusNode: _focusNodeAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                if (_inputStatusAddress.status == InputStatusEnum.valid) {
                                  FocusScope.of(context).requestFocus(_focusNodeFullName);
                                }
                              },
                              controller: _textEditingControllerAddress,
                              onChanged: (value) {
                                setState(() {
                                  _inputStatusAddress.verify(value);
                                });
                              },
                              decoration: _buildInputDecoration(
                                hintText: 'Ingrese su dirección...',
                                borderColor: _inputStatusAddress.getStatusColor(),
                              ),
                            ),
                          ),
                          (_inputStatusAddress.status == InputStatusEnum.invalid)
                              ? Text(_inputStatusAddress.errorMessage, style: _textInvalidStyle)
                              : const SizedBox(),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const Divider(),
              _selectPaymentMethod(),
              const Divider(),
              const Text("Mis datos", style: _titleStyle),
              const Text("Nombre y Apellido (*):"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  focusNode: _focusNodeFullName,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    if (_inputStatusFullName.status == InputStatusEnum.valid) {
                      FocusScope.of(context).requestFocus(_focusNodeEmail);
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _inputStatusFullName.verify(value);
                    });
                  },
                  controller: _textEditingControllerFullName,
                  decoration: _buildInputDecoration(hintText: 'Ingrese su nombre', borderColor: _inputStatusFullName.getStatusColor()),
                ),
              ),
              (_inputStatusFullName.status == InputStatusEnum.invalid)
                  ? Text(_inputStatusFullName.errorMessage, style: _textInvalidStyle)
                  : const SizedBox(),
              const Text("Email (*):"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  focusNode: _focusNodeEmail,
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    if (_inputStatusEmail.status == InputStatusEnum.valid) {
                      FocusScope.of(context).requestFocus(_focusNodePhone);
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      _inputStatusEmail.verify(value);
                    });
                  },
                  controller: _textEditingControllerEmail,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')), // Remove spaces from input
                  ],
                  decoration: _buildInputDecoration(hintText: 'Ingrese su correo', borderColor: _inputStatusEmail.getStatusColor()),
                ),
              ),
              (_inputStatusEmail.status == InputStatusEnum.invalid)
                  ? Text(_inputStatusEmail.errorMessage, style: _textInvalidStyle)
                  : const SizedBox(),
              const Text("Celular (*):"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  focusNode: _focusNodePhone,
                  textInputAction: TextInputAction.done,
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
                  decoration: _buildInputDecoration(
                    hintText: 'Ingrese su celular. Ejemplo: 912345678',
                    borderColor: _inputStatusPhoneNumber.getStatusColor(),
                  ),
                ),
              ),
              (_inputStatusPhoneNumber.status == InputStatusEnum.invalid)
                  ? Text(_inputStatusPhoneNumber.errorMessage, style: _textInvalidStyle)
                  : const SizedBox(),
              const Divider(),
              const Text("Resumen de compra", style: _titleStyle),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Subtotal"),
                  PriceWidget(price: subtotal),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Descuentos"),
                  PriceWidget(price: discounts),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Costo de Envío"),
                  (deliveryDetails is Dispatch) ? PriceWidget(price: deliveryDetails.zone.price) : const PriceWidget(price: 0),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("TOTAL"),
                  PriceWidget(price: deliveryDetails.cost + cartTotal),
                ],
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () => _handleSubmit(context),
                  iconAlignment: IconAlignment.end,
                  icon: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white, constraints: BoxConstraints.tightFor(width: 24, height: 24))
                      : const Icon(FontAwesomeIcons.arrowRight),
                  label: const SizedBox(
                    width: double.infinity,
                    child: Text("Finalizar Pago", style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _showTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: _titleStyle),
    );
  }

  InputDecoration _buildInputDecoration({required String hintText, required Color borderColor}) {
    final inputBorder = _defaultInputBorder.copyWith(borderSide: _defaultInputBorder.borderSide.copyWith(color: borderColor));

    return _defaultInputDecoration.copyWith(hintText: hintText, enabledBorder: inputBorder, focusedBorder: inputBorder);
  }

  Column _selectPaymentMethod() {
    ButtonStyle getButtonStyle(PaymentTypeEnum paymentType) {
      if (_paymentType == paymentType) return _OrderSummaryPageState.selectedOptionButtonStyle;
      return _OrderSummaryPageState.unselectedOptionButtonStyle;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showTitle("Medio de pago"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: paymentTypesList.map((paymentType) {
            return ElevatedButton(
              style: getButtonStyle(paymentType),
              onPressed: () => setState(() => _paymentType = paymentType),
              child: Image.asset(paymentType.imgSrc, height: 50, width: 100, fit: BoxFit.scaleDown),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (_isSubmitting) {
      occupiedToast("Ya se está procesando su pedido. Por favor, espere.");
      return;
    }

    setState(() => _isSubmitting = true);

    () async {
      bool success = await _shiftProvider.updateIsOpen();

      if (!context.mounted) return;
      if (!success) return;

      if (!_shiftProvider.isOpen) {
        formErrorToast("El turno ha cerrado. Por favor, intente más tarde.");
        return;
      }

      if (_deliveryDetailsProvider.deliveryTypeEnum == null) {
        formErrorToast("Método de entrega no seleccionado.");
        return;
      }

      try {
        await _deliveryDetailsProvider.update();
      } catch (e) {
        if (!context.mounted) return;
        serverErrorToast("Error al verificar los detalles de entrega. Por favor, intente más tarde.");
        return;
      }
      if (!context.mounted) return;

      if (_deliveryDetailsProvider.deliveryTypeEnum == DeliveryTypeEnum.dispatch) {
        if (_deliveryDetailsProvider.dispatchEnabled == false) {
          formErrorToast("El envío a domicilio no está disponible en este momento.");
          _deliveryDetailsProvider.clearDeliveryTypeEnum(notify: true);
          _orderSummaryProvider.clearDeliveryDetails();
          return;
        }

        if (_orderSummaryProvider.deliveryDetails is! Dispatch) {
          formErrorToast("Zona de envío no seleccionada.");
          return;
        }

        if (_inputStatusAddress.status != InputStatusEnum.valid) {
          formErrorToast(_inputStatusAddress.errorMessage);
          return;
        }
      }

      if (_inputStatusFullName.status != InputStatusEnum.valid) {
        formErrorToast(_inputStatusFullName.errorMessage);
        return;
      }
      if (_inputStatusEmail.status != InputStatusEnum.valid) {
        formErrorToast(_inputStatusEmail.errorMessage);
        return;
      }
      if (_inputStatusPhoneNumber.status != InputStatusEnum.valid) {
        formErrorToast(_inputStatusPhoneNumber.errorMessage);
        return;
      }

      if (_deliveryDetailsProvider.deliveryTypeEnum == DeliveryTypeEnum.dispatch) {
        _orderSummaryProvider.setDeliveryAddress(_textEditingControllerAddress.text);
      }

      _orderSummaryProvider.setOrderSummary(
        _textEditingControllerFullName.text,
        _textEditingControllerEmail.text,
        _textEditingControllerPhoneNumber.text,
        _paymentType,
      );

      _orderSummaryProvider.orderSummary.store();

      success = await _orderSummaryProvider.postOrder();

      if (!context.mounted) return;
      if (!success) return;

      navigatePayment(Navigator.of(context));
    }().whenComplete(() {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    });
  }
}

// ============ Optimized Widget Components ============

class _AppBarBackButton extends StatelessWidget {
  const _AppBarBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _navigateBack(context),
      icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.black),
    );
  }
}

class _DeliveryMethodSelector extends StatelessWidget {
  const _DeliveryMethodSelector();

  @override
  Widget build(BuildContext context) {
    final deliveryType = context.select((DeliveryDetailsProvider p) => p.deliveryTypeEnum);
    final dispatchEnabled = context.select((DeliveryDetailsProvider p) => p.dispatchEnabled);

    return ElevatedButtonTheme(
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
                  side: deliveryType == DeliveryTypeEnum.pickup ? const BorderSide(color: Colors.black, width: 1.5) : BorderSide.none,
                ),
              ),
            ),
            onPressed: () {
              context.read<DeliveryDetailsProvider>().setDeliveryTypeEnum(DeliveryTypeEnum.pickup);
              context.read<OrderSummaryProvider>().setDeliveryDetailsPickUp();
            },
            child: const Column(children: [Icon(FontAwesomeIcons.store), Text("Retiro en tienda")]),
          ),
          ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  side: deliveryType == DeliveryTypeEnum.dispatch ? const BorderSide(color: Colors.black, width: 1.5) : BorderSide.none,
                ),
              ),
              backgroundColor: WidgetStatePropertyAll<Color>(dispatchEnabled == false ? Colors.grey.shade100 : Colors.white),
              foregroundColor: WidgetStatePropertyAll<Color>(dispatchEnabled == false ? Colors.grey.shade600 : Colors.black),
            ),
            onPressed: () {
              dispatchEnabled == false
                  ? formErrorToast("El envío a domicilio no está disponible en este momento.")
                  : context.read<DeliveryDetailsProvider>().setDeliveryTypeEnum(DeliveryTypeEnum.dispatch);
            },
            child: const Column(children: [Icon(FontAwesomeIcons.motorcycle), Text("Envío a domicilio")]),
          ),
        ],
      ),
    );
  }
}

class _DeliveryPickupSection extends StatelessWidget {
  const _DeliveryPickupSection();

  @override
  Widget build(BuildContext context) {
    final address = context.select((RestaurantInfoProvider p) => p.restaurantInfo.address);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const Icon(FontAwesomeIcons.mapLocationDot),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Dirección:", style: _OrderSummaryPageState._titleStyle),
                  Text(address, style: _OrderSummaryPageState._titleStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryDispatchSection extends StatelessWidget {
  final FocusNode focusNodeAddress;
  final FocusNode focusNodeFullName;
  final TextEditingController textEditingControllerAddress;
  final InputStatus inputStatusAddress;

  const _DeliveryDispatchSection({
    required this.focusNodeAddress,
    required this.focusNodeFullName,
    required this.textEditingControllerAddress,
    required this.inputStatusAddress,
  });

  @override
  Widget build(BuildContext context) {
    final deliveryDetails = context.select((OrderSummaryProvider p) => p.deliveryDetails);
    final deliveryZones = context.select((DeliveryDetailsProvider p) => p.deliveryZones);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Zona de envío:", style: _OrderSummaryPageState._titleStyle),
              (deliveryDetails is Dispatch)
                  ? TextButton.icon(
                      icon: const Icon(FontAwesomeIcons.marker, size: 15),
                      onPressed: () {
                        context.read<OrderSummaryProvider>().setDeliveryDetailsPickUp();
                      },
                      label: const Text("Cambiar zona", style: TextStyle(decoration: TextDecoration.underline)),
                    )
                  : const SizedBox(),
            ],
          ),
          (deliveryDetails is Dispatch)
              ? Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(deliveryDetails.zone.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                        PriceWidget(price: deliveryDetails.zone.price, fontWeight: FontWeight.w500),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 150,
                  child: ListView(
                    children: deliveryZones.map((zone) {
                      return ElevatedButton(
                        style: const ButtonStyle(
                          foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
                          backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(zone.name),
                            PriceWidget(price: zone.price),
                          ],
                        ),
                        onPressed: () {
                          context.read<OrderSummaryProvider>().setDeliveryDetailsDispatch(Dispatch(zone: zone));
                        },
                      );
                    }).toList(),
                  ),
                ),
          (deliveryDetails is Dispatch)
              ? Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [const Text("Dirección de envío (*):", style: _OrderSummaryPageState._titleStyle)],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

void _navigateBack(BuildContext context) {
  context.read<BottomNavigationBarProvider>().showShoppingCar();
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
}
