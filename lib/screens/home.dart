import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/login_signin/background_page.dart';
import 'package:flutter_frontend_test/screens/mostrar_relaciones_analiticas.dart';
import 'package:flutter_frontend_test/screens/elegir_periodo_bg.dart';
import 'package:flutter_frontend_test/screens/elegir_periodo_er.dart';
import '../model/widgets/init_app_bar.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'subir_archivo.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: InitAppBar(),
        body: Center(
          //padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * .01),
              AutoSizeText(
                "Elegir acción",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                    decoration: TextDecoration.none),
              ),
              SizedBox(height: screenHeight * .01),
              Center(
                  child: AutoSizeText(
                "Elige la acción deseada",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none),
                maxLines: 2,
              )),
              SizedBox(height: screenHeight * .12),
              Column(
                children: [
                  SimpleElevatedButton(
                    child: const Text("Subir archivo"),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SubirArchivo()),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * .025),
                  SimpleElevatedButton(
                    child: const Text("Ver balance general"),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ElegirPeriodoBG()),
                        //MaterialPageRoute(builder: (context) => const ElegirEmpresa()),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * .025),
                  SimpleElevatedButton(
                    child: const Text("Ver estado de resultados"),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ElegirPeriodo()),
                        //MaterialPageRoute(builder: (context) => const ElegirEmpresa()),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * .025),
                  SimpleElevatedButton(
                    child: const Text("Ver relaciones analíticas"),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MRelacionesAnaliticas()),
                        //MaterialPageRoute(builder: (context) => const ElegirEmpresa()),
                      );
                    },
                  ),
                  // SizedBox(height: screenHeight * .025),
                  // SimpleElevatedButton(
                  //   child: const Text("Cerrar Sesion"),
                  //   color: Colors.red,
                  //   onPressed: () => Get.to(BackgroundPage()),
                  // ),
                ],
              ),
              /*ElevatedButton(
            child: const Text('Login'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BackgroundPage()),
              );
            },
          ),*/
            ],
          ),
        ));
  }
}



//Seleccionar archivo
