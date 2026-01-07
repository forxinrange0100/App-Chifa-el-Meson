import 'package:upgrader/upgrader.dart' show UpgraderMessages;

class CustomUpgraderSpanish extends UpgraderMessages {
  @override
  String get languageCode => 'es';

  @override
  String get title => 'Actualizar aplicación';
  @override
  String get buttonTitleLater => 'SALIR';
  @override
  // TODO: implement body
  String get body => '${super.body}\n\nPor favor, actualice para continuar usando la aplicación.';
}
