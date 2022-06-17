import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/estado_resultados.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/screens/elegir_periodo_er.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../../env.sample.dart';
import 'package:intl/intl.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../model/widgets/simple_elevated_button.dart';
import '../model/widgets/general_app_bar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'package:flutter_frontend_test/model/tools/normal_lib.dart' // Stub implementation
    if (dart.library.js) 'package:flutter_frontend_test/model/tools/web_libs.dart'
    if (dart.library.io) 'package:flutter_frontend_test/model/tools/mobile_libs.dart';

class MEstadoResultados extends StatefulWidget {
  const MEstadoResultados({Key? key}) : super(key: key);
  @override
  State<MEstadoResultados> createState() => EstadoResultadosState();
}

class EstadoResultadosState extends State<MEstadoResultados> {
  late Future<EstadoResultados> balance;
  late EstadoResultados estadoResultados;
  late ConvertidorDataTable convertidor;
  late String nombreEmpresa;
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();
  ElegirPeriodoState elegirPeriodoData = ElegirPeriodoState();

  @override
  void initState() {
    super.initState();
    balance = getEstadoResultados();
    getNombreDeEmpresa();
  }

  Future<void> getNombreDeEmpresa() async {
    nombreEmpresa = await elegirEmpresaData.getNombreEmpresa();
  }

  Future<EstadoResultados> getEstadoResultados() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    var periodo = await elegirPeriodoData.getMonth();

    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/$periodo/estado-resultados"));

    developer.log(jsonDecode(response.body).toString(),
        name: "EstadoResultados");

    final estadoResultados =
        EstadoResultados.fromJson((jsonDecode(response.body)));

    developer.log(estadoResultados.ingresos.toString(),
        name: "EstadoResultados");

    return estadoResultados;
  }

  DataCell _cellDataFormatted(data) {
    var f = NumberFormat("#,##0.00", "en_US");
    var n = NumberFormat("-#,##0.00", "en_US");
    if (data.runtimeType.toString() == 'String') {
      return DataCell(Text(data));
    } else if (data + .0 < 0.0) {
      return DataCell(Align(
          alignment: Alignment.centerRight,
          child: Text(n.format(data.abs()),
              style: const TextStyle(color: Colors.red))));
    } else {
      return DataCell(
          Align(alignment: Alignment.centerRight, child: Text(f.format(data))));
    }
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
    if (datos[1] == 0 && datos[2] == 0 && datos[3] == 0 && datos[4] == 0) {
      celdas.add(DataCell(Text(datos[0].toString())));

      for (int i = 1; i < 5; i++) {
        celdas.add(const DataCell(Text('')));
      }
    } else {
      if (datos[0].toString() == "Total Ingresos" ||
          datos[0].toString() == "Total Egresos" ||
          datos[0].toString() == "Ingresos" ||
          datos[0].toString() == "Egresos") {
        celdas.add(DataCell(Text(datos[0].toString(),
            style: const TextStyle(
                fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))));
      } else {
        celdas.add(DataCell(Text(datos[0].toString())));
      }

      celdas.add(_cellDataFormatted(datos[1]));
      celdas.add(_cellDataFormatted(datos[2]));
      celdas.add(_cellDataFormatted(datos[3]));
      celdas.add(_cellDataFormatted(datos[4]));
    }

    return celdas;
  }

  List<DataRow> _createRows(ingresos, egresos) {
    List<DataRow> renglon = [];
    renglon.add(DataRow(cells: _createCells(["Ingresos", "", "", "", ""])));

    renglon += ingresos.map<DataRow>((ingreso) {
      return DataRow(cells: _createCells(ingreso));
    }).toList();

    renglon.add(DataRow(cells: _createCells(["Egresos", "", "", "", ""])));

    renglon += egresos.map<DataRow>((egreso) {
      return DataRow(cells: _createCells(egreso));
    }).toList();

    return renglon;
  }

  Future<void> gridPDF(data) async {
    developer.log("Estoy en crear pdf", name: "gridPDF");
    //Create a new PDF document
    PdfDocument document = PdfDocument();
    //Create a PdfGrid class
    PdfGrid grid = PdfGrid();

    //Add the columns to the grid
    grid.columns.add(count: 5);
    grid.columns[0].width = 183;
    grid.columns[1].width = 82;
    grid.columns[2].width = 41;
    grid.columns[3].width = 82;
    grid.columns[4].width = 41;

    //Add header to the grid
    grid.headers.add(1);

    //Add values to header
    grid.headers[0].cells[0].value = '';
    grid.headers[0].cells[1].value = 'Periodo';
    grid.headers[0].cells[2].value = '%';
    grid.headers[0].cells[3].value = 'Acumulado';
    grid.headers[0].cells[4].value = '%';

    PdfGridRow curRow1 = grid.rows.add();
    curRow1.cells[0].value = "Ingresos";
    //data.ingreso.length
    for (int i = 0; i < data.ingresos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      curRow.cells[0].value = data.ingresos[i][0].toString();
      curRow.cells[1].value = _stringFormatted(data.ingresos[i][1]);
      curRow.cells[2].value = _stringFormatted(data.ingresos[i][2]);
      curRow.cells[3].value = _stringFormatted(data.ingresos[i][3]);
      curRow.cells[4].value = _stringFormatted(data.ingresos[i][4]);

      for (int i = 1; i < 5; i++) {
        curRow.cells[i].style.stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.right);
      }
    }

    PdfGridRow curRow2 = grid.rows.add();
    curRow2.cells[0].value = "Egresos";

    for (int i = 0; i < data.egresos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      curRow.cells[0].value = _stringFormatted(data.egresos[i][0]);
      curRow.cells[1].value = _stringFormatted(data.egresos[i][1]);
      curRow.cells[2].value = _stringFormatted(data.egresos[i][2]);
      curRow.cells[3].value = _stringFormatted(data.egresos[i][3]);
      curRow.cells[4].value = _stringFormatted(data.egresos[i][4]);

      for (int i = 1; i < 5; i++) {
        curRow.cells[i].style.stringFormat =
            PdfStringFormat(alignment: PdfTextAlignment.right);
      }
    }

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
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
        bytes, "EstadoDeResultados-" + DateTime.now().toString());
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
            onPressed: () => gridPDF(estadoResultados),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.download),
          ),
          body: FutureBuilder<EstadoResultados>(
              future: balance,
              builder: (context, snapshot) {
                EstadoResultados datos = snapshot.data ??
                    EstadoResultados(
                        ingresos: ['', '', '', '', ''],
                        egresos: ['', '', '', '', '']);
                estadoResultados = datos;
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');
                  developer.log(datos.ingresos[0].toString(),
                      name: 'TieneData ingresos');
                  return ListView(children: [
                    SizedBox(height: screenHeight * .05),
                    Center(
                        child: AutoSizeText(
                      "Estado de resultados",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                          decoration: TextDecoration.none),
                      maxLines: 1,
                    )),
                    SizedBox(height: screenHeight * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: const [
                          AutoSizeText('FinRep',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                              maxLines: 1)
                        ]),
                        Column(children: [
                          AutoSizeText(nombreEmpresa, maxLines: 1)
                        ]),
                        Column(children: [
                          AutoSizeText(DateTime.now().toString(), maxLines: 1)
                        ])
                      ],
                    ),
                    SizedBox(height: screenHeight * .12),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Expanded(
                          child: DataTable(columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                '',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Periodo',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '%',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Acumulado',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                '%',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ], rows: _createRows(datos.ingresos, datos.egresos)
                              //rows: createRows(snapshot.data?.ingresos),
                              ),
                        )),
                    SizedBox(height: screenHeight * .05),
                  ]);
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return const ProgressBar();
                }
              })),
    );
  }
}
