import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/widgets/simple_elevated_button.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:get/get.dart';

import '../../screens/login_signin/background_page.dart';

class GeneralAppBar extends StatefulWidget implements PreferredSizeWidget {
  GeneralAppBar({Key? key})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _GeneralAppBarState createState() => _GeneralAppBarState();
}

class _GeneralAppBarState extends State<GeneralAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: BackButton(color: Colors.black, onPressed: () => Get.back()),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Get.to(const Home()),
              child: Icon(
                Icons.home_filled,
                size: 26.0,
                color: Colors.black,
              ),
            )),
        Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              //child: const Text("Cerrar Sesión"),
              child: const Icon(Icons.exit_to_app, color: Colors.red),
              onTap: () => Get.to(BackgroundPage()),
            )),
      ],
      title: const Text(' '),
    );
  }
}


/*class GeneralAppBar extends AppBar {
  
  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return  AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white,
            leading:
                BackButton(color: Colors.black, onPressed: () => Get.back()),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () => Get.to(const Home()),
                    child: Icon(
                      Icons.home_filled,
                      size: 26.0,
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(right: 20, bottom: 8, top: 8),
                  child: SimpleElevatedButton(
                    child: const Text("Cerrar Sesión"),
                    color: Colors.red,
                    onPressed: () => Get.to(BackgroundPage()),
                  )),
            ],
            title: const Text(' '),
          );
  }
}
*/


