import 'package:flutter/material.dart';
import 'subirArchivo.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => HomeState();
}


class HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Subir archivo'),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SubirArchivo()),
            );
          },
        ),
      ),
    );
  }
}



//Seleccionar archivo
