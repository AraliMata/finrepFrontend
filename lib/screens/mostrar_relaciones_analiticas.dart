import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/relaciones_analiticas.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/simple_elevated_button.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:flutter_frontend_test/screens/login_signin/background_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../model/widgets/general_app_bar.dart'; //Para PDF
import 'package:flutter_frontend_test/model/tools/normal_lib.dart' // Stub implementation
    if (dart.library.html) 'package:flutter_frontend_test/model/tools/web_libs.dart'
    if (dart.library.io) 'package:flutter_frontend_test/model/tools/mobile_libs.dart';

class MRelacionesAnaliticas extends StatefulWidget {
  const MRelacionesAnaliticas({Key? key}) : super(key: key);
  @override
  State<MRelacionesAnaliticas> createState() => RelacionesAnaliticasState();
}

class RelacionesAnaliticasState extends State<MRelacionesAnaliticas> {
  late Future<RelacionesAnaliticas> relacionesAnaliticas;
  late RelacionesAnaliticas relacionesAnaliticas2;
  late String nombreEmpresa;
  late ConvertidorDataTable convertidor;
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

  @override
  void initState() {
    super.initState();
    relacionesAnaliticas = getRelacionesAnaliticas();
    getNombreDeEmpresa();
  }

  Future<void> getNombreDeEmpresa() async {
    nombreEmpresa = await elegirEmpresaData.getNombreEmpresa();
  }

  Future<RelacionesAnaliticas> getRelacionesAnaliticas() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/relaciones-analiticas"));

    developer.log(jsonDecode(response.body).toString(),
        name: "RelacionesAnaliticas");

    developer.log(jsonDecode(response.body).runtimeType.toString(),
        name: "RelacionesAnaliticasTipo");

    final relacionesAnaliticas =
        RelacionesAnaliticas.fromJson(jsonDecode(response.body));

    developer.log(relacionesAnaliticas.movimientos[0][0].toString(),
        name: "RelacionesAnaliticasMovimiento");

    return relacionesAnaliticas;
  }

  Widget _textNumber(data, style1, type, padding) {
    var f = NumberFormat("#,##0.00", "en_US");
    var n = NumberFormat("-#,##0.00", "en_US");

    var string = '';
    var style = style1;

    if (data.runtimeType.toString() == 'String') {
      string = data.toString();
      return Align(
          alignment: Alignment.centerLeft, child: Text(string, style: style));
    } else if (data + .0 < 0.0) {
      string = n.format(data.abs());

      if (type == "n") {
        style = const TextStyle(color: Colors.red, fontWeight: FontWeight.bold);
      }
    } else {
      string = f.format(data);
    }

    return Padding(
        padding: padding,
        child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              string,
              style: style,
            )));
  }

  String _stringFormatted(data) {
    var f = NumberFormat("#,##0.00", "en_US");
    var n = NumberFormat("-#,##0.00", "en_US");

    if (data.runtimeType.toString() == 'String') {
      return data;
    } else if (data + .0 < 0.0) {
      return n.format(data.abs());
    } else {
      return f.format(data);
    }
  }

  List<DataCell> _createCells(datos) {
    List<DataCell> celdas = [];

    String type = datos[6].toString();
    String acrdeud = datos[7].toString();
    var style, text, padding;

    for (int i = 0; i < 6; i++) {
      style = const TextStyle(fontWeight: FontWeight.normal);
      padding = const EdgeInsets.only(right: 0);

      if (type == "n") {
        style = const TextStyle(fontWeight: FontWeight.bold);
      }
      if (acrdeud == "a") {
        padding = const EdgeInsets.only(right: 30);
      }

      celdas.add(DataCell(_textNumber(datos[i], style, type, padding)));
    }

    return celdas;
  }

  List<DataRow> _createRows(movimientos, totalCuentas, sumasIguales) {
    List<DataRow> renglon = [];

    renglon += movimientos.map<DataRow>((movimiento) {
      return DataRow(cells: _createCells(movimiento));
    }).toList();

    return renglon;
  }

  Future<void> gridsillo(data) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
//Create a PdfGrid class
    PdfGrid grid = PdfGrid(); // Creación de la tabla

//Add the columns to the grid
    grid.columns
        .add(count: 6); //Poner el número de columnas (RelacionesAnaliticas: 6)

    grid.columns[0].width = 66;
    grid.columns[1].width = 130;
    grid.columns[2].width = 84;
    grid.columns[3].width = 76;
    grid.columns[4].width = 76;
    grid.columns[5].width = 84;

