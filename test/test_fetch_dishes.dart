// Test fetch 100 times, saving responses with length < 18207 in a text file
// http.get(Uri.parse("${Urls.apiUrl}/api/products/${Urls.companyId}"));
// ignore_for_file: unused_import

import 'dart:developer' show log;
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:delivera/environment.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized()
  // TestWidgetsFlutterBinding.ensureInitialized();
  // final directory = await onDocumentsDirectory();
  // print('Directory: ${directory.path}');
  // final file = File('${directory.path}/test2_fetch_products.txt');
  // this gives an (OS Error: Read-only file system, errno = 30)
  // file.writeAsStringSync('123', mode: FileMode.append);
  log("Fetching products 1000 times.");
  for (int i = 0; i < 1000; i++) {
    try {
      final response = await http.get(Uri.parse("${Urls.apiUrl}/api/products/${Urls.companyId}"));
      if (response.statusCode == 200) {
        if (response.body.length < 7675) {
          // save all important information in the file
          // file.writeAsStringSync(response.body, mode: FileMode.append);
          log("Fetch Products: ${response.body}");
          log("Fetch Products headers: ${response.headers}");
        }
      }
    } catch (e) {
      log('Error fetching products: $e');
    }
  }
  log("Finished fetching products 1000 times.");
}
