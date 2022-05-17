import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/estado_resultados.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'dart:developer' as developer;

class MEstadoResultados extends StatefulWidget {
  const MEstadoResultados({Key? key}) : super(key: key);
  @override
  State<MEstadoResultados> createState() => EstadoResultadosState();
}

class EstadoResultadosState extends State<MEstadoResultados> {
  late Future<EstadoResultados> balance;
  late ConvertidorDataTable convertidor;

  @override
  void initState() {
    super.initState();
    balance = getEstadoResultados();
  }

  Future<EstadoResultados> getEstadoResultados() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/EstadoResultados"));

    final estadoResultados =
        EstadoResultados.fromJson(jsonDecode(jsonDecode(response.body)));

    return estadoResultados;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinRep',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Balance general'),
          ),
          body: FutureBuilder<EstadoResultados>(
              future: balance,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  developer.log('Uno', name: 'TieneData');
                  return Column(children: [
                    _contentFirstRow(snapshot.data),
                    Expanded(child: _contentDataTable(snapshot.data))
                  ]);
                } else {
                  developer.log('Uno', name: 'NoTieneData');
                  return Text('${snapshot.error}');
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
