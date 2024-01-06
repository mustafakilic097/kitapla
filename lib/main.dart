import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kitapla/core/init/navigation/navigation_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      getPages: NavigationManager.routes,
      initialRoute: NavigationManager.getAuthRoute,
      title: 'Kitapla',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.primaries[17],
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(255, 102, 102, 1), secondary: const Color.fromRGBO(255, 242, 204, 1)),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
