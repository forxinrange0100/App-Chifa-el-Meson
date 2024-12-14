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
        createdAt: DateTime.parse(result['company']['created_at']),
        updatedAt: DateTime.parse(result['company']['updated_at']),
        name: result['company']['name'],
        description: result['company']['description'],
        logo: result['company']['logo'],
        heroImage: result['company']['hero_image'],
        instagram: result['company']['instagram'],
        facebook: result['company']['facebook'],
        whatsapp: result['company']['whatsapp'],
        address: result['company']['address'],
        phone: result['company']['phone'],
        schedule: result['company']['schedule'],
      );
    } else {
      throw FetchRestaurantInfoException(response.body.toString());
    }
  } catch (e) {
    throw FetchRestaurantInfoException(e.toString());
  }
}
