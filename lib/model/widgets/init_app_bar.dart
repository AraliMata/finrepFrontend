import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/widgets/simple_elevated_button.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:get/get.dart';

import '../../screens/login_signin/background_page.dart';

class InitAppBar extends StatefulWidget implements PreferredSizeWidget {
  InitAppBar({Key? key})
      : preferredSize = Size.fromHeight(60.0),
        super(key: key);

  @override
  final Size preferredSize;

  @override
  _InitAppBarState createState() => _InitAppBarState();
}

class _InitAppBarState extends State<InitAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: BackButton(color: Colors.black, onPressed: () => Get.back()),
      actions: <Widget>[
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
