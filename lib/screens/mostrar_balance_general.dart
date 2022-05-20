import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'dart:developer' as developer;

class MBalanceGeneral extends StatefulWidget {
  const MBalanceGeneral({Key? key}) : super(key: key);
  @override
  State<MBalanceGeneral> createState() => BalanceGeneralState();
}

class BalanceGeneralState extends State<MBalanceGeneral> {
  late Future<BalanceGeneral> balance;
  ConvertidorDataTable convertidor = ConvertidorDataTable();

  @override
  void initState() {
    super.initState();
    balance = getBalanceGeneral();
  }

  Future<BalanceGeneral> getBalanceGeneral() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

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
                  return Column(children: [
                    SizedBox(height: screenHeight * .05),
          Center( child: Text("Balance general", style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
                decoration: TextDecoration.none
              ),)),
          SizedBox(height: screenHeight * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: [
                          Text('FinRep',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 33, 212, 243),
                                  fontSize: 16))
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
                  ]);
                  /*return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(children: const [
                          Text('FinRep',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 33, 212, 243),
                                  fontSize: 16))
                        ]),
                        Column(children: const [Text('Empresa 1 S.C')]),
                        Column(children: const [Text('Fecha: 29/Abr/2022')])
                      ],
                    ),
                    Expanded(child: _contentGridView(snapshot.data))
                  ]);*/
                } else {
                  developer.log('${snapshot.error}', name: 'NoTieneData');
                  return ProgressBar();
                }
              })),
    );
  }

  Widget _contentGridView(data) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 4,
      mainAxisSpacing: 5,
      children: <Widget>[
        _contentDataTable(data.activo, 'ACTIVO'),
        _contentDataTable(data.pasivo, 'PASIVO'),
        const Text(' '),
        _contentDataTable(data.capital, 'CAPITAL'),
      ],
    );

    /*return GridView.extent(
      primary: false,
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.vertical,
      maxCrossAxisExtent: 600,
      crossAxisSpacing: 4,
      mainAxisSpacing: 10,
      children: <Widget>[
        _contentDataTable(data.activo, 'ACTIVO'),
        _contentDataTable(data.pasivo, 'PASIVO'),
        const Text(' '),
        _contentDataTable(data.activo, 'CAPITAL'),
      ],
    );*/

    /*return GridView.builder(
        itemCount: 2,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) =>
            GridTile(child: _contentDataTable(data, index)));*/
  }

  Widget _contentDataTable(data, type) {
    List<DataCell> hola = [];
    hola.add(DataCell(Text("Hola")));
    DataRow row = DataRow(cells: hola);
    List<DataRow> renglones = [row];

    if (type == 'CAPITAL') {
      renglones = convertidor.createRowsBalanceGeneralCapital(data);
    } else {
      renglones = convertidor.createRowsBalanceGeneral(data);
    }

    return DataTable(columns: <DataColumn>[
      DataColumn(
        label: Text(
          type,
          style: const TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
      ),
      const DataColumn(
        label: Text(
          '',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    ], rows: renglones
        //renglones,
        );
  }
}
