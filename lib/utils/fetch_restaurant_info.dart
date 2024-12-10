import 'dart:convert';
import 'package:chifa_el_meson/errors/errors.dart';
import 'package:http/http.dart' as http;
import 'package:chifa_el_meson/environment.dart';
import 'package:chifa_el_meson/model/restaurant_info_model.dart';

Future<RestaurantInfo> fetchRestaurantInfo() async {
  try {
    final response = await http
        .get(Uri.parse("${Urls.apiUrl}/api/companies/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);

      return RestaurantInfo(
        id: result['company']['id'],
        name: result['company']['name'],
        description: result['company']['description'],
        address: result['company']['address'],
        phoneNumber: result['company']['phone'],
        openingHour: result['company']['schedule'],
        iconUrl: result['company']['logo'],
        backgroundUrl: result['company']['hero_image'],
      );
    } else {
      throw FetchRestaurantInfoException(response.body.toString());
    }
  } catch (e) {
    throw FetchRestaurantInfoException(e.toString());
  }
}
