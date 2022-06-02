import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/login_signin/constants.dart';
import 'screens/login_signin/BackgroundPage.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: ResponsiveSizer(builder: (context, orientation, screenType) {
        return Home();
      }),
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.secularOneTextTheme(),
      ),
      debugShowCheckedModeBanner: false, //hola
      /*initialRoute: '/',
      routes: {
        '/': (context) => BackgroundPage(),
      },*/
    );
  }
}
