import 'dart:convert';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'package:flutter_frontend_test/screens/elegir_periodo_bg.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import '../model/value_objects/activo_pasivo.dart';
import '../model/value_objects/capital.dart';
import '../model/widgets/general_app_bar.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; //Para PDF
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:archive/archive.dart';
import 'package:flutter_frontend_test/model/tools/normal_lib.dart' // Stub implementation
    if (dart.library.js) 'package:flutter_frontend_test/model/tools/web_libs.dart'
    if (dart.library.io) 'package:flutter_frontend_test/model/tools/mobile_libs.dart';

class MBalanceGeneral extends StatefulWidget {
  const MBalanceGeneral({Key? key}) : super(key: key);
  @override
  State<MBalanceGeneral> createState() => BalanceGeneralState();
}

class BalanceGeneralState extends State<MBalanceGeneral> {
  late Future<BalanceGeneral> balance;
  late BalanceGeneral balanceGeneral;
  late String nombreEmpresa;
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();
  ElegirPeriodoBGState elegirPeriodoData = ElegirPeriodoBGState();

  @override
  void initState() {
    super.initState();
    balance = getBalanceGeneral();
    getNombreDeEmpresa();
  }

  Future<void> getNombreDeEmpresa() async {
    nombreEmpresa = await elegirEmpresaData.getNombreEmpresa();
  }

  Future<BalanceGeneral> getBalanceGeneral() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    var periodo = await elegirPeriodoData.getMonth();
    developer.log(idEmpresa.toString(),
        name: 'idEmpresaDentrodeBalanceGeneral');

    developer.log(periodo.toString(), name: 'periodoDentrodeBalanceGeneral');

    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/$periodo/balance-general"));

    // await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

    developer.log(response.body.runtimeType.toString(), name: 'response18');
    developer.log(jsonDecode(response.body).runtimeType.toString(),
        name: 'response type');

    final balance = BalanceGeneral.fromJson(jsonDecode(response.body));

    developer.log(balance.runtimeType.toString(), name: "paso");
    developer.log(balance.activo.circulante[1][0].toString(),
        name: "Mostrar balance");

    return balance;
  }

  DataRow createRow(datos) {
    List<DataCell> celdas = [];

    if (datos[0].runtimeType.toString() == 'List<dynamic>') {
      datos[0] = datos[0][0];
    }

    celdas.add(DataCell(
        Align(alignment: Alignment.centerLeft, child: Text(datos[0]))));
    //celdas.add(DataCell(Text(datos[1])));

    var f = NumberFormat("#,##0.00", "en_US");
    var n = NumberFormat("-#,##0.00", "en_US");

    if (datos[1].runtimeType.toString() == "String") {
      celdas.add(DataCell(
          Align(alignment: Alignment.centerRight, child: Text(datos[1]))));
    } else {
      if (datos[1] < 0.0) {
        celdas.add(DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(n.format(datos[1].abs()),
                style: const TextStyle(color: Colors.red)))));
      } else {
        celdas.add(DataCell(Align(
            alignment: Alignment.centerRight,
            child: Text(f.format(datos[1])))));
      }
    }

    DataRow renglon = DataRow(cells: celdas);

    return renglon;
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

  List<DataRow> createRows(datos) {
    List<DataRow> renglones = [];

    developer.log(datos.circulante.toString(), name: "Entré create rows");
    developer.log(datos.fijo.toString(), name: "Entré create rows");
    developer.log(datos.diferido[2].toString(), name: "Entré create rows");

    renglones.add(createRow(['CIRCULANTE', ' ']));
    for (int i = 0; i < datos.circulante.length; i++) {
      if (datos.circulante[i][0] != '') {
        DataRow curRow = createRow(datos.circulante[i]);
        renglones.add(curRow);
      }
    }

    renglones.add(createRow(['', '']));
    renglones.add(createRow(['FIJO', ' ']));
    for (int i = 0; i < datos.fijo.length; i++) {
      if (datos.circulante[i][0] != '') {
        DataRow curRow = createRow(datos.fijo[i]);
        renglones.add(curRow);
      }
    }

    renglones.add(createRow(['', '']));
    renglones.add(createRow(['DIFERIDO', ' ']));
    for (int i = 0; i < datos.diferido.length; i++) {
      if (datos.circulante[i][0] != '') {
        DataRow curRow = createRow(datos.diferido[i]);
        renglones.add(curRow);
      }
    }

    return renglones;
  }

  List<DataRow> createRowsCapital(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CAPITAL', ' ']));
    for (int i = 0; i < datos.capital.length; i++) {
      if (datos.capital[i][0] != '') {
        DataRow curRow;

        curRow = createRow(datos.capital[i]);

        renglones.add(curRow);
      }
    }

    return renglones;
  }

  //FUNCTIÓN QUE ARMA EL PDF Y LO DESCARGA
  Future<void> gridsillo(data) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
