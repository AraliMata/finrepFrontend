import 'package:flutter/material.dart';
import 'constants.dart';
import 'login.dart';
import 'signup.dart';
import 'package:bordered_text/bordered_text.dart';

class BackgroundPage extends StatefulWidget {
  @override
  _BackgroundPageState createState() => _BackgroundPageState();
}

class _BackgroundPageState extends State<BackgroundPage> {
  Option selectedOption = Option.LogIn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    //print(size.height);
    //print(size.width);

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width / 2,
                  color: kPrimaryColor,
                ),
                Container(
                    height: double.infinity,
                    width: size.width / 2,
                    color: Colors.white),
              ],
            ),
          
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  "Bienvenido a FinRep",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: const [
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.keyboard_arrow_left,
                    //   ),
                    //   //Icons.keyboard_arrow_left,
                    //   color: Colors.white,
                    //   iconSize: 28,
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(builder: (context) => const Home()),
                    //     );
                    //   },
                    // ),
                    // SizedBox(
                    //   width: 8,
                    // ),
                    // Text(
                    //   "Volver",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 16,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Icon(
                      Icons.copyright,
                      color: Colors.grey,
                      size: 24,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "FinRep 2022",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),

              //Animation 1
              //transitionBuilder: (widget, animation) => RotationTransition(
              //  turns: animation,
              //  child: widget,
              //),
              //switchOutCurve: Curves.easeInOutCubic,
              //switchInCurve: Curves.fastLinearToSlowEaseIn,

              //Animation 2
              transitionBuilder: (widget, animation) =>
                  ScaleTransition(child: widget, scale: animation),

              child: selectedOption == Option.LogIn
                  ? LogIn(
                      onSignUpSelected: () {
                        setState(() {
                          selectedOption = Option.SignUp;
                        });
                      },
                    )
                  : SignUp(
                      onLogInSelected: () {
                        setState(() {
                          selectedOption = Option.LogIn;
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BorderedText {
}
