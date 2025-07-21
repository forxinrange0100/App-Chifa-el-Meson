import 'package:delivera/enum/delivery_detail_enum.dart';
import 'package:delivera/model/delivery_zones.dart';
import 'package:flutter/material.dart';

class DeliveryDetailsProvider extends ChangeNotifier {
  DeliveryDetailEnum? _deliveryDetailEnum;
  DeliveryZones _deliveryZones = DeliveryZones.example();
  bool? _dispatchEnabled;

  DeliveryDetailsProvider();
  DeliveryZones get deliveryZones => _deliveryZones;
  DeliveryDetailEnum? get deliveryDetailEnum => _deliveryDetailEnum;
  bool? get dispatchEnabled => _dispatchEnabled;

  void init(DeliveryZones deliveryZones, bool dispatchEnabled) {
    _deliveryZones = deliveryZones;
    _dispatchEnabled = dispatchEnabled;
    notifyListeners();
  }

  void setDeliveryDetail(DeliveryDetailEnum deliveryDetailEnum) {
    _deliveryDetailEnum = deliveryDetailEnum;
    notifyListeners();
  }
}