//Add values to header
    PdfGridRow header = grid.headers.add(1)[0];
    header.cells[0].value = 'Cuenta';
    header.cells[1].value = 'Nombre';
    header.cells[2].value = 'Saldos iniciales\nDeudor Acreedor';
    header.cells[3].value = 'Cargos';
    header.cells[4].value = 'Abonos';
    header.cells[5].value = 'Saldos Actuales\nDeudor Acreedor';

    //data.ingreso.length
    for (int i = 0; i < data.movimientos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.movimientos[i][0].toString();
      curRow.cells[1].value = data.movimientos[i][1].toString();
      curRow.cells[2].value = _stringFormatted(data.movimientos[i][2]);
      curRow.cells[3].value = _stringFormatted(data.movimientos[i][3]);
      curRow.cells[4].value = _stringFormatted(data.movimientos[i][4]);
      curRow.cells[5].value = _stringFormatted(data.movimientos[i][5]);

      //Si la linea va en negritas
      if (data.movimientos[i][6] == 'n') {
        curRow.style = PdfGridRowStyle(
            font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
                style: PdfFontStyle.bold));
      }

      //Alineacion de lineas de saldos

      for (int i = 2; i < 6; i++) {
        curRow.cells[i].style.stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.right);
      }

      //Set de padding de lineas de saldos
      curRow.cells[2].style.cellPadding = PdfPaddings(right: 10);
      curRow.cells[5].style.cellPadding = PdfPaddings(right: 10);
      // Si es acreedora o deudora
      if (data.movimientos[i][7] == 'a') {
        curRow.cells[2].style.cellPadding = PdfPaddings(right: 20);
        curRow.cells[5].style.cellPadding = PdfPaddings(right: 20);
      }
    }

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 0),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        borderOverlapStyle: PdfBorderOverlapStyle.overlap,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 10));
//Draw the grid
    grid.draw(page: document.pages.add(), bounds: Rect.zero);
//Save the document.
    List<int> bytes = document.save();
//Dispose the document.
    document.dispose();

    await WebFuncts.downloadPdf(
        bytes, "RelacionesAnalíticas-" + DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinRep',
      home: Scaffold(
          appBar: GeneralAppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => gridsillo(relacionesAnaliticas2),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.download),
          ),
          body: FutureBuilder<RelacionesAnaliticas>(
              future: relacionesAnaliticas,
              builder: (context, snapshot) {
                RelacionesAnaliticas datos = snapshot.data ??
                    RelacionesAnaliticas(movimientos: [
                      ['', '', '', '', '', '', '', '']
                    ], totalCuentas: [
                      ['', '', '', '', '', '', '', '']
                    ], sumasIguales: [
                      ['', '', '', '', '', '', '', '']
                    ]);
                relacionesAnaliticas2 = datos;
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');

                  return ListView(
                      children: [
                            SizedBox(height: screenHeight * .05),
                            Center(
                              child: AutoSizeText("Relaciones Analíticas",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                      decoration: TextDecoration.none),
                                  maxLines: 1),
                            ),
                            SizedBox(height: screenHeight * .05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(children: const [
                                  AutoSizeText(
                                    'FinRep',
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 16),
                                    maxLines: 1,
                                  )
                                ]),
                                Column(children: [
                                  AutoSizeText(
                                    nombreEmpresa,
                                    maxLines: 1,
                                  )
                                ]),
                                Column(children: [
                                  AutoSizeText(
                                    DateTime.now().toString(),
                                    maxLines: 1,
                                  )
                                ]),
                              ],
                            ),
                            SizedBox(height: screenHeight * .12),
                            Expanded(
                                child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: DataTable(
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Cuenta',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Nombre',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Saldos Iniciales            \n Deudor       Acreedor',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '\n Cargos',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        '\n Abonos',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Saldos Actuales \n Deudor  Acreedor',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                  rows: _createRows(datos.movimientos,
                                      datos.totalCuentas, datos.sumasIguales)
                                  //rows: createRows(snapshot.data?.ingresos),
                                  ),
                            ))
                          ] +
                          [SizedBox(height: screenHeight * 0.05)]);
                } else {
                  // developer.log('${snapshot.error}', name: 'NoTieneData55');
                  return const ProgressBar();
                  // return const ProgressBar();
                }
              })),
    );
  }
}