//Create a PdfGrid class
    PdfGrid grid = PdfGrid(); // Creación de la tabla
    PdfGrid activoGrid = PdfGrid();
    PdfGrid pasivoGrid = PdfGrid();
    PdfGrid capitalGrid = PdfGrid();
    PdfGrid totalActivoGrid = PdfGrid();
//Add the columns to the grid
    grid.columns
        .add(count: 2); //Poner el número de columnas (Estado de resultados: 5)
    activoGrid.columns.add(count: 2);
    pasivoGrid.columns.add(count: 2);
    capitalGrid.columns.add(count: 2);
    totalActivoGrid.columns.add(count: 2);
//Add header to the grid
    //grid.headers.add(1);
    activoGrid.headers.add(1); //Agregar un header
    pasivoGrid.headers.add(1);
    capitalGrid.headers.add(1);
    totalActivoGrid.headers.add(1);
//Add values to header
    PdfBorders border = PdfBorders(
        left: PdfPen(PdfColor(0, 0, 0), width: 0),
        top: PdfPen(PdfColor(0, 0, 0), width: 0),
        bottom: PdfPen(PdfColor(0, 0, 0), width: 0),
        right: PdfPen(PdfColor(0, 0, 0), width: 0));

    //Create a cell style
    PdfGridCellStyle cellStyle = PdfGridCellStyle(
      borders: border,
    );

    activoGrid.headers[0].cells[0].value = 'ACTIVO';
    pasivoGrid.headers[0].cells[0].value = 'PASIVO';
    capitalGrid.headers[0].cells[0].value = 'CAPITAL';
    totalActivoGrid.headers[0].cells[0].value = ' ';

    activoGrid.headers[0].cells[0].style = cellStyle;
    pasivoGrid.headers[0].cells[0].style = cellStyle;
    capitalGrid.headers[0].cells[0].style = cellStyle;
    totalActivoGrid.headers[0].cells[0].style = cellStyle;

    activoGrid.headers[0].cells[1].style = cellStyle;
    pasivoGrid.headers[0].cells[1].style = cellStyle;
    capitalGrid.headers[0].cells[1].style = cellStyle;
    totalActivoGrid.headers[0].cells[1].style = cellStyle;

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Circulante";
    activoGrid.rows[0].cells[0].style = cellStyle;
    activoGrid.rows[0].cells[1].style = cellStyle;
    //data.ingreso.length
    for (int i = 0; i < data.activo.circulante.length; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.activo.circulante[i][0];
      curRow.cells[1].value = _stringFormatted(data.activo.circulante[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    //LO DE ISAAC QUEDA HASTA AQUI

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Fijo";
    activoGrid.rows[0].cells[0].style = cellStyle;
    activoGrid.rows[0].cells[1].style = cellStyle;

    for (int i = 0; i < data.activo.fijo.length; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      curRow.cells[0].value = data.activo.fijo[i][0];
      curRow.cells[1].value = _stringFormatted(data.activo.fijo[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Diferido";
    activoGrid.rows[0].cells[0].style = cellStyle;
    activoGrid.rows[0].cells[1].style = cellStyle;

    for (int i = 0; i < data.activo.diferido.length - 1; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      curRow.cells[0].value = data.activo.diferido[i][0];
      curRow.cells[1].value = _stringFormatted(data.activo.diferido[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Circulante";
    pasivoGrid.rows[0].cells[0].style = cellStyle;
    pasivoGrid.rows[0].cells[1].style = cellStyle;

    for (int i = 0; i < data.pasivo.circulante.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.circulante[i][0];
      curRow.cells[1].value = _stringFormatted(data.pasivo.circulante[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Fijo";
    pasivoGrid.rows[0].cells[0].style = cellStyle;
    pasivoGrid.rows[0].cells[1].style = cellStyle;

    for (int i = 0; i < data.pasivo.fijo.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.fijo[i][0];
      curRow.cells[1].value = _stringFormatted(data.pasivo.fijo[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Diferido";
    pasivoGrid.rows[0].cells[0].style = cellStyle;
    pasivoGrid.rows[0].cells[1].style = cellStyle;

    for (int i = 0; i < data.pasivo.diferido.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.diferido[i][0];
      curRow.cells[1].value = _stringFormatted(data.pasivo.diferido[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

    totalActivoGrid.rows.add();
    totalActivoGrid.rows[0].cells[0].value = ' ';
    totalActivoGrid.rows[0].cells[0].style = cellStyle;
    totalActivoGrid.rows[0].cells[1].style = cellStyle;

    capitalGrid.rows.add();
    capitalGrid.rows[0].cells[0].value = "Capital";
    capitalGrid.rows[0].cells[0].style = cellStyle;
    capitalGrid.rows[0].cells[1].style = cellStyle;
    developer.log(
        data.activo.diferido[data.activo.diferido.length - 1][0].toString(),
        name: "buenas");

    for (int i = 0; i < data.capital.capital.length; i++) {
      PdfGridRow curTotalRow = totalActivoGrid.rows.add();
      if (data.capital.capital.length - 1 == i) {
        developer.log("entroooo", name: "buenas");
        curTotalRow.cells[0].value =
            data.activo.diferido[data.activo.diferido.length - 1][0];
        curTotalRow.cells[1].value = _stringFormatted(
            data.activo.diferido[data.activo.diferido.length - 1][1]);
      } else {
        curTotalRow.cells[0].value = ' ';
        curTotalRow.cells[1].value = ' ';
      }

      curTotalRow.cells[0].style = cellStyle;
      curTotalRow.cells[1].style = cellStyle;

      PdfGridRow curRow = capitalGrid.rows.add();
      curRow.cells[0].value = data.capital.capital[i][0];
      curRow.cells[1].value = _stringFormatted(data.capital.capital[i][1]);

      curRow.cells[0].style = cellStyle;
      curRow.cells[1].style = cellStyle;
    }

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = activoGrid;
    row.cells[1].value = pasivoGrid;

    row.cells[0].style = cellStyle;
    row.cells[1].style = cellStyle;

    row = grid.rows.add();
    row.cells[0].value = totalActivoGrid;
    row.cells[1].value = capitalGrid;

    row.cells[0].style = cellStyle;
    row.cells[1].style = cellStyle;
//Set the grid style
//AQUI VUELVES A GUIARTE

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        borderOverlapStyle: PdfBorderOverlapStyle.overlap,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
//Draw the grid
    grid.draw(page: document.pages.add(), bounds: Rect.zero);
//Save the document.
    List<int> bytes = document.save();
//Dispose the document.
    document.dispose();

    developer.log("hi", name: "llamarAldescargarpdf");
    await WebFuncts.downloadPdf(
        bytes, "BalanceGeneral-" + DateTime.now().toString());

    developer.log("hi", name: "terminó");
  }

  dynamic _getBalanceGeneral(
      screenHeight, screenWidth, context, snapshot, temp) {
    return [
      SizedBox(height: screenHeight * .05),
      Center(
          child: AutoSizeText(
        "Balance general ",
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
                style: TextStyle(
                    color: Color.fromARGB(255, 33, 212, 243), fontSize: 16),
                maxLines: 1)
          ]),
          Column(children: [AutoSizeText(nombreEmpresa, maxLines: 1)]),
          // Column(children: [Text('Empresa 1 S.C')]),
          Column(
              children: [AutoSizeText(DateTime.now().toString(), maxLines: 1)])
        ],
      ),
      SizedBox(height: screenHeight * .05),
      Expanded(
          child: ListView(children: [
        Row(children: [
          SizedBox(
              width: screenWidth / 2,
              child: 
              FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'ACTIVO',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    //rows: createRows(snapshot.data!.activo),
                    rows: createRows(snapshot.data!.activo)
                  ))
                  ),
          SizedBox(
              width: screenWidth / 2,
              child: 
              FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'PASIVO',
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: createRows(snapshot.data!.pasivo),
                  ))
                  )
        ]),
        Row(children: [
          SizedBox(
            width: screenWidth / 2,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.topCenter,
                child: DataTable(columns: const <DataColumn>[
                  DataColumn(label: Text('')),
                  DataColumn(label: Text(''))
                ], rows: const [
                  DataRow(cells: [DataCell(Text('')), DataCell(Text(''))])
                ])),
          ),
          SizedBox(
            width: screenWidth / 2,
            child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomCenter,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text(
                        'CAPITAL',
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        '',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                  rows: createRowsCapital(snapshot.data!.capital),
                )),
          )
        ])
      ]
      )),
      SizedBox(height: screenHeight * 0.05)
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinRep',
      home: Scaffold(
          appBar: GeneralAppBar(),
          floatingActionButton: FloatingActionButton(
            onPressed: () => gridsillo(balanceGeneral),
            backgroundColor: Colors.blue,
            child: const Icon(Icons.download),
          ),
          body: FutureBuilder<BalanceGeneral>(
              future: balance,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');
                  ActivoPasivo activo = ActivoPasivo(circulante: [
                    ['', 0]
                  ], fijo: [
                    ['', 0]
                  ], diferido: [
                    ['', 0]
                  ]);

                  BalanceGeneral temp = BalanceGeneral(
                      activo: activo,
                      pasivo: activo,
                      capital: Capital(capital: [
                        ['', 0]
                      ]));

                  balanceGeneral = snapshot.data ?? temp;
                  return Column(
                      children: _getBalanceGeneral(
                          screenHeight, screenWidth, context, snapshot, temp));
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return const ProgressBar();
                }
              })),
    );
  }
}
