import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceWidget extends StatelessWidget {
  final int price;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String prefix;
  final String postfix;
  final TextDecoration textDecoration;

  const PriceWidget(
      {super.key,
      required this.price,
      this.color = Colors.black,
      this.fontSize = 14,
      this.fontWeight = FontWeight.normal,
      this.prefix = "",
      this.postfix = "",
      this.textDecoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(
      "$prefix\$${NumberFormat.decimalPattern('es').format(price)}$postfix",
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration),
    );
  }
}
