import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderSummaryPage extends StatelessWidget {
  const OrderSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          title: const Text(
            "RESUMEN DE COMPRA",
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
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
                      onPressed: () {},
                      child: const Column(
                        children: [
                          Icon(FontAwesomeIcons.store),
                          Text("Retiro en tienda"),
                        ],
                      )),
                  ElevatedButton(
                      onPressed: () {},
                      child: const Column(
                        children: [
                          Icon(FontAwesomeIcons.motorcycle),
                          Text("Envío a domicilio"),
                        ],
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey.shade200,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(FontAwesomeIcons.mapLocationDot),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            "Dirección:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
                child: SvgPicture.network(
                  "https://meson.simsis.cl/img/Logo_WebCheckout_Getnet.svg",
                  height: 50,
                ),
              ),
            ),
            const Divider(),
            const Text(
              "Mis datos",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
