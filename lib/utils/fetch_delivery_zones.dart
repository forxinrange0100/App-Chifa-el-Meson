import 'dart:convert' show jsonDecode;
import 'package:delivera/errors/errors.dart';
import 'package:delivera/model/delivery_zone_model.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';

Future<List<DeliveryZone>> fetchDeliveryZones() async {
  try {
    final response = await http.get(
      Uri.parse("${Urls.apiUrl}/api/companies/${Urls.companyId}"),
    );
    if (response.statusCode != 200) {
      throw FetchDeliveryZonesException(response.body.toString());
    }

    final result = jsonDecode(response.body);
    final List<dynamic> dispatchZones = result['company']['dispatch_zones'];
    List<DeliveryZone> deliveryZones = [];
    for (var dispatchZone in dispatchZones) {
      deliveryZones.add(DeliveryZone.fromJson(dispatchZone));
    }
    return deliveryZones;
  } catch (e) {
    throw FetchDeliveryZonesException(e.toString());
  }
}
