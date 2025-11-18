import 'package:delivera/enum/delivery_type_enum.dart';
import 'package:delivera/model/delivery_zone_model.dart' show DeliveryZone;
import 'package:delivera/utils/fech_dispatch_enabled.dart' show fetchDispatchEnabled;
import 'package:delivera/utils/fetch_delivery_zones.dart' show fetchDeliveryZones;
import 'package:flutter/material.dart';

class DeliveryDetailsProvider extends ChangeNotifier {

  DeliveryDetailsProvider();

  DeliveryTypeEnum? _deliveryTypeEnum;
  DeliveryTypeEnum? get deliveryTypeEnum => _deliveryTypeEnum;

  List<DeliveryZone> _deliveryZones = [];
  bool? _dispatchEnabled;
  List<DeliveryZone> get deliveryZones => _deliveryZones;
  bool? get dispatchEnabled => _dispatchEnabled;

  /// Actualiza las zonas de envio disponibles y si el tipo de envio "Dispatch" está disponible
  Future<void> update() async {
    _deliveryZones = await fetchDeliveryZones();
    _dispatchEnabled = await fetchDispatchEnabled();
    notifyListeners();
  }

  void setDeliveryTypeEnum(DeliveryTypeEnum deliveryTypeEnum) {
    _deliveryTypeEnum = deliveryTypeEnum;
    notifyListeners();
  }

  void clearDeliveryTypeEnum({bool notify = false}) {
    _deliveryTypeEnum = null;
    if (notify) notifyListeners();
  }
}
