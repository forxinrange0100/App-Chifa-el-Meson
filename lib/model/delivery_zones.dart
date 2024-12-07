import 'package:chifa_el_meson/model/delivery_zone_model.dart';

class DeliveryZones {
  final List<DeliveryZone> zones;
  DeliveryZones({required this.zones});
  DeliveryZones.example()
      : zones = [
          DeliveryZone(id: 1, name: "Arica", price: 3000),
          DeliveryZone(id: 2, name: "Azapa", price: 4000),
          DeliveryZone(id: 3, name: "Villa frontera", price: 5000)
        ];
}
