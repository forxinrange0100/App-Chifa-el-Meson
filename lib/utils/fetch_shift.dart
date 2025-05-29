import 'dart:convert';
import 'package:delivera/errors/errors.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';

Future<bool> fetchShift() async {
  try {
    final response = await http
        .get(Uri.parse("${Urls.apiUrl}/api/shifts/open/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['open'];
    } else {
      throw FetchRestaurantInfoException(response.body.toString());
    }
  } catch (e) {
    throw FetchRestaurantInfoException(e.toString());
  }
}
