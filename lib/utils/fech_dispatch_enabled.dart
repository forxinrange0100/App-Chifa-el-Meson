

import 'dart:convert' show json;

import 'package:delivera/environment.dart' show Urls;
import 'package:delivera/errors/errors.dart' show FetchDispatchEnabledException;
import 'package:http/http.dart' as http show get;

Future<bool> fetchDispatchEnabled() async {
  try {
    // TODO: implement
    // final response = await http.get(Uri.parse("${Urls.apiUrl}/api/companies/${Urls.companyId}"));
    // if (response.statusCode == 200) {
    //   final result = json.decode(response.body);
    //   return result['company']['dispatch_enabled'];
    // } else {
    //   throw FetchDispatchEnabledException(response.body.toString());
    // }
    return true;
  } catch (e) {
    throw FetchDispatchEnabledException(e.toString());
  }
}