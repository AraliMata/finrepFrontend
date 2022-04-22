import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/models/cuentas.dart';
import 'package:toggle_bar/toggle_bar.dart';
import './uploadingscreen.dart';
import './card_textfield.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

import '../env.sample.dart';
import '../models/employee.dart';
import '../models/cuentas.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class HomeState extends State<Home> {
  late Future<List<Employee>> employees = getEmployeeList();
  final employeeListKey = GlobalKey<HomeState>();
/* 
  @override
  void initState() {
    super.initState();
    employees = getEmployeeList();
  }
 */

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
        title: Text('Employee List'),
      ),
      body: Center(
        child: FutureBuilder<List<Employee>>(
          future: employees,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // By default, show a loading spinner.
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Render employee lists
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var data = snapshot.data[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      data.ename,
                      style: TextStyle(fontSize: 20),
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

// class Register extends StatefulWidget {
//   const Register({Key? key}) : super(key: key);
//   @override
//   MyAppState createState() => MyAppState();
// }

class MyAppState extends State<Home> {
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

class MyAppState2 extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  Future<Cuentas>? _futureAccount;

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

class _MyHomePageState extends State<MyHomePage> {
  List<String> labels = ["Phone", "Video", "Audio", "Document"];
  int currentIndex = 0;
  String tit = 'Upload File';
  String sub = 'Browse and chose the files you want to upload.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UploadScreen(1, '1', tit, sub)));
          },
          backgroundColor: Colors.amber,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {},
                ),
                Container(
                    width: 125.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.filter_list),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                          onPressed: () {},
                        )
                      ],
                    ))
              ],
            ),
          ),
          SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.only(left: 40.0),
            child: Row(
              children: <Widget>[
                Flexible(
                  child: email,
                  fit: FlexFit.tight,
                ),
                SizedBox(width: 10.0),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
              height: MediaQuery.of(context).size.height - 185.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(75.0),
                    topRight: Radius.circular(75.0)),
              ),
              child: ListView(
                  primary: false,
                  padding: EdgeInsets.all(0.0),
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(top: 45.0),
                        child: Container(
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ToggleBar(
                                    labels: labels,
                                    textColor: Colors.black,
                                    backgroundColor: Colors.transparent,
                                    labelTextStyle:
                                        TextStyle(fontWeight: FontWeight.w500),
                                    selectedTextColor: Colors.black,
                                    selectedTabColor: Colors.amber,
                                    onSelectionUpdated: (index) =>
                                        setState(() => currentIndex = index),
                                  ),
                                  Expanded(
                                    child: GridView.count(
                                      crossAxisCount: 2,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.all(25),
                                      children: <Widget>[
                                        const MyCard(
                                            Colors.amber, 'Voice recording'),
                                        const MyCard(
                                            Colors.amberAccent, 'Rehersals'),
                                        const MyCard(Colors.grey, 'Audio'),
                                      ],
                                    ),
                                  )
                                ]))),
                  ])),
        ]));
  }
}
