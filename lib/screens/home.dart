import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:flutter_frontend_test/screens/mostrar_balance_general.dart';
import 'subirArchivo.dart';
import 'mostrar_balance_general.dart';
import 'HomePage.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * .01),
          Text("Elegir acción", style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                decoration: TextDecoration.none
              ),),
          SizedBox(height: screenHeight * .01),
            Text(
              "Elige la acción deseada",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w100,
                decoration: TextDecoration.none
              ),
            ),
          SizedBox(height: screenHeight * .12),
          Column(
            children: [
              SimpleElevatedButton(
                child: const Text("Subir archivo"),
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SubirArchivo()),
              );
                },
              ),
              SizedBox(height: screenHeight * .025),
              SimpleElevatedButton(
                child: const Text("Ver balance general"),
                color: Colors.blue,
                onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MBalanceGeneral()),
                //MaterialPageRoute(builder: (context) => const ElegirEmpresa()),
              );},
              ),
             
            ],
                MaterialPageRoute(
                    builder: (context) => const MBalanceGeneral()),
              );
            },
          ),
          ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          
        ],
      ),
    );

  
  }
}


class SimpleElevatedButton extends StatelessWidget {
  const SimpleElevatedButton(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 6,
      this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        padding: padding,
        primary: color ?? currentTheme.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed as void Function()?,
    );
  }
}

//Seleccionar archivo
