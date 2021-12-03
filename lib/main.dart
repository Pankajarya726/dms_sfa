import 'package:dio/dio.dart';
import 'package:dms/provider/repository.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

BaseOptions options = BaseOptions(
  responseType: ResponseType.json,
  baseUrl: Url.baseUrl,
  connectTimeout: 60000,
  sendTimeout: 60000,
  receiveTimeout: 60000,
);
Dio dio = Dio(options);
ApiRepository repository = ApiRepository();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}
