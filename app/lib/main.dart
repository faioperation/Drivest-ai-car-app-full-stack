import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';

import 'app/app.dart';
import 'core/services/network/car_provider.dart';
import 'core/services/network/user_provider.dart';
import 'features/notifications/services/notification_count_provider.dart';
import 'home/controller/saved_car_controller.dart';

StreamSubscription<Uri>? _linkSub;
AppLinks? _appLinks;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   // ✅ MUST HAVE

  // GetX controllers
  Get.put(SavedCarController(), permanent: true);

  // Deep link initialization BEFORE runApp
  await initDeepLinks();                      // ✅ moved here

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationCountProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// ------------------------------------------------------------
/// Deep Link Handler
/// ------------------------------------------------------------
Future<void> initDeepLinks() async {
  debugPrint('INIT: initDeepLinks() called');
  _appLinks ??= AppLinks();

  // ---- COLD START ----
  try {
    final initial = await _appLinks!.getInitialLink();
    debugPrint('INIT: getInitialLink() => $initial');
    if (initial != null) _handleUri(initial);
  } catch (e) {
    debugPrint('INIT ERROR: $e');
  }

  // ---- WARM / FOREGROUND ----
  _linkSub?.cancel();
  _linkSub = _appLinks!.uriLinkStream.listen((uri) {
    debugPrint('STREAM: $uri');
    _handleUri(uri);
  }, onError: (err) {
    debugPrint('Deep link stream error: $err');
  });
}

/// ------------------------------------------------------------
/// URI Resolver
/// ------------------------------------------------------------
void _handleUri(Uri uri) {
  debugPrint('DEEP LINK => $uri');

  final segments = uri.host.isEmpty
      ? uri.pathSegments
      : [uri.host, ...uri.pathSegments];

  if (segments.isEmpty) {
    Get.snackbar('Deep Link', 'Invalid or empty link');
    return;
  }

  final first = segments[0];

  // drivest://ride/69
  if (first == 'ride' && segments.length >= 2 && segments[1] == '69') {
    Get.snackbar('Deep Link', 'Ride 69 opened successfully!');
    return;
  }

  // drivest://profile/nime
  if (first == 'profile' && segments.length >= 2 && segments[1] == 'nime') {
    Get.snackbar('Deep Link', 'Welcome, Nime!');
    return;
  }

  debugPrint('Invalid deep link: $uri');
  Get.snackbar('Deep Link', 'Invalid link: $uri');
}
