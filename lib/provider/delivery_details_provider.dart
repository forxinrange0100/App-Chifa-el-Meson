import 'package:delivera/enum/delivery_detail_enum.dart';
import 'package:delivera/model/delivery_zones.dart';
import 'package:delivera/utils/fech_dispatch_enabled.dart' show fetchDispatchEnabled;
import 'package:delivera/utils/fetch_delivery_zones.dart' show fetchDeliveryZones;
import 'package:flutter/material.dart';

class DeliveryDetailsProvider extends ChangeNotifier {
  DeliveryDetailEnum? _deliveryDetailEnum;
  DeliveryZones _deliveryZones = DeliveryZones.example();
  bool? _dispatchEnabled;

  DeliveryDetailsProvider();

  DeliveryDetailEnum? get deliveryDetailEnum => _deliveryDetailEnum;
  DeliveryZones get deliveryZones => _deliveryZones;
  bool? get dispatchEnabled => _dispatchEnabled;

  /// Actualiza las zonas de envio disponibles y si el tipo de envio "Dispatch" está disponible
  Future<void> update() async {
    _deliveryZones = await fetchDeliveryZones();
    _dispatchEnabled = await fetchDispatchEnabled();
    notifyListeners();
  }

  void setDeliveryDetailEnum(DeliveryDetailEnum deliveryDetailEnum) {
    _deliveryDetailEnum = deliveryDetailEnum;
    notifyListeners();
  }

  void clearDeliveryDetailEnum({bool notify = false}) {
    _deliveryDetailEnum = null;
    if (notify) notifyListeners();
  }
}
