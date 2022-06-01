// import 'testop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend_test/screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import '../env.sample.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:iconsax/iconsax.dart';

import '../model/widgets/simple_elevated_button.dart';
import 'package:flutter_frontend_test/screens/elegir_empresas.dart';

class SubirArchivo extends StatefulWidget {
  const SubirArchivo({Key? key}) : super(key: key);

  @override
  State<SubirArchivo> createState() => SubirArchivoState();
}

class SubirArchivoState extends State<SubirArchivo>
    with SingleTickerProviderStateMixin {
  // late Future<List<String>> empresas;

  ElegirEmpresaState elegirEmpresaData = ElegirEmpresaState();
  var request;
  Future<void> initRequest() async {
    var idEmpresa = await elegirEmpresaData.getIdEmpresa();
    developer.log(idEmpresa.toString(), name: 'getIdEmpresaToEndpoint');
    request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "${Env.URL_PREFIX}/contabilidad/reportes/empresas/$idEmpresa/subir-archivos"));
  }

  Future<String> subirArchivo() async {
    //var request = http.MultipartRequest('POST', Uri.parse(url));
    developer.log('HOLA MAMAAA', name: 'Entre SubirArchivo');
    developer.log(request.files.first.filename!, name: 'request1');
    developer.log(request.files.last.filename!, name: 'request2');

    var res = await request.send();
    developer.log(res.reasonPhrase! + "es el res", name: 'my.app.category');

    return res.reasonPhrase!;
  }

  void addFileToRequest(file, key) async {
    final fileReadStream = file.files.first.readStream;
    if (fileReadStream == null) {
      throw Exception('Cannot read file from null stream');
    }
    final stream = http.ByteStream(fileReadStream);
    developer.log(stream.toString(), name: 'stream2');

    request.files.add(http.MultipartFile(
      key,
      stream,
      file.files.first.size,
      filename: file.files.first.name.split("/").last,
      contentType: MediaType('xlsx', 'xls'),
    ));

    developer.log('Tu mamá', name: 'request chequeo 1');
    developer.log(request.files.first.filename!, name: 'request chequeo');
  }

  final String _image =
      'https://ouch-cdn2.icons8.com/84zU-uvFboh65geJMR5XIHCaNkx-BZ2TahEpE9TpVJM/rs:fit:784:784/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODU5/L2E1MDk1MmUyLTg1/ZTMtNGU3OC1hYzlh/LWU2NDVmMWRiMjY0/OS5wbmc.png';
  late AnimationController loadingController;

  File? _file;
  PlatformFile? _platformFile;

  bool validFile(fileExtension, String filename, String tipo) {
    if (tipo == "catalogo") {
      tipo = "Catálogo";
    } else {
      tipo = "Movimientos";
    }

    if (fileExtension == 'xlsx') {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(tipo[0].toUpperCase() + tipo.substring(1)),
          content: Text(
              'El archivo con el nombre "' + filename + '" fue selccionado'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );

      return true;
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Extensión incorrecta'),
          content: const Text(
              'Solo se permiten subir archivos con extensión xlsx (Excel)'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
      return false;
    }
  }

  selectFile(key) async {
    final file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withReadStream: true,
    );

    String? fileExtension = file?.files.first.extension;

    if (file != null && validFile(fileExtension, file.files[0].name, key)) {
      //subirArchivo();
      addFileToRequest(file, key);

      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });

      loadingController.forward();
    }

    if (file != null) {
      print("holis");

      developer.log(fileExtension!, name: 'extension');
      developer.log('log me', name: 'my.app.category');
      developer.log(file.files[0].name, name: 'my.app.category');
      developer.log(file.files.first.bytes.toString(), name: 'bites');
      developer.log(file.files.first.readStream.toString(), name: 'stream');
      developer.log(file.toString(), name: 'my.app.category');
      print(file.files.single.path!);
    }
  }

  @override
  void initState() {
    initRequest();
    // ElegirEmpresaState hola = ElegirEmpresaState();
    // developer.log(hola.getIdEmpresa().toString(), name: 'getIdEmpresaArchivo');
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
  ///
  Widget _getGestureDetector(String key) {
    if (key == "catalogo") {
      key = "catalogo";
    } else {
      key = "movimientos";
    }

    return GestureDetector(
      onTap: () => selectFile(key),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 4],
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
                  const Icon(
                    Iconsax.folder_open,
                    color: Colors.blue,
                    size: 40,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Seleccionar archivo ' + key,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Image.network(
              _image,
              width: 300,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Selecciona los archivos a subir',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'La extensión de los archivos debe ser xlsx',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
            ),
            const SizedBox(
              height: 20,
            ),
            _getGestureDetector('movimientos'),
            _getGestureDetector('catalogo'),
            _platformFile != null
                ? Container(
                    padding: const EdgeInsets.all(20),
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
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    offset: const Offset(0, 1),
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
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _platformFile!.name,
                                        style: const TextStyle(
                                            fontSize: 13, color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${(_platformFile!.size / 1024).ceil()} KB',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade500),
                                      ),
                                      const SizedBox(
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
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ))
                : Container(),
            const SizedBox(
              height: 30,
            ),
            SimpleElevatedButton(
              child: const Text("Subir archivos"),
              color: Colors.blue,
              onPressed: subirArchivo,
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}
