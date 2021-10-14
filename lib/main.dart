import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sfa/provider/repository.dart';
import 'package:sfa/provider/url.dart';
import 'package:sfa/ui/splash_screen/splash_screen.dart';
import 'package:sfa/utility/colors.dart';
import 'package:sfa/utility/shared_prefrence.dart';

BaseOptions options = BaseOptions(
  baseUrl: Url.baseUrl,
  connectTimeout: 60000,
  sendTimeout: 60000,
  receiveTimeout: 60000,
);
Dio dio = Dio(options);
ApiRepository repository = ApiRepository();

void main() {
  dio.interceptors.add(LogInterceptor(
      requestHeader: true, requestBody: true, responseBody: true));
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: colorPrimary,
    ),
  );
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
}

void getToken() async {
  var token = await SharedPrefrence.getStringPreference(SharedPrefrence.token);
  Map<String, dynamic> header = {
    "Autherization": "Bearer $token",
  };
  options.headers.addAll(header);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      // statusBarColor is used to set Status bar color in Android devices.
      statusBarColor: const Color(0xfff24b55),

      // To make Status bar icons color white in Android devices.
      statusBarIconBrightness: Brightness.light,

      // statusBarBrightness is used to set Status bar icon color in iOS.
      statusBarBrightness: Brightness.light,
      // Here light means dark color Status bar icons.
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SFA',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          // ignore: deprecated_member_use
          brightness: Brightness.light,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
