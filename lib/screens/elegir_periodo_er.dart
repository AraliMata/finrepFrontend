import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/value_objects/empresa.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:flutter_frontend_test/model/value_objects/meses.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:flutter_frontend_test/screens/login_signin/login.dart';
import 'package:flutter_frontend_test/screens/prueba_mostrar_estado_resultados.dart';
// import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/widgets/general_app_bar.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'login_signin/login.dart';
import '../env.sample.dart';
import 'dart:developer' as developer;

class ElegirPeriodo extends StatefulWidget {
  const ElegirPeriodo({Key? key}) : super(key: key);
  @override
  State<ElegirPeriodo> createState() => ElegirPeriodoState();
}

class ElegirPeriodoState extends State<ElegirPeriodo> {
  // late Future<List<dynamic>> empresas;
  late Future<List<String>> empresas;
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  late List<Empresa> empresasTodo;
  LogInState loginData = LogInState();
  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();

  @override
  void initState() {
    super.initState();
    empresas = getMeses();
  }

  int idEmpresaGlobal = 0;
  Map<String, int> monthInt = {
    "Enero": 1,
    "Febrero": 2,
    "Marzo": 3,
    "Abril": 4,
    "Mayo": 5,
    "Junio": 6,
    "Julio": 7,
    "Agosto": 8,
    "Septiembre": 9,
    "Octubre": 10,
    "Noviembre": 11,
    "Diciembre": 12,
  };

  Future<List<String>> getMeses() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();

    // developer.log(idUsuario.toString(), name: 'idUsuarioPruebaSuprema');

    final response = await http.get(Uri.parse(
        "${Env.URL_PREFIX}/contabilidad/empresas/$idEmpresa/meses-disponibles"));

    if (response.statusCode == 204) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('No hay datos'),
          content: Text('Aún no se suben datos para esta empresa'),
          actions: <Widget>[
            TextButton(
              // onPressed: () => Navigator.pop(context, 'OK'),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }

    developer.log(jsonDecode(response.body).toString(), name: 'response');
    developer.log(jsonDecode(response.body).runtimeType.toString(),
        name: 'response');

    /*Meses meses = items.map<Meses>((json) {
      return Meses.fromJson(json);
    }).toList();*/

    final meses = Meses.fromJson(jsonDecode(response.body));

    return meses.months;
  }

  Future<int> getMonth() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('mes') ?? 0;
  }

  //Incrementing counter after click
  Future<void> saveMonth(mes) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      developer.log(monthInt[mes].toString(), name: 'save month');
      prefs.setInt('mes', monthInt[mes] ?? 6);
    });
  }

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    double screenHeight = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: GeneralAppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AutoSizeText(
                'Estado de Resultados',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              SizedBox(height: screenHeight * .01),
              Center(
                  child: AutoSizeText(
                "Elige el periodo del cual deseas ver el estado de resultados",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w100,
                    decoration: TextDecoration.none),
                maxLines: 2,
              )),
              SizedBox(height: screenHeight * 0.12),
              FutureBuilder<List<String>>(
                future: empresas,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  // By default, show a loading spinner.
                  developer.log(snapshot.data.toString(),
                      name: "Snapshot data");
                  List<String> empresaMostrar = snapshot.data ?? [''];
                  if (!snapshot.hasData) {
                    return const ProgressBar();
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
                        'Selecciona un periodo',
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
                          return 'Por favor selecciona el periodo.';
                        } else {
                          // obtain shared preferences
                          // developer.log(idEmpresaGlobal.toString(),
                          // name: 'pruebaIdEmpresa');
                          // developer.log('antes de');
                          // developer.log('despues de');
                          // developer.log(value.toString(),
                          //     name: 'selectedValue');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MEstadoResultados()),
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
                        saveMonth(value.toString());
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
