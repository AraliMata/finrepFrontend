import 'dart:developer' as developer;
import 'dart:html';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart';

WebFuncts getManager() => WebFuncts();

class WebFuncts {
  
  static Future<void> downloadPdf(bytes,String name) async {
    
    developer.log("Downloading", name: "web js");
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", name+".pdf")
      ..click();

    return;
  }
  
} //Para PDF
