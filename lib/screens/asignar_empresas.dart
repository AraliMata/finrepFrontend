import 'package:flutter/material.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'dart:convert';
import 'dart:html';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:get/get.dart';
import 'package:flutter_frontend_test/model/value_objects/empresa.dart';
//import 'package:flutter_frontend_test/screens/login_signin/login.dart';
import 'package:flutter_frontend_test/screens/login_signin/signup.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:flutter_frontend_test/screens/mostrar_balance_general.dart';
import 'package:flutter_frontend_test/screens/mostrar_relaciones_analiticas.dart';
import 'package:flutter_frontend_test/screens/prueba_mostrar_estado_resultados.dart';
import 'package:flutter_frontend_test/screens/login_signin/BackgroundPage.dart';
import 'package:flutter_frontend_test/screens/mostrar_relaciones_analiticas.dart';
import 'package:flutter_frontend_test/screens/elegirPeriodoBG.dart';
import 'package:flutter_frontend_test/screens/elegirPeriodoER.dart';
import '../model/widgets/init_app_bar.dart';
import 'subirArchivo.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart';
import 'package:flutter_frontend_test/screens/home.dart';

class AsignarEmpresa extends StatefulWidget {
  const AsignarEmpresa({Key? key}) : super(key: key);
  @override
  State<AsignarEmpresa> createState() => AsignarEmpresaState();
}

class AsignarEmpresaState extends State<AsignarEmpresa> {
  final Storage localStorage = window.localStorage;

  // late Future<List<dynamic>> empresas;
  late Future<List<String>> empresas;
  //ConvertidorDataTable convertidor = ConvertidorDataTable();
  late List<Empresa> empresasTodo;
  SignUpState signupData = SignUpState();

  @override
  void initState() {
    super.initState();
    empresas = getEmpresas();
    getUsuario();
  }

  int idEmpresaGlobal = 0;

  Future<int> getUsuario() {
    var idUsuario = signupData.getIdUsuarioSignup();

    return idUsuario;
  }

  Future<List<String>> getEmpresas() async {
    // developer.log(idUsuario.toString(), name: 'idUsuarioPruebaSuprema');

    final response =
        await http.get(Uri.parse("${Env.URL_PREFIX}/contabilidad/empresas"));

    developer.log(jsonDecode(response.body).toString(), name: 'response');

    final items = json.decode(response.body).cast<Map<String, dynamic>>();

    List<Empresa> empresas = items.map<Empresa>((json) {
      return Empresa.fromJson(json);
    }).toList();

    empresasTodo = empresas;
    developer.log(empresas.toString(), name: 'list<empresa>');

    List<String> nombresEmpresas = [];
    List<int> idEmpresas = [];

    for (int i = 0; i < empresas.length; i++) {
      nombresEmpresas.add(empresas[i].empresa);
      idEmpresas.add(empresas[i].id);
    }
    developer.log(nombresEmpresas.toString(), name: 'empresas');
    developer.log(idEmpresas.toString(), name: 'id');

    int usuario = await getUsuario();
    final Controller controller = Get.find();
    var numero = controller.selectedCategories.length;
    developer.log(numero.toString(), name: "numero de cosas seleccionadas");
    for (var i = 0; i <= numero; i++) {
      var cosa = controller.selectedCategories[i].name;
      var nombre = empresas[i].empresa;
      var id = empresas[i].id;
      developer.log(cosa.toString(), name: "cosa en for");
      developer.log(nombre.toString(), name: "nombre en for");
      developer.log(id.toString(), name: "id en for");
      if (cosa == nombre) {
        registrarUsuarioEmpresa(id, usuario);
      }

      //developer.log(cosa.toString(), name: "cosa(s) seleccionada(s)");
    }

    return nombresEmpresas;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("Asignar Empresas")),
        body: Column(
          children: [
            CategoryFilter(),
            Container(
              color: Colors.blue,
              height: 2,
            ),
            //SelectedCategories()

            SimpleElevatedButton(
              onPressed: () async {
                getEmpresas();
                Get.to(const ElegirEmpresa());
              },
              color: Colors.blue,
              child: const Text('Confirmar selección'),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Obx(
        () => ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckboxListTile(
              value: controller.selectedCategories
                  .contains(controller.categories[index]),
              onChanged: (bool? selected) =>
                  controller.toggle(controller.categories[index]),
              title: CategoryWidget(category: controller.categories[index]),
            );
          },
        ),
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final Category category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      category.name,
      style: TextStyle(color: category.color),
    );
  }
}

class Controller extends GetxController {
  // ignore: prefer_final_fields
  var _categories = {
    Category("Lecar", Colors.blue): false,
    Category("Walmart", Colors.blue): false,
    Category("Ereh", Colors.blue): false,
    Category("Wano", Colors.blue): false,
  }.obs;

  void toggle(Category item) {
    _categories[item] = !(_categories[item] ?? true);
  }

  get selectedCategories =>
      _categories.entries.where((e) => e.value).map((e) => e.key).toList();

  get categories => _categories.entries.map((e) => e.key).toList();
}

class Category {
  final String name;
  final Color color;

  Category(this.name, this.color);
}

Future<Empresa> registrarUsuarioEmpresa(int IdEmpresa, int IdUsuario) async {
  final response = await http.post(
    Uri.parse("${Env.URL_PREFIX}/ver-empresas/$IdEmpresa/$IdUsuario"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    // body: jsonEncode(<String, String>{
    //   'username': username,
    //   'email': email,
    //   'password': password
    // }),
  );
  if (response.statusCode == 201) {
    developer.log("se armo");
    //Get.to(const AsignarEmpresa());
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Empresa.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to register employee.');
  }
}

//////////////////////

// class SelectedCategories extends StatelessWidget {
//   final Controller controller = Get.find(); //get para conseguir los valores

//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Obx(
//         () => ListView.builder(
//           itemCount: controller.selectedCategories
//               .length, //Largo de las categorias, esto es util pal for
//           itemBuilder: (BuildContext context, int index) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: CategoryWidget(
//                 category: controller.selectedCategories[
//                     index], //creo esto es para ya tener los items como tal
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

//////////////////////////

// class AsignarEmpresa extends StatefulWidget {
//   const AsignarEmpresa({Key? key}) : super(key: key);
//   @override
//   State<AsignarEmpresa> createState() => AsignarEmpresaState();
// }

// class AsignarEmpresaState extends State<AsignarEmpresa> {
//   final Storage localStorage = window.localStorage;

//   // late Future<List<dynamic>> empresas;
//   late Future<List<String>> empresas;
//   ConvertidorDataTable convertidor = ConvertidorDataTable();
//   late List<Empresa> empresasTodo;
//   LogInState loginData = LogInState();

//   @override
//   void initState() {
//     super.initState();
//     empresas = getEmpresas();
//   }

//   int idEmpresaGlobal = 0;

//   Future<List<String>> getEmpresas() async {
//     var idUsuario = await loginData.getIdUsuario();
//     // developer.log(idUsuario.toString(), name: 'idUsuarioPruebaSuprema');

//     final response = await http.get(Uri.parse(
//         "${Env.URL_PREFIX}/contabilidad/usuarios/$idUsuario/empresas"));

//     developer.log(jsonDecode(response.body).toString(), name: 'response');

//     final items = json.decode(response.body).cast<Map<String, dynamic>>();

//     List<Empresa> empresas = items.map<Empresa>((json) {
//       return Empresa.fromJson(json);
//     }).toList();

//     empresasTodo = empresas;
//     developer.log(empresas.toString(), name: 'list<empresa>');

//     List<String> nombresEmpresas = [];

//     for (int i = 0; i < empresas.length; i++) {
//       nombresEmpresas.add(empresas[i].empresa);
//     }
//     developer.log(nombresEmpresas.toString(), name: 'empresas');

//     return nombresEmpresas;
//   }

//   Future<int> getIdEmpresa() async {
//     final prefs = await SharedPreferences.getInstance();
//     // developer.log('entro', name: 'entro');
//     // developer.log(prefs.getInt('idEmpresa').toString(), name: 'getIdEmpresa');
//     return prefs.getInt('idEmpresa') ?? 0;
//   }

//   Future<String> getNombreEmpresa() async {
//     final prefs = await SharedPreferences.getInstance();
//     // developer.log('entro', name: 'entro');
//     // developer.log(prefs.getInt('idEmpresa').toString(), name: 'getIdEmpresa');
//     return prefs.getString('nombreEmpresa') ?? 'Empresa';
//   }

//   //Incrementing counter after click
//   Future<void> saveIdEmpresa(nombreEmpresa) async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       for (int i = 0; i < empresasTodo.length; i++) {
//         if (empresasTodo[i].empresa == nombreEmpresa) {
//           prefs.setInt('idEmpresa', empresasTodo[i].id);
//           // developer.log(empresasTodo[i].id.toString(), name: 'saveIdEmpresa');
//           // developer.log(prefs.getInt('idEmpresa').toString(),
//           // name: 'saveIdEmpresaPrefs');
//           // developer.log('guardo', name: 'saveIdEmpresa');
//           break;
//         }
//       }
//       prefs.setString('nombreEmpresa', nombreEmpresa);
//     });
//   }

//   final List<String> genderItems = [
//     'Male',
//     'Female',
//   ];

//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     final _formKey = GlobalKey<FormState>();
//     double screenHeight = MediaQuery.of(context).size.height;
//     // TODO: implement build
//     return Scaffold(
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 80),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 '¡Bienvenido a FinRep!',
//                 style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.grey.shade800,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: screenHeight * .01),
//               Text(
//                 "Elige la empresa de la cual vas a ver reportes o subir archivos",
//                 style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.grey.shade500,
//                     fontWeight: FontWeight.w100,
//                     decoration: TextDecoration.none),
//               ),
//               SizedBox(height: screenHeight * 0.12),
//               FutureBuilder<List<String>>(
//                 future: empresas,
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   // By default, show a loading spinner.
//                   developer.log(snapshot.data.toString(),
//                       name: "Snapshot data");
//                   List<String> empresaMostrar = snapshot.data ?? [''];
//                   if (true) {
//                     return DropdownButtonFormField2(
//                       decoration: InputDecoration(
//                         //Add isDense true and zero Padding.
//                         //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
//                         isDense: true,
//                         contentPadding: EdgeInsets.zero,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         //Add more decoration as you want here
//                         //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
//                       ),
//                       isExpanded: true,
//                       hint: const Text(
//                         'Selecciona empresa',
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       icon: const Icon(
//                         Icons.arrow_drop_down,
//                         color: Colors.black45,
//                       ),
//                       iconSize: 30,
//                       buttonHeight: 60,
//                       buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//                       dropdownDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       items: empresaMostrar
//                           .map((item) => DropdownMenuItem(
//                                 value: item,
//                                 child: Text(
//                                   item,
//                                   style: const TextStyle(
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ))
//                           .toList(),
//                       validator: (value) {
//                         if (value == null) {
//                           return 'Por favor selecciona la empresa.';
//                         } else {
//                           // obtain shared preferences
//                           // developer.log(idEmpresaGlobal.toString(),
//                           // name: 'pruebaIdEmpresa');
//                           // developer.log('antes de');
//                           // developer.log('despues de');
//                           // developer.log(value.toString(),
//                           //     name: 'selectedValue');
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const Home()),
//                           );
//                         }
//                         return null;
//                       },
//                       onChanged: (value) {
//                         //Do something when changing the item if you want.
//                         // saveIdEmpresa(value.toString());
//                         // developer.log('cambiado');
//                         // developer.log(value.toString(), name: 'selectedValue');
//                       },
//                       onSaved: (value) {
//                         selectedValue = value.toString();
//                         developer.log('guardado');
//                         saveIdEmpresa(value.toString());
//                       },
//                     );
//                   }
//                 },
//               ),
//               SizedBox(height: screenHeight * 0.12),
//               SimpleElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                   }
//                 },
//                 color: Colors.blue,
//                 child: const Text('Confirmar selección'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
