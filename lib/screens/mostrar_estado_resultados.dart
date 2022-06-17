import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/estado_resultados.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'dart:developer' as developer;
import '../model/widgets/general_app_bar.dart';

class MEstadoResultados extends StatefulWidget {
  const MEstadoResultados({Key? key}) : super(key: key);
  @override
  State<MEstadoResultados> createState() => EstadoResultadosState();
}

class EstadoResultadosState extends State<MEstadoResultados> {
  late Future<EstadoResultados> balance;
  late ConvertidorDataTable convertidor;
  late String nombreEmpresa;
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

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
    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/estado-resultados"));

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

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FinRep',
      home: Scaffold(
          appBar: GeneralAppBar(),
          body: FutureBuilder<EstadoResultados>(
              future: balance,
              builder: (context, snapshot) {
                EstadoResultados datos = snapshot.data ??
                    EstadoResultados(
                        ingresos: ['', '', '', '', ''],
                        egresos: ['', '', '', '', '']);
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
                        Column(children: const [
                          Text('FinRep',
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16))
                        ]),
                        Column(children: [Text(nombreEmpresa)]),
                        Column(children: const [Text('Fecha: 29/Abr/2022')])
                      ],
                    ),
                    SizedBox(height: screenHeight * .12),
                    Expanded(
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
                    )
                    //AQUI AGREGAS UN BOTÓN
                  ]);
                  /*return Column(children: [
                    _contentFirstRow(snapshot.data),
                    Expanded(child: _contentDataTable(datos))
                  ]);*/
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return const ProgressBar();
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
        Column(children: [Text(nombreEmpresa)]),
        Column(children: const [Text('Fecha: 29/Abr/2022')]),
        Column(children: const [Text('Hola')])
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
