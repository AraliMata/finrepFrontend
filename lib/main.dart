import 'package:flutter/material.dart';
import './screens/home.dart';
import './screens/uploadingscreen.dart';
import './screens/card_textfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
