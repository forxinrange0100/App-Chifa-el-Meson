import 'dart:convert' show jsonDecode;
import 'package:delivera/errors/errors.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';
import 'package:delivera/model/restaurant_info_model.dart';

Future<RestaurantInfo> fetchRestaurantInfo() async {
  try {
    final response = await http.get(
      Uri.parse("${Urls.apiUrl}/api/companies/${Urls.companyId}"),
    );

    if (response.statusCode != 200) {
      throw FetchRestaurantInfoException(response.body.toString());
    }

    final result = jsonDecode(response.body);
    final json = result['company'];
    if (json == null) {
      throw ResponseParsingException(details: 'company es null');
    }

    return RestaurantInfo.fromJson(json);
  } catch (e) {
    throw FetchRestaurantInfoException(e.toString());
  }
}
