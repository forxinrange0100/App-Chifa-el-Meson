

import 'package:intl/intl.dart' show NumberFormat;

String formatPrice(int price, {String prefix='', String postfix=''}) {
  return "$prefix\$${NumberFormat.decimalPattern('es').format(price)}$postfix";
}