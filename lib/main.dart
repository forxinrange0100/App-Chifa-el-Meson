import 'dart:async' show StreamSubscription;
import 'dart:developer' show log;

import 'package:app_links/app_links.dart' show AppLinks;
import 'package:delivera/firebase_options.dart';
import 'package:delivera/pages/history_page.dart' show HistoryPage;
import 'package:delivera/pages/home_info_page.dart' show HomeInfoPage;
import 'package:delivera/pages/invoice_page.dart' show InvoicePage;
import 'package:delivera/pages/order_summary_page.dart' show OrderSummaryPage;
import 'package:delivera/pages/order_tracking_page.dart' show OrderTrackingPage;
import 'package:delivera/pages/payment_page.dart' show PaymentPage;
import 'package:delivera/pages/shopping_cart_page.dart' show ShoppingCartPage;
import 'package:delivera/utils/initialize_hive.dart' show initializeHive;
import 'package:flutter_native_splash/flutter_native_splash.dart' show FlutterNativeSplash;
import 'package:delivera/services/firebase_messaging_service.dart';
import 'package:delivera/services/local_notifications_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:delivera/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:delivera/services/local_notifications_service.dart' show LocalNotificationsService;
import 'package:delivera/services/firebase_messaging_service.dart' show FirebaseMessagingService;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:io' show HttpClient;
import 'package:delivera/pages/home_page.dart' show HomePage;
import 'package:delivera/provider/bottom_navigation_bar_provider.dart' show BottomNavigationBarProvider;
import 'package:delivera/provider/data_provider.dart' show DataProvider;
import 'package:delivera/provider/delivery_details_provider.dart' show DeliveryDetailsProvider;
import 'package:delivera/provider/dish_categories_provider.dart' show DishCategoriesProvider;
import 'package:delivera/provider/dishes_provider.dart' show DishesProvider;
import 'package:delivera/provider/invoice_provider.dart' show InvoiceProvider;
import 'package:delivera/provider/order_summary_provider.dart' show OrderSummaryProvider;
import 'package:delivera/provider/payment_provider.dart' show PaymentProvider;
import 'package:delivera/provider/restaurant_info_provider.dart' show RestaurantInfoProvider;
import 'package:delivera/provider/scroll_controller_provider.dart' show ScrollControllerProvider;
import 'package:delivera/provider/shift_provider.dart' show ShiftProvider;
import 'package:delivera/provider/shopping_cart_provider.dart' show ShoppingCartProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);

  // Para evitar un error en la herramienta Network mientras se debuggea
  if (kDebugMode) {
    HttpClient.enableTimelineLogging = true;
  }

  await initializeHive();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appLinks = AppLinks();
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    listenForAppLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> listenForAppLinks() async {
    // Caso cuando la app se abre desde un link estando cerrada
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      log('cuidao');
      _handleAppLink(initialLink);
    }

    // Caso cuando la app ya está abierta
    // _sub = _appLinks.uriLinkStream.listen((uri) {
    //   log('sin cuidao');
    //   _handleAppLink(uri);
    // }, onError: (err) {
    //   log("Error en app link stream: $err");
    // });
  }

  void _handleAppLink(Uri uri) {
    if (uri.scheme != 'delivera') return;

    FlutterNativeSplash.remove();
    setState(() {});

    final host = uri.host;
    final pathSegments = uri.pathSegments;
    log('path segments: $pathSegments');
    switch (host) {
      case 'invoice':
        final publicId = int.parse(pathSegments.first);
        log('public id: $publicId');
        _navigateInvoice(publicId);
        break;
      default:
        log("DeepLin host desconocido: $host");
    }
  }

  void _navigateInvoice(int publicId) {
    final con = navigatorKey.currentContext;

    con!.read<InvoiceProvider>().publicId = publicId;

    Navigator.pushAndRemoveUntil(
      con,
      MaterialPageRoute(builder: (con) => const InvoicePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavigationBarProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantInfoProvider()),
        ChangeNotifierProvider(create: (_) => DishesProvider()),
        ChangeNotifierProvider(create: (_) => DishCategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ScrollControllerProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingCartProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryDetailsProvider()),
        ChangeNotifierProvider(create: (_) => ShiftProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(
          create: (context) => OrderSummaryProvider(
            context.read<RestaurantInfoProvider>(),
            context.read<ShoppingCartProvider>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => InvoiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DataProvider(
            context.read<RestaurantInfoProvider>(),
            context.read<DishesProvider>(),
            context.read<DishCategoriesProvider>(),
            context.read<DeliveryDetailsProvider>(),
          ),
        )
      ],
      child: ToastificationWrapper(
        child: MaterialApp(
          navigatorKey: navigatorKey,
          routes: {
            'HomePage': (_) => const HomePage(),
            'HomeInfoPage': (_) => const HomeInfoPage(),
            'ShoppingCartPage': (_) => const ShoppingCartPage(),
            'HistoryPage': (_) => const HistoryPage(),
            'OrderSummaryPage': (_) => const OrderSummaryPage(),
            'PaymentPage': (_) => const PaymentPage(),
            'InvoicePage': (_) => const InvoicePage(),
            'OrderTrackingPage': (_) => const OrderTrackingPage(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(foregroundColor: WidgetStatePropertyAll<Color>(Colors.black)),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(selectedItemColor: Colors.black),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
            ),
            useMaterial3: false,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
