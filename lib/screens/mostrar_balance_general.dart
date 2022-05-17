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

    developer.log(jsonDecode(response.body).toString(), name: 'response');
    developer.log(jsonDecode(jsonDecode(response.body)).runtimeType.toString(),
        name: 'response type');

    final balance =
        BalanceGeneral.fromJson(jsonDecode(jsonDecode(response.body)));

    return balance;
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
                  return Column(children: [
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
                  ]);
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
    List<DataRow> renglones;

    if (type == 'CAPITAL') {
      renglones = convertidor.createRowsBalanceGeneralCapital(data);
    } else {
      renglones = convertidor.createRowsBalanceGeneral(data);
    }

    return DataTable(
      columns: <DataColumn>[
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
      ],
      rows: renglones,
    );
  }
}
