import 'dart:developer' as developer;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/asignar_empresas.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'constants.dart';
import '/model/value_objects/user.dart';
import 'package:http/http.dart' as http;
import '../../env.sample.dart';
import 'package:get/get.dart';

class LogIn extends StatefulWidget {
  final Function onSignUpSelected;

  const LogIn({required this.onSignUpSelected});

  @override
  LogInState createState() => LogInState();
}

class LogInState extends State<LogIn> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  Future<User>? _futureUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height > 770
          ? 64
          : size.height > 670
              ? 32
              : 16),
      child: Center(
        child: Card(
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 500,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        width: 30,
                        child: Divider(
                          color: kPrimaryColor,
                          thickness: 2,
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Nombre de usuario',
                          labelText: 'Nombre de usuario',
                          suffixIcon: Icon(
                            Icons.mail_outline,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextField(
                        controller: _controller3,
                        decoration: const InputDecoration(
                          hintText: 'Contraseña',
                          labelText: 'Contraseña',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _futureUser = loginUser(_controller.text,
                                _controller2.text, _controller3.text);
                          });
                        },
                        child: const Text('Iniciar Sesión'),
                      ),
                      //actionButton("Iniciar Sesión"),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const AutoSizeText(
                            "¿No tienes cuenta?",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            maxFontSize: 14,
                          ),
                          //const SizedBox(width: 8,),
                          Flexible(
                              flex: 5,
                              child: GestureDetector(
                                onTap: () {
                                  widget.onSignUpSelected();
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: AutoSizeText(
                                          "Registrarse",
                                          style: TextStyle(
                                            color: kPrimaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                        )),
                                    //const SizedBox(width: 8,),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: kPrimaryColor,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<User> buildFutureBuilder() {
    return FutureBuilder<User>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.username);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const CircularProgressIndicator();
      },
    );
  }

  Future<int> getIdUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    developer.log('entro a getIdUsuario', name: 'entro');
    developer.log(prefs.getInt('idUsuario').toString(), name: 'getIdUsuario');
    return prefs.getInt('idUsuario') ?? 1;
  }

  //Incrementing counter after click
  Future<void> saveIdUsuario(idUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    developer.log('si entre paps', name: 'entre paps');
    setState(() {
      prefs.setInt('idUsuario', idUsuario);
      developer.log(prefs.getInt('idUsuario').toString(),
          name: 'idUsuario en set');
    });
  }

  Future<User> loginUser(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse("${Env.URL_PREFIX}/login"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password
      }),
    );

    developer.log(response.statusCode.toString(),
        name: 'response.statusCode fuera');
    developer.log(response.body.toString(), name: 'response de Id fuera');
    if (response.statusCode == 200) {
      developer.log("se armo");
      developer.log(response.body.toString(), name: 'response de Id');
      Map<String, dynamic> dictionary = jsonDecode(response.body);
      developer.log(dictionary['id'].toString(), name: 'id de dictionary');
      saveIdUsuario(dictionary['id']);
      // saveIdUsuario(int.parse(dictionary['id']));
      Get.to(const ElegirEmpresa());
      //Get.to(const AsignarEmpresa());
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      Get.defaultDialog(
        title: "Alerta",
        content: const Text(
          "Credenciales incorrectas",
        ),
      );
      throw Exception('Failed to login.');
    }
  }
}
