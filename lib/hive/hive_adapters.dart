import 'package:delivera/enum/order_status_enum.dart';
import 'package:delivera/model/cart_item_model.dart';
import 'package:delivera/model/product_model.dart';
import 'package:delivera/model/order_product_model.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:delivera/model/order_model.dart';
import 'package:delivera/model/order_tracking_model.dart';
import 'package:delivera/model/shopping_cart_model.dart';

@GenerateAdapters([
  AdapterSpec<Order>(),
  AdapterSpec<OrderProduct>(),
  AdapterSpec<Product>(),
  // --
  AdapterSpec<OrderTracking>(),
  AdapterSpec<OrderStatusEnum>(),
  // --
  AdapterSpec<ShoppingCart>(),
  AdapterSpec<CartItem>(),
])

part 'hive_adapters.g.dart';
