import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:flutter_frontend_test/screens/mostrar_balance_general.dart';
import 'package:flutter_frontend_test/screens/mostrar_relaciones_analiticas.dart';
import 'package:flutter_frontend_test/screens/prueba_mostrar_estado_resultados.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:flutter_frontend_test/screens/mostrar_relaciones_analiticas.dart';
import 'package:flutter_frontend_test/screens/elegirPeriodoBG.dart';
import 'package:flutter_frontend_test/screens/elegirPeriodoER.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'subirArchivo.dart';
import 'dart:convert';
import 'dart:html';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mostrar_balance_general.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  Future<void> _createPDF() async {
    //Create a PDF document.
    PdfDocument document = PdfDocument();
    //Add a page and draw text
    document.pages.add().graphics.drawString(
        'Hello World!', PdfStandardFont(PdfFontFamily.helvetica, 20),
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(20, 60, 150, 30));
    //Save the document
    List<int> bytes = document.save();
    //Dispose the document
    document.dispose();

    //Download the output file
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight * .01),
          Text(
            "Elegir acción",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                decoration: TextDecoration.none),
          ),
          SizedBox(height: screenHeight * .01),
          Text(
            "Elige la acción deseada",
            style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w100,
                decoration: TextDecoration.none),
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
                child: const Text("Ver relaciones analiticas"),
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MRelacionesAnaliticas()),
                    //MaterialPageRoute(builder: (context) => const ElegirEmpresa()),
                  );
                },
              ),
              SizedBox(height: screenHeight * .025),
              SimpleElevatedButton(
                child: const Text("Cerrar Sesion"),
                color: Colors.red,
                onPressed: () => Get.to(BackgroundPage()),
              ),
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
    );
  }
}



//Seleccionar archivo
