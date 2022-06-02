import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'dart:developer' as developer;
import 'dart:convert';
import 'dart:html'; //Para PDF
import 'package:syncfusion_flutter_pdf/pdf.dart'; //Para PDF
import 'package:get/get.dart';

class MBalanceGeneral extends StatefulWidget {
  const MBalanceGeneral({Key? key}) : super(key: key);
  @override
  State<MBalanceGeneral> createState() => BalanceGeneralState();
}

class BalanceGeneralState extends State<MBalanceGeneral> {
  late Future<BalanceGeneral> balance;
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

  @override
  void initState() {
    super.initState();
    balance = getBalanceGeneral();
  }

  Future<BalanceGeneral> getBalanceGeneral() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    developer.log(idEmpresa.toString(),
        name: 'idEmpresaDentrodeBalanceGeneral');

    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/balance-general"));
    // await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

    developer.log(jsonDecode(response.body).toString(), name: 'response18');
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

    celdas.add(DataCell(Text(datos[0])));
    celdas.add(DataCell(Text(datos[1])));

    DataRow renglon = DataRow(cells: celdas);

    return renglon;
  }

  List<DataRow> createRows(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CIRCULANTE', ' ']));
    for (int i = 0; i < datos.circulante.length; i++) {
      if (datos.circulante[i][0] != '') {
        DataRow curRow = createRow(datos.circulante[i]);
        renglones.add(curRow);
      }
    }

    renglones.add(createRow(['FIJO', ' ']));
    for (int i = 0; i < datos.fijo.length; i++) {
      DataRow curRow = createRow(datos.fijo[i]);
      renglones.add(curRow);
    }

    renglones.add(createRow(['DIFERIDO', ' ']));
    for (int i = 0; i < datos.diferido.length; i++) {
      DataRow curRow = createRow(datos.diferido[i]);
      renglones.add(curRow);
    }

    return renglones;
  }

  List<DataRow> createRowsCapital(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CAPITAL', ' ']));
    for (int i = 0; i < datos.capital.length; i++) {
      DataRow curRow = createRow(datos.capital[i]);
      renglones.add(curRow);
    }

    return renglones;
  }

  //FUNCTIÓN QUE ARMA EL PDF Y LO DESCARGA
  gridsillo(data) {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
//Create a PdfGrid class
    PdfGrid grid = PdfGrid(); // Creación de la tabla
    PdfGrid activoGrid = PdfGrid();
    PdfGrid pasivoGrid = PdfGrid();
    PdfGrid capitalGrid = PdfGrid();
//Add the columns to the grid
    grid.columns
        .add(count: 2); //Poner el número de columnas (Estado de resultados: 5)
    activoGrid.columns.add(count: 2);
    pasivoGrid.columns.add(count: 2);
    capitalGrid.columns.add(count: 2);
//Add header to the grid
    //grid.headers.add(1);
    activoGrid.headers.add(1); //Agregar un header
    pasivoGrid.headers.add(1);
    capitalGrid.headers.add(1);
//Add values to header
    activoGrid.headers[0].cells[0].value = 'ACTIVO';
    pasivoGrid.headers[0].cells[0].value = 'PASIVO';
    capitalGrid.headers[0].cells[0].value = 'CAPITAL';

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Circulante";
    //data.ingreso.length
    for (int i = 0; i < data.activo.circulante.length; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.activo.circulante[i][0];
      curRow.cells[1].value = data.activo.circulante[i][1];
    }

    //LO DE ISAAC QUEDA HASTA AQUI

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Fijo";

    for (int i = 0; i < data.activo.fijo.length; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      curRow.cells[0].value = data.activo.fijo[i][0];
      curRow.cells[1].value = data.activo.fijo[i][1];
    }

    activoGrid.rows.add();
    activoGrid.rows[0].cells[0].value = "Diferido";

    for (int i = 0; i < data.activo.diferido.length; i++) {
      PdfGridRow curRow = activoGrid.rows.add();
      curRow.cells[0].value = data.activo.diferido[i][0];
      curRow.cells[1].value = data.activo.diferido[i][1];
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Circulante";

    for (int i = 0; i < data.pasivo.circulante.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.circulante[i][0];
      curRow.cells[1].value = data.pasivo.circulante[i][1];
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Fijo";

    for (int i = 0; i < data.pasivo.fijo.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.fijo[i][0];
      curRow.cells[1].value = data.pasivo.fijo[i][1];
    }

    pasivoGrid.rows.add();
    pasivoGrid.rows[0].cells[0].value = "Diferido";

    for (int i = 0; i < data.pasivo.diferido.length; i++) {
      PdfGridRow curRow = pasivoGrid.rows.add();
      curRow.cells[0].value = data.pasivo.diferido[i][0];
      curRow.cells[1].value = data.pasivo.diferido[i][1];
    }

    capitalGrid.rows.add();
    capitalGrid.rows[0].cells[0].value = "Capital";

    for (int i = 0; i < data.capital.capital.length; i++) {
      PdfGridRow curRow = capitalGrid.rows.add();
      curRow.cells[0].value = data.capital.capital[i][0];
      curRow.cells[1].value = data.capital.capital[i][1];
    }

//Add rows to grid
    PdfGridRow row = grid.rows.add();
    row.cells[0].value = activoGrid;
    row.cells[1].value = pasivoGrid;
    row = grid.rows.add();
    row.cells[0].value = '';
    row.cells[1].value = capitalGrid;

//Set the grid style
//AQUI VUELVES A GUIARTE

    grid.style = PdfGridStyle(
        cellPadding: PdfPaddings(left: 2, right: 3, top: 4, bottom: 5),
        backgroundBrush: PdfBrushes.white,
        textBrush: PdfBrushes.black,
        borderOverlapStyle: PdfBorderOverlapStyle.inside,
        font: PdfStandardFont(PdfFontFamily.timesRoman, 25));
//Draw the grid
    grid.draw(page: document.pages.add(), bounds: Rect.zero);
//Save the document.
    List<int> bytes = document.save();
//Dispose the document.
    document.dispose();

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "Balance General.pdf")
      ..click();
  }

  dynamic _getBalanceGeneral(screenHeight, context, snapshot) {
    return [
      SizedBox(height: screenHeight * .05),
      Center(
          child: Text(
        "Balance general ",
        style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
            decoration: TextDecoration.none),
      )),
      SizedBox(height: screenHeight * .05),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(children: [
            Text('FinRep',
                style: TextStyle(
                    color: Color.fromARGB(255, 33, 212, 243), fontSize: 16))
          ]),
          Column(children: [Text('Empresa 1 S.C')]),
          Column(children: [Text('Fecha: 29/Abr/2022')])
        ],
      ),
      Expanded(
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              shrinkWrap: true,
              children: [
            DataTable(
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
              rows: createRows(snapshot.data!.activo),
            ),
            DataTable(
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
            ),
            DataTable(columns: const <DataColumn>[
              DataColumn(label: Text(' '))
            ], rows: const <DataRow>[
              DataRow(cells: <DataCell>[DataCell(Text(' '))])
            ]),
            DataTable(
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
            ),
          ]))
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      title: 'FinRep',
      home: Scaffold(
          /*appBar: AppBar(
            title: const Text('Balance general'),
          )*/
          body: FutureBuilder<BalanceGeneral>(
              future: balance,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');
                  return Column(
                      children:
                          _getBalanceGeneral(screenHeight, context, snapshot) +
                              [
                                SimpleElevatedButton(
                                  child: const Text("Crear pdf falso"),
                                  color: Colors.blue,
                                  onPressed: () => gridsillo(snapshot.data),
                                  //getPDF(screenHeight, snapshot),
                                ),
                                const SizedBox(height: 25),
                                SimpleElevatedButton(
                                  child: const Text("Volver"),
                                  color: Colors.red,
                                  onPressed: () => Get.back(),
                                  //getPDF(screenHeight, snapshot),
                                ),
                                const SizedBox(height: 25),
                              ]);
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return const ProgressBar();
                }
              })),
    );
  }
}
