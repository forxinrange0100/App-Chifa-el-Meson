

import 'dart:convert' show json;

import 'package:delivera/environment.dart' show Urls;
import 'package:delivera/errors/errors.dart' show FetchDispatchEnabledException;
// import 'package:delivera/errors/errors.dart' show FetchDispatchEnabledException;
import 'package:http/http.dart' as http show get;

/// Realiza la peticion para saber si el despacho a domicilio está habilitado.
Future<bool> fetchDispatchEnabled() async {
  try {
    final response = await http.get(Uri.parse("${Urls.apiUrl}/api/configs/dispatch_enabled/${Urls.companyId}"));
    late final result = json.decode(response.body);
    if (result['success'] == true) {
      return result['dispatch_enabled'];
    }
    
    return false;
  } catch (e) {
    throw FetchDispatchEnabledException(e.toString());
  }
}