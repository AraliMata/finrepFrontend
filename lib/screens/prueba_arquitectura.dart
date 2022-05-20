import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_frontend_test/model/value_objects/cuentas.dart';
import '../env.sample.dart';
import '../model/value_objects/employee.dart';
import '../model/value_objects/cuentas.dart';
import 'package:http/http.dart' as http;

class CrearEmpleado extends StatefulWidget {
  const CrearEmpleado({Key? key}) : super(key: key);

  @override
  State<CrearEmpleado> createState() => CrearEmpleadoState();
}

class CrearEmpleadoState extends State<CrearEmpleado> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  // final TextEditingController _controller3 = TextEditingController();
  Future<Employee>? _futureEmployee;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:
              (_futureEmployee == null) ? buildColumn() : buildFutureBuilder(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MostrarEmpleados()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter name'),
        ),
        TextField(
          controller: _controller2,
          decoration: const InputDecoration(hintText: 'Enter email'),
        ),
        // TextField(
        //   controller: _controller3,
        //   decoration: const InputDecoration(hintText: 'Enter nombre'),
        // ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureEmployee =
                  registerEmployee(_controller.text, _controller2.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Employee> buildFutureBuilder() {
    return FutureBuilder<Employee>(
      future: _futureEmployee,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.ename);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

class MostrarEmpleados extends StatefulWidget {
  const MostrarEmpleados({Key? key}) : super(key: key);

  @override
  State<MostrarEmpleados> createState() => MostrarEmpleadosState();
}

//Muestra los empleados
class MostrarEmpleadosState extends State<MostrarEmpleados> {
  late Future<List<Employee>> employees = getEmployeeList();
  final employeeListKey = GlobalKey<MostrarEmpleadosState>();

  Future<List<Employee>> getEmployeeList() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/employeedetails"));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Employee> employees = items.map<Employee>((json) {
      return Employee.fromJson(json);
    }).toList();

    return employees;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: employeeListKey,
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: Center(
        child: FutureBuilder<List<Employee>>(
          future: employees,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return const CircularProgressIndicator();
            // Render employee lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      data.ename,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

//CrearCuenta
class MostrarDatosCuenta extends StatefulWidget {
  const MostrarDatosCuenta({Key? key}) : super(key: key);

  @override
  State<MostrarDatosCuenta> createState() => MostrarDatosCuentaState();
}

class MostrarDatosCuentaState extends State<MostrarDatosCuenta> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  Future<Cuentas>? _futureAccount;
  static const String routeName = "/MyAppState2";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Data Example'),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child:
              (_futureAccount == null) ? buildColumn() : buildFutureBuilder(),
        ),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter empresa'),
        ),
        TextField(
          controller: _controller2,
          decoration: const InputDecoration(hintText: 'Enter codigo'),
        ),
        TextField(
          controller: _controller3,
          decoration: const InputDecoration(hintText: 'Enter nombre'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _futureAccount = registrarCuenta(
                  _controller.text, _controller2.text, _controller3.text);
            });
          },
          child: const Text('Create Data'),
        ),
      ],
    );
  }

  FutureBuilder<Cuentas> buildFutureBuilder() {
    return FutureBuilder<Cuentas>(
      future: _futureAccount,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.nombre);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }
}

Future<Employee> registerEmployee(String name, String email) async {
  final response = await http.post(
    Uri.parse("${Env.URL_PREFIX}/employeedetails"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'ename': name, 'eemail': email}),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Employee.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to register employee.');
  }
}

Future<Cuentas> registrarCuenta(
    String idEmpresa, String codigo, String nombre) async {
  final response = await http.post(
    Uri.parse("${Env.URL_PREFIX}/cuentas"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'idEmpresa': idEmpresa,
      'codigo': codigo,
      'nombre': nombre
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Cuentas.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to register account.');
  }
}
