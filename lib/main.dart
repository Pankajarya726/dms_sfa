import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dms/database/database_helper.dart';
import 'package:dms/navigation/navigation_service.dart';
import 'package:dms/provider/repository.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/splash_screen/splash_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

BaseOptions options = BaseOptions(
    responseType: ResponseType.json,
    baseUrl: Url.baseUrl,
    connectTimeout: 60000,
    sendTimeout: 60000,
    receiveTimeout: 60000,
    headers: {"Accept": "application/json"});

CancelToken cancelToken = CancelToken();
Dio dio = Dio(options);
ApiRepository repository = ApiRepository();
ImagePicker imagePicker = ImagePicker();
NavigationService navigationService = NavigationService();
DatabaseHelper databaseHelper = DatabaseHelper();

configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

final currencyFormat = NumberFormat.simpleCurrency(locale: "hi_IN", decimalDigits: 2);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl: true // option: set to false to disable working with http links (default: false)
      );

  dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      logPrint: (text) {
        log(text.toString());
      }));

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   debugPrint("AppLifecycleState--->$state");
  //   // if (state == AppLifecycleState.paused) {
  //   //   SystemNavigator.pop();
  //   // }
  //   super.didChangeAppLifecycleState(state);
  // }

  @override
  void dispose() {
    // WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      title: 'VV Sales Mitra',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      navigatorKey: navigationService.navigatorKey,
      theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFFF3505A,
            <int, Color>{
              50: Color(0xFFFFEBEE),
              100: Color(0xFFFFCDD2),
              200: Color(0xFFEF9A9A),
              300: Color(0xFFE57373),
              400: Color(0xFFEF5350),
              500: Color(0xFFF3505A),
              600: Color(0xFFE53935),
              700: Color(0xFFD32F2F),
              800: Color(0xFFC62828),
              900: Color(0xFFB71C1C),
            },
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionHandleColor: Colors.transparent,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: MColor.colorPrimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
            fillColor: const Color(0xFFF2F2F2),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: MColor.appBar,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.dark,
            ),
          ),
          buttonTheme: const ButtonThemeData(),
          fontFamily: GoogleFonts.roboto().fontFamily),
      home: const SplashScreen(),
    );
  }
}
