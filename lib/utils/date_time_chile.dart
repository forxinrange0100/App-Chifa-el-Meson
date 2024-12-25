import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/standalone.dart' as tz;

DateTime dateTimeChile(DateTime timestamp) {
  tz.initializeTimeZones();
  final chileTimeZone = tz.getLocation('America/Santiago');
  final DateTime timestampUtc = timestamp;
  final tz.TZDateTime timestampChile =
      tz.TZDateTime.from(timestampUtc, chileTimeZone);
  return DateTime(
    timestampChile.year,
    timestampChile.month,
    timestampChile.day,
    timestampChile.hour,
    timestampChile.minute,
    timestampChile.second,
    timestampChile.millisecond,
    timestampChile.microsecond,
  );
}
