import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/widgets/progress_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_frontend_test/screens/home.dart';

import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'dart:developer' as developer;

class ElegirEmpresa extends StatefulWidget {
  const ElegirEmpresa({Key? key}) : super(key: key);
  @override
  State<ElegirEmpresa> createState() => ElegirEmpresaState();
}

class ElegirEmpresaState extends State<ElegirEmpresa> {
  late Future<List<dynamic>> empresas;
  ConvertidorDataTable convertidor = ConvertidorDataTable();

  @override
  void initState() {
    super.initState();
    //empresas = getEmpresas();
  }

  Future<List<dynamic>> getEmpresas() async {
    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/balanceGeneral"));

    developer.log(jsonDecode(response.body).toString(), name: 'response');
    developer.log(jsonDecode(jsonDecode(response.body)).runtimeType.toString(),
        name: 'response type');

    final responseDecoded = jsonDecode(response.body);
    final empresas = responseDecoded.empresas;
    //BalanceGeneral.fromJson(jsonDecode(jsonDecode(response.body)));

    return empresas;
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
                decoration: TextDecoration.none
              ),
            ),
              SizedBox(height: screenHeight * 0.12),
              DropdownButtonFormField2(
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
                items: genderItems
                    .map((item) => DropdownMenuItem<String>(
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
                    return 'Por favor seecciona la empresa.';
                  }
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
                onSaved: (value) {
                  selectedValue = value.toString();
                },
              ),
              SizedBox(height: screenHeight * 0.12),
              SimpleElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
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
