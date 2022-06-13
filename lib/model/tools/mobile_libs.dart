import 'dart:developer' as developer;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

WebFuncts getManager() => WebFuncts();

class WebFuncts {
  static Future<void> downloadPdf(bytes, String name) async {
    developer.log("dos", name: "Estoy en movil");
    name = name+".pdf";

    //Get external storage directory
    Directory directory = (await getApplicationDocumentsDirectory());
    //Get directory path
    String path = directory.path;
    //Create an empty file to write PDF data
    File file = File('$path/$name');
    //Write PDF data
    await file.writeAsBytes(bytes, flush: true);
    //Open the PDF document in mobile
    OpenFile.open('$path/$name');
  }
}
