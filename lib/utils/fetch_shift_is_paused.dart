import 'dart:convert';
import 'package:delivera/errors/errors.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';

Future<bool> fetchShiftIsPaused() async {
  try {
    // TODO: implement
    final response = await http.get(Uri.parse("${Urls.apiUrl}/api/shifts/paused/${Urls.companyId}"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['is_paused'];
    } else {
      throw FetchRestaurantInfoException(response.body.toString());
    }
    // return false;
  } catch (e) {
    throw FetchRestaurantInfoException(e.toString());
  }
}
