import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/estado_resultados.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/screens/elegirPeriodoER.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../../env.sample.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import 'dart:html'; //Para PDF
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../model/widgets/simple_elevated_button.dart';
import '../model/widgets/general_app_bar.dart';

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

  List<DataCell> _createCells(datos) {
    List<DataCell> celdas = [];
    if (datos[1] == 0 && datos[2] == 0 && datos[3] == 0 && datos[4] == 0) {
      celdas.add(DataCell(Text(datos[0].toString())));
      for (int i = 1; i < 5; i++) {
        celdas.add(const DataCell(Text('')));
      }
    } else {
      for (int i = 0; i < 5; i++) {
        if (datos[i].toString() == "Total Ingresos" ||
            datos[i].toString() == "Total Egresos" ||
            datos[i].toString() == "Ingresos" ||
            datos[i].toString() == "Egresos") {
          celdas.add(DataCell(Text(datos[i].toString(),
              style: const TextStyle(
                  fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))));
        } else {
          celdas.add(DataCell(Text(datos[i].toString())));
        }
      }
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

  //FUNCIÓN QUE ARMA EL PDF Y LO DESCARGA
  gridPDF(data) {
    //Create a new PDF document
    PdfDocument document = PdfDocument();
//Create a PdfGrid class
    PdfGrid grid = PdfGrid(); // Creación de la tabla
    // PdfGrid activoGrid = PdfGrid();
    // PdfGrid pasivoGrid = PdfGrid();
    // PdfGrid capitalGrid = PdfGrid();
//Add the columns to the grid
    grid.columns
        .add(count: 5); //Poner el número de columnas (Estado de resultados: 5)
    grid.columns[0].width = 183;
    grid.columns[1].width = 82;
    grid.columns[2].width = 41;
    grid.columns[3].width = 82;
    grid.columns[4].width = 41;
    //activoGrid.columns.add(count: 2);
    //pasivoGrid.columns.add(count: 2);
    //capitalGrid.columns.add(count: 2);
//Add header to the grid
    grid.headers.add(1);
    // activoGrid.headers.add(1); Agregar un header
    // pasivoGrid.headers.add(1);
    // capitalGrid.headers.add(1);
//Add values to header
    grid.headers[0].cells[0].value = '';
    grid.headers[0].cells[1].value = 'Periodo';
    grid.headers[0].cells[2].value = '%';
    grid.headers[0].cells[3].value = 'Acumulado';
    grid.headers[0].cells[4].value = '%';
    //pasivoGrid.headers[0].cells[0].value = 'PASIVO';
    //capitalGrid.headers[0].cells[0].value = 'CAPITAL';

    PdfGridRow curRow1 = grid.rows.add();
    curRow1.cells[0].value = "Ingresos";
    //data.ingreso.length
    for (int i = 0; i < data.ingresos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.ingresos[i][0].toString();
      curRow.cells[1].value = data.ingresos[i][1].toString();
      curRow.cells[2].value = data.ingresos[i][2].toString();
      curRow.cells[3].value = data.ingresos[i][3].toString();
      curRow.cells[4].value = data.ingresos[i][4].toString();
    }

    PdfGridRow curRow2 = grid.rows.add();
    curRow2.cells[0].value = "Egresos";
    for (int i = 0; i < data.egresos.length; i++) {
      PdfGridRow curRow = grid.rows.add();
      //data.ingreso[i][0] data.ingreso[i][1] data.ingreso[i][2]
      curRow.cells[0].value = data.egresos[i][0].toString();
      curRow.cells[1].value = data.egresos[i][1].toString();
      curRow.cells[2].value = data.egresos[i][2].toString();
      curRow.cells[3].value = data.egresos[i][3].toString();
      curRow.cells[4].value = data.egresos[i][4].toString();
    }

//AQUI VUELVES A GUIARTE

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

    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "Estado-de-resultados.pdf")
      ..click();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
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
                        child: Text(
                      "Estado de resultados",
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
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16))
                        ]),
                        Column(children: [Text(nombreEmpresa)]),
                        Column(children: [Text('Fecha: 29/Abr/2022')])
                      ],
                    ),
                    SizedBox(height: screenHeight * .12),
                    FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Expanded(
                          child: DataTable(columns: const <DataColumn>[
                            /*DataColumn(
                          label: Text(
                            'Ingresos',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),*/
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
                    /*Center(
                        child: SimpleElevatedButton(
                            child: const Text("Descargar estado de resultados"),
                            color: Colors.blue,
                            onPressed: () => gridPDF(snapshot.data)))*/
                  ]);
                  /*return Column(children: [
                    _contentFirstRow(snapshot.data),
                    Expanded(child: _contentDataTable(datos))
                  ]);*/
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return ProgressBar();
                }
              })),
    );
  }

  Widget _contentFirstRow(data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(children: const [
          Text('FinRep',
              style: TextStyle(
                  color: Color.fromARGB(255, 33, 212, 243), fontSize: 16))
        ]),
        Column(children: [Text('Empresa 1 S.C')]),
        Column(children: [Text('Fecha: 29/Abr/2022')])
      ],
    );
  }

  Widget _contentDataTable(data) {
    return DataTable(
      columns: const <DataColumn>[
        DataColumn(label: Text('')),
        DataColumn(
            label: Text(
          'Periodo',
          style: TextStyle(fontStyle: FontStyle.italic),
        )),
        DataColumn(
            label: Text(
          '%',
          style: TextStyle(fontStyle: FontStyle.italic),
        )),
        DataColumn(
            label: Text(
          'Acumulado',
          style: TextStyle(fontStyle: FontStyle.italic),
        )),
        DataColumn(
            label: Text(
          '%',
          style: TextStyle(fontStyle: FontStyle.italic),
        ))
      ],
      rows: convertidor.createRowsEstadoGeneral(data),
    );
  }
}
