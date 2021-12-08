import 'package:dio/dio.dart';
import 'package:dms/provider/repository.dart';
import 'package:dms/provider/url.dart';
import 'package:dms/ui/splash_screen/splash_screen.dart';
import 'package:dms/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

BaseOptions options = BaseOptions(
  responseType: ResponseType.json,
  baseUrl: Url.baseUrl,
  connectTimeout: 60000,
  sendTimeout: 60000,
  receiveTimeout: 60000,
);
Dio dio = Dio(options);
ApiRepository repository = ApiRepository();
ImagePicker imagePicker = ImagePicker();

void main() {
  dio.interceptors.add(LogInterceptor(requestHeader: true, requestBody: true, responseBody: true));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      title: 'DMS',
      debugShowCheckedModeBanner: false,
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
