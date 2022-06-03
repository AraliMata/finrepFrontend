import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/relaciones_analiticas.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import 'dart:html'; //Para PDF
import 'package:syncfusion_flutter_pdf/pdf.dart'; //Para PDF

class MRelacionesAnaliticas extends StatefulWidget {
  const MRelacionesAnaliticas({Key? key}) : super(key: key);
  @override
  State<MRelacionesAnaliticas> createState() => RelacionesAnaliticasState();
}

class RelacionesAnaliticasState extends State<MRelacionesAnaliticas> {
  late Future<RelacionesAnaliticas> balance;
  late ConvertidorDataTable convertidor;
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

  @override
  void initState() {
    super.initState();
    balance = getRelacionesAnaliticas();
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

  List<DataCell> _createCells(datos) {
    List<DataCell> celdas = [];

    String type = datos[6].toString();
    //String acrdeud = datos[7].toString();
    String acrdeud = "a";

    for (int i = 0; i < 6; i++) {
      Text text = Text(
        datos[i].toString(),
        textAlign: TextAlign.left,
      );
      if (type == "n") {
        if (acrdeud == "a") {
          text = Text(datos[i].toString(),
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold));
        } else {
          text = Text(datos[i].toString(),
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold));
        }
      } else {
        if (acrdeud == "a") {
          text = Text(datos[i].toString(), textAlign: TextAlign.right);
        }
      }

      developer.log(text.textAlign.toString(), name: "texAlign");
      celdas.add(DataCell(text));
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
        .add(count: 2); //Poner el número de columnas (RelacionesAnaliticas: 6)
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

    //LO DE  ANGEL SE QUEDA HASTA AQUI

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
      ..setAttribute("download", "RelacionesAnaliticas.pdf")
      ..click();
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
          body: FutureBuilder<RelacionesAnaliticas>(
              future: balance,
              builder: (context, snapshot) {
                RelacionesAnaliticas datos = snapshot.data ??
                    RelacionesAnaliticas(movimientos: [
                      ['', '', '', '', '', '', '', '']
                    ], totalCuentas: [
                      ['', '', '', '', '', '', '', '']
                    ], sumasIguales: [
                      ['', '', '', '', '', '', '', '']
                    ]);

                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');

                  return ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                    SizedBox(height: screenHeight * .05),
                    Center(
                        child: Text(
                      "Relaciones Analiticas",
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
                        Column(children: const [
                          Text('FinRep',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16))
                        ]),
                        Column(children: const [Text('Empresa 1 S.C')]),
                        Column(children: const [Text('Fecha: 29/Abr/2022')]),
                        Column(children: const [Text('Hola')])
                      ],
                    ),
                    SizedBox(height: screenHeight * .12),
                    FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Expanded(
                      child: DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'Cuenta',
                                style: TextStyle(fontStyle: FontStyle.italic),
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
                              label: Text(
                                'Saldos Iniciales \n Deudor  Acreedor',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold),
                              ),
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
                  ]);
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData55');
                  return const ProgressBar();
                }
              })),
    );
  }
}
