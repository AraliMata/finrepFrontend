import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/models/BalanceGeneral.dart';
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

  @override
  void initState() {
    super.initState();
    balance = getBalanceGeneral();
  }

  Future<BalanceGeneral> getBalanceGeneral() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

    developer.log(jsonDecode(response.body).toString(), name: 'response');
    developer.log(jsonDecode(jsonDecode(response.body)).runtimeType.toString(),
        name: 'response type');

    final balance =
        BalanceGeneral.fromJson(jsonDecode(jsonDecode(response.body)));

    developer.log(balance.toString(), name: 'balanceGeneraltqm');

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
      DataRow curRow = createRow(datos.circulante[i]);
      renglones.add(curRow);
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
    return MaterialApp(
      title: 'FinRep',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Balance general'),
          ),
          body: FutureBuilder<BalanceGeneral>(
              future: balance,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');
                  return GridView.count(
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: 2,
                      children: [
                        DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'ACTIVO',
                                style: TextStyle(fontStyle: FontStyle.normal),
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
                                style: TextStyle(fontStyle: FontStyle.normal),
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
                        DataTable(
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'CAPITAL',
                                style: TextStyle(fontStyle: FontStyle.normal),
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
                      ]);
                } else {
                  developer.log('Uno', name: 'NoTieneData');
                  return Text('${snapshot.error}');
                }
              })),
    );
  }
}
