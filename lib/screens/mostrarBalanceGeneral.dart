import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/models/ActivoPasivo.dart';
import 'package:flutter_frontend_test/models/BalanceGeneral.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'dart:developer' as developer;

class MBalanceGeneral extends StatefulWidget {
  const MBalanceGeneral({Key? key}) : super(key: key);
  @override
  State<MBalanceGeneral> createState() => BalanceGeneralState();
}

class BalanceGeneralState extends State<MBalanceGeneral> {
  Future<BalanceGeneral> getBalanceGeneral() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

    final balanceGeneral =
        json.decode(response.body).cast<Map<String, dynamic>>();

    BalanceGeneral balance = balanceGeneral.map<BalanceGeneral>((json) {
      return BalanceGeneral.fromJson(json);
    });

    developer.log(balanceGeneral, name: 'balanceGeneraltqm');

    return balance;
  }

  /*Future<List<Employee>> getEmployeeList() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/employeedetails"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Employee> employees = items.map<Employee>((json) {
      return Employee.fromJson(json);
    }).toList();

    return employees;
  }*/
  late Future<BalanceGeneral> balance = getBalanceGeneral();

//late Future<List<Employee>> employees = getEmployeeList();

//Tomar lista ACTIVO
  //late Future<ActivoPasivo> activo = getActivo();
//Tomar lista PASIVO
//Tomar lista CAPITAL

  static const title = "Hola";
  static const renglon = DataRow(cells: <DataCell>[
    DataCell(Text('Sarah')),
    DataCell(Text('19')),
  ]);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: [
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'ACTIVO',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  renglon,
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Janine')),
                      DataCell(Text('43')),
                    ],
                  ),
                ],
              ),
              DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text(
                      'PASIVO',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      '',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
                rows: const <DataRow>[
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Sarah')),
                      DataCell(Text('19')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text('Janine')),
                      DataCell(Text('43')),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
