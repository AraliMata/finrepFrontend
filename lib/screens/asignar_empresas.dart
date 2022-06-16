import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import '../model/widgets/simple_elevated_button.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../env.sample.dart';
import 'package:get/get.dart';
import 'package:flutter_frontend_test/model/value_objects/empresa.dart';
//import 'package:flutter_frontend_test/screens/login_signin/login.dart';
import 'package:flutter_frontend_test/screens/login_signin/signup.dart';

import 'package:flutter_frontend_test/screens/home.dart';

class AsignarEmpresa extends StatefulWidget {
  const AsignarEmpresa({Key? key}) : super(key: key);
  @override
  State<AsignarEmpresa> createState() => AsignarEmpresaState();
}

class AsignarEmpresaState extends State<AsignarEmpresa> {
  var empezo = false;
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
    var numerodb = empresas.length;
    developer.log(numero.toString(),
        name: "numero de seleccionados seleccionadas");
    var contador = 0;
    for (var i = 0; i <= numerodb; i++) {
      var seleccionado = controller.selectedCategories[contador].name;
      developer.log(seleccionado.toString(), name: "seleccionado en for");
      var nombre = empresas[i].empresa;
      var id = empresas[i].id;
      developer.log(nombre.toString(), name: "nombre en for");
      developer.log(id.toString(), name: "id en for");
      if (seleccionado == nombre) {
        await Future.delayed(const Duration(milliseconds: 250), () {
          developer.log("cosas iguales, se guardo");
          contador += 1;
          registrarUsuarioEmpresa(id, usuario);
        });
      }
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
                await Future.delayed(const Duration(seconds: 1), () {
                  Get.to(const ElegirEmpresa());
                });
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
  );
  if (response.statusCode == 201) {
    developer.log("se armo");
    //Get.to(const AsignarEmpresa());
    return Empresa.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to register employee.');
  }
}
