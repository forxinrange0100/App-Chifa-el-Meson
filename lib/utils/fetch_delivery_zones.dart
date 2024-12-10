import 'dart:convert';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:chifa_el_meson/model/delivery_zone_model.dart';
import 'package:chifa_el_meson/model/delivery_zones.dart';
import 'package:http/http.dart' as http;
import 'package:chifa_el_meson/environment.dart';

Future<DeliveryZones> fetchDeliveryZones() async {
  try {
    final response = await http
        .get(Uri.parse("${Urls.apiUrl}/api/companies/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final dispatchZones = result['company']['dispatch_zones'];
      List<DeliveryZone> deliveryZones = [];
      for (var dispatchZone in dispatchZones) {
        deliveryZones.add(DeliveryZone(
            id: dispatchZone['id'],
            name: dispatchZone['name'],
            price: (dispatchZone['price'] as num).toDouble()));
      }
      return DeliveryZones(zones: deliveryZones);
    } else {
      throw FetchDeliveryZonesException(response.body.toString());
    }
  } catch (e) {
    throw FetchDeliveryZonesException(e.toString());
  }
}
