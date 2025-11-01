// ignore_for_file: constant_identifier_names

import 'package:delivera/enum/delivery_type_enum.dart' show DeliveryTypeEnum;
import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:material_symbols_icons/symbols.dart' show Symbols;

enum OrderStatusEnum {
  pending('Pendiente'),
  in_progress('En cocina'),
  ready_for_pickup('Listo para recoger'),
  out_for_delivery('En camino'),
  completed('Completado'),
  canceled('Cancelado'),
  unknown('Desconocido');

  final String label;
  const OrderStatusEnum(this.label);

  static OrderStatusEnum fromName(String name) {
    if (name.isEmpty) return OrderStatusEnum.unknown;
    return OrderStatusEnum.values.firstWhere(
      (e) => e.name.toLowerCase() == name.toLowerCase(),
      orElse: () => OrderStatusEnum.unknown,
    );
  }

  IconData getIcon() {
    switch (this) {
      case OrderStatusEnum.pending:
        return Symbols.watch_later;
      case OrderStatusEnum.in_progress:
        return Symbols.skillet;
      case OrderStatusEnum.ready_for_pickup:
        return Symbols.hand_package;
      case OrderStatusEnum.out_for_delivery:
        return FontAwesomeIcons.motorcycle;
      case OrderStatusEnum.completed:
        return Symbols.check;
      case OrderStatusEnum.canceled:
        return Symbols.cancel;
      default:
        return Symbols.question_mark;
    }
  }

  Color getColor() {
    switch (this) {
      case OrderStatusEnum.pending:
        return Colors.orange;
      case OrderStatusEnum.in_progress:
        return const Color.fromARGB(255, 202, 130, 108);
      // case OrderStatusEnum.pending:
      //   return const Color.fromARGB(255, 202, 176, 104);
      // case OrderStatusEnum.in_progress:
      //   return Colors.orange;
      case OrderStatusEnum.ready_for_pickup:
        return Colors.cyan;
      case OrderStatusEnum.out_for_delivery:
        return Colors.green;
      case OrderStatusEnum.completed:
        return Colors.teal;
      case OrderStatusEnum.canceled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static List<OrderStatusEnum> getStatusProcess (DeliveryTypeEnum deliveryType) {
    switch (deliveryType) {
      case DeliveryTypeEnum.pickup:
        return pickupProcess();
      case DeliveryTypeEnum.dispatch:
        return dispatchProcess();
      default:
        return [];
    }
  }

  static List<OrderStatusEnum> pickupProcess() {
    return [
      OrderStatusEnum.pending,
      OrderStatusEnum.in_progress,
      OrderStatusEnum.ready_for_pickup,
      OrderStatusEnum.completed,
    ];
  }

  static List<OrderStatusEnum> dispatchProcess() {
    return [
      OrderStatusEnum.pending,
      OrderStatusEnum.in_progress,
      OrderStatusEnum.out_for_delivery,
      OrderStatusEnum.completed,
    ];
  }
}
