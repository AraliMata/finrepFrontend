import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend_test/models/cuentas.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;
import '../env.sample.dart';
import '../models/employee.dart';
import '../models/cuentas.dart';

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
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

/* 
Future<Cuentas> subirArchivo(File file) async {
  var request =
      http.MultipartRequest("POST", Uri.parse("${Env.URL_PREFIX}/movimientos"));
  request.fields['xfile'] = "xfile";
  request.files.add(http.MultipartFile.fromBytes('xfile', [file]));
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
  */

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
  Future<String> subirArchivo(FilePickerResult file, String url) async {
    final fileReadStream = file.files.first.readStream;
    if (fileReadStream == null) {
      throw Exception('Cannot read file from null stream');
    }
    final stream = http.ByteStream(fileReadStream);
    developer.log(stream.toString(), name: 'stream2');
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(http.MultipartFile('file', stream, file.files.first.size,
        // 'picture', file.files.first.b,
        filename: file.files.first.name.split("/").last));
    var res = await request.send();
    developer.log(res.reasonPhrase! + "es el res", name: 'my.app.category');

    return res.reasonPhrase!;
  }

  String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  File? _file;
  PlatformFile? _platformFile;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'jpg', 'jpeg'],
      withReadStream: true,
    );

    // final fileReadStream = file?.files.first.readStream;
    // if (fileReadStream == null) {
    //   throw Exception('Cannot read file from null stream');
    // }
    // final stream = http.ByteStream(fileReadStream);
    // developer.log(stream.toString(), name: 'stream2');
    subirArchivo(file!, "${Env.URL_PREFIX}/xlsx");
    if (file != null) {
      print("holis");
      developer.log('log me', name: 'my.app.category');
      developer.log(file.files[0].name, name: 'my.app.category');
      developer.log(file.files.first.bytes.toString(), name: 'bites');
      developer.log(file.files.first.readStream.toString(), name: 'stream');
      developer.log(file.toString(), name: 'my.app.category');
      print(file.files.single.path!);
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }
    loadingController.forward();
  }

  @override
  void initState() {
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  //////////////////////////////////
  /// @theflutterlover on Instagram
  ///
  /// https://afgprogrammer.com
  //////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Image.network(
              _image,
              width: 300,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Upload your file',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'File should be xlsx, png',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: selectFile,
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [10, 4],
                    strokeCap: StrokeCap.round,
                    color: Colors.blue.shade400,
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50.withOpacity(.3),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.folder_open,
                            color: Colors.blue,
                            size: 40,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Select your file',
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey.shade400),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
            _platformFile != null
                ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selected File',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _file!,
                                      width: 70,
                                    )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _platformFile!.name,
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${(_platformFile!.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                          height: 5,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blue.shade50,
                                          ),
                                          child: LinearProgressIndicator(
                                            value: loadingController.value,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        // MaterialButton(
                        //   minWidth: double.infinity,
                        //   height: 45,
                        //   onPressed: () {},
                        //   color: Colors.black,
                        //   child: Text('Upload', style: TextStyle(color: Colors.white),),
                        // )
                      ],
                    ))
                : Container(),
            SizedBox(
              height: 150,
            ),
          ],
        ),
      ),
    );
  }
}
