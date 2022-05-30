import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/value_objects/empresa.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_frontend_test/screens/home.dart';
// import 'package:flutter_session/flutter_session.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../env.sample.dart';
import 'dart:developer' as developer;

import '../model/widgets/simple_elevated_button.dart';

class ElegirEmpresa extends StatefulWidget {
  const ElegirEmpresa({Key? key}) : super(key: key);
  @override
  State<ElegirEmpresa> createState() => ElegirEmpresaState();
}

class ElegirEmpresaState extends State<ElegirEmpresa> {
  // late Future<List<dynamic>> empresas;
  late Future<List<String>> empresas = getEmpresas();
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  late List<Empresa> empresasTodo;

  @override
  void initState() {
    super.initState();
    // empresas = getEmpresas();
  }

  int idEmpresaGlobal = 0;

  Future<List<String>> getEmpresas() async {
    final response = await http
        .get(Uri.parse("${Env.URL_PREFIX}/contabilidad/usuarios/1/empresas"));

    developer.log(jsonDecode(response.body).toString(), name: 'response');

    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    List<Empresa> empresas = items.map<Empresa>((json) {
      return Empresa.fromJson(json);
    }).toList();

    empresasTodo = empresas;
    developer.log(empresas.toString(), name: 'list<empresa>');

    List<String> nombresEmpresas = [];

    for (int i = 0; i < empresas.length; i++) {
      nombresEmpresas.add(empresas[i].empresa);
    }
    //empresas.map((empresa) => {nombresEmpresas.add(empresa.empresa)});
    //BalanceGeneral.fromJson(jsonDecode(jsonDecode(response.body)));
    //developer.log(hola.toString(), name: 'empresas');
    developer.log(nombresEmpresas.toString(), name: 'empresas');
    //BalanceGeneral.fromJson(jsonDecode(jsonDecode(response.body)));

    return nombresEmpresas;
  }

  Future<int> getIdEmpresa() async {
    final prefs = await SharedPreferences.getInstance();
    developer.log('entro', name: 'entro');
    developer.log(prefs.getInt('idEmpresa').toString(), name: 'entro');
    // setState(() {
    // idEmpresaGlobal = (prefs.getInt('idEmpresa') ?? 1);
    // });

    // idEmpresaGlobal = (prefs.getInt('idEmpresa') ?? 1);
    return prefs.getInt('idEmpresa') ?? 1;
    // idEmpresaGlobal = (prefs.getInt('idEmpresa') ?? 0);
    // return prefs.getInt('idEmpresa') ?? 1;
  }

  //Incrementing counter after click
  Future<void> saveIdEmpresa(nombreEmpresa) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (int i = 0; i < empresasTodo.length; i++) {
        if (empresasTodo[i].empresa == nombreEmpresa) {
          prefs.setInt('idEmpresa', empresasTodo[i].id);
          developer.log(empresasTodo[i].id.toString(), name: 'idEmpresa');
          developer.log('guardo', name: 'idEmpresa');
          break;
        }
      }
    });
  }

  final List<String> genderItems = [
    'Male',
    'Female',
  ];

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¡Bienvenido a FinRep!',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * .01),
              Text(
                "Elige la empresa de la cual vas a ver reportes o subir archivos",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none),
              ),
              SizedBox(height: screenHeight * 0.12),
              FutureBuilder<List<String>>(
                future: empresas,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // By default, show a loading spinner.
                  developer.log(snapshot.data.toString(),
                      name: "Snapshot data");
                  developer.log(genderItems.toString(), name: "string");
                  List<String> empresaMostrar = snapshot.data ?? [''];
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  // Render employee lists
                  else {
                    return DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //Add more decoration as you want here
                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Selecciona empresa',
                        style: TextStyle(fontSize: 14),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: empresaMostrar
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Por favor selecciona la empresa.';
                        } else {
                          // obtain shared preferences
                          developer.log(idEmpresaGlobal.toString(),
                              name: 'pruebIdEmpresa');
                          // developer.log('antes de');
                          // developer.log('despues de');
                          // developer.log(value.toString(),
                          //     name: 'selectedValue');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
                        }
                        return null;
                      },
                      onChanged: (value) {
                        //Do something when changing the item if you want.
                        // saveIdEmpresa(value.toString());
                        // developer.log('cambiado');
                        // developer.log(value.toString(), name: 'selectedValue');
                      },
                      onSaved: (value) {
                        selectedValue = value.toString();
                        developer.log('guardado');
                        saveIdEmpresa(value.toString());
                      },
                    );
                  }
                },
              ),
              SizedBox(height: screenHeight * 0.12),
              SimpleElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                color: Colors.blue,
                child: const Text('Confirmar selección'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
