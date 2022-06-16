// import 'testop.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:get/get.dart';
import '../model/widgets/general_app_bar.dart';
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
  var estadoArchivoC = 'Seleccionar archivo de catálogo',
      estadoArchivoM = 'Seleccionar archivo de movimientos';
  bool singleTapM = true, singleTapC = true;

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

  void handleSubirArchivoButton() {
    developer.log(request.files.length.toString(), name: 'request.get');
    if (request.files.length == 2) {
      subirArchivo();
      initRequest();
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Archivos faltantes'),
          content: Text('Carga ambos archivos antes de intentar subirlos'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  Future<String> subirArchivo() async {
    var dialogContext = context;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          dialogContext = context;
          return Dialog(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Subiendo archivos"),
              ],
            ),
          );
        });
    //var request = http.MultipartRequest('POST', Uri.parse(url));
    developer.log('HOLA MAMAAA', name: 'Entre SubirArchivo');
    developer.log(request.files.first.filename!, name: 'request1');
    developer.log(request.files.last.filename!, name: 'request2');

    var res = await request.send();
    developer.log(res.reasonPhrase! + "es el res", name: 'my.app.category');

    if (res.statusCode == 201) {
      Navigator.pop(dialogContext);
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Archivos subidos exitosamente'),
          content: Text(
              'Ya es posible acceder a esta información mediante los reportes financieros del menú principal'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(dialogContext);
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('No se pudieron subir los archivos'),
          content: Text(
              'Verifica haber subido los archivos correspondientes y que los formatos sean los correctos'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }

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
              'El archivo con el nombre "' + filename + '" fue seleccionado'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                setState(() {
                  if (tipo == "Catálogo") {
                    singleTapC = false;
                    estadoArchivoC = filename;
                  } else {
                    singleTapM = false;
                    estadoArchivoM = filename;
                  }
                });
              },
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
  Widget _getGestureDetectorM(String key) {
    return GestureDetector(
      onTap: () {
        if (singleTapM) {
          selectFile(key);
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 4],
            strokeCap: StrokeCap.round,
            color: Colors.blue.shade400,
            child: Container(
              width: 350,
              height: 100,
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
                    estadoArchivoM,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _getGestureDetectorC(String key) {
    return GestureDetector(
      onTap: () {
        if (singleTapC) {
          selectFile(key);
        }
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [10, 4],
            strokeCap: StrokeCap.round,
            color: Colors.blue.shade400,
            child: Container(
              width: 350,
              height: 100,
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
                    estadoArchivoC,
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
      appBar: GeneralAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Image.network(
              _image,
              width: 300,
            ),
            const SizedBox(
              height: 50,
            ),
            AutoSizeText('Selecciona los archivos a subir',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.bold),
                maxLines: 1),
            const SizedBox(
              height: 10,
            ),
            AutoSizeText(
              'La extensión de los archivos debe ser xlsx',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
              maxLines: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            _getGestureDetectorM('movimientos'),
            _getGestureDetectorC('catalogo'),
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
              onPressed: handleSubirArchivoButton,
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
