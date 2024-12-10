import 'package:chifa_el_meson/enum/delivery_detail_enum.dart';
import 'package:chifa_el_meson/model/delivery_zones.dart';
import 'package:flutter/material.dart';

class DeliveryDetailsProvider extends ChangeNotifier {
  DeliveryDetailEnum _deliveryDetailEnum = DeliveryDetailEnum.pickup;
  DeliveryZones _deliveryZones = DeliveryZones.example();

  DeliveryDetailsProvider();
  DeliveryZones get deliveryZones => _deliveryZones;
  DeliveryDetailEnum get deliveryDetailEnum => _deliveryDetailEnum;

  void init(DeliveryZones deliveryZones) {
    _deliveryZones = deliveryZones;
    notifyListeners();
  }

  void setDeliveryDetail(DeliveryDetailEnum deliveryDetailEnum) {
    _deliveryDetailEnum = deliveryDetailEnum;
    notifyListeners();
  }
}
