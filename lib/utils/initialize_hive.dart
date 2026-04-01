// import 'package:hive_ce/hive_ce.dart';
import 'package:delivera/model/order_model.dart' show Order;
import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:delivera/hive/hive_registrar.g.dart';
// import 'package:delivera/model/order_model.dart' show Order;
// import 'package:delivera/model/order_tracking_model.dart' show OrderTracking;
// import 'package:delivera/model/shopping_cart_model.dart';
// import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

/// Base class for box definitions
abstract class _BoxDefinition {
  String get name;
  Future<void> open();
}

/// Typed box definition
class _TypedBox<T> extends _BoxDefinition {
  @override
  final String name;

  _TypedBox(this.name);

  @override
  Future<void> open() => Hive.openBox<T>(name);
}

/// Untyped box definition
class _UntypedBox extends _BoxDefinition {
  @override
  final String name;

  _UntypedBox(this.name);

  @override
  Future<void> open() => Hive.openBox(name);
}

class _HiveInitializer {
  static final _HiveInitializer _instance = _HiveInitializer._internal();
  static final _boxes = <_BoxDefinition>[
    _TypedBox<Order>('orders'),
    _TypedBox<OrderTracking>('ordersTracking'),
    _UntypedBox('notification'),
    _UntypedBox('payment'),
    _UntypedBox('cart'),
    _UntypedBox('user'),
  ];

  bool _initialized = false;

  factory _HiveInitializer() {
    return _instance;
  }

  _HiveInitializer._internal();

  Future<void> initialize() async {
    if (_initialized) return;

    await Hive.initFlutter();
    Hive.registerAdapters();

    await _openAllBoxes();
    _initialized = true;
  }

  Future<void> _openAllBoxes() async {
    for (final box in _boxes) {
      try {
        await box.open();
      } catch (e) {
        if (!e.toString().contains('already open')) rethrow;
      }
    }
  }
}

Future<void> initializeHive() async {
  await _HiveInitializer().initialize();
}

void closeHive() {
  Hive.close();
}

extension HiveBoxExtension on Box {
  List<T?> getAll<T>(List keys) => keys.map((key) => get(key) as T?).toList();
}
