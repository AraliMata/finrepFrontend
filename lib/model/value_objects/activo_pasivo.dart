import 'dart:developer' as developer;
import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';

class ActivoPasivo {
  final List<List<dynamic>> circulante;
  final List<List<dynamic>> fijo;
  final List<List<dynamic>> diferido;

  ActivoPasivo(
      {required this.circulante, required this.fijo, required this.diferido});


  factory ActivoPasivo.fromJson(Map<String, dynamic> json) {
    developer.log(json['fijo'].runtimeType.toString(),
        name: 'ActivoPasivojuju');

    List<List<dynamic>> circulanteJson = ConvertidorJson.jsonToList(json, 'circulante');
    List<List<dynamic>> fijoJson = ConvertidorJson.jsonToList(json, 'fijo');
    List<List<dynamic>> diferidoJson = ConvertidorJson.jsonToList(json, 'diferido');

      developer.log(circulanteJson.runtimeType.toString(),
        name: 'Tipo dato ActivoPasivo');    

    
    return ActivoPasivo(
      circulante: circulanteJson,
      fijo: fijoJson,
      diferido: diferidoJson,
    );
    
  }

  Map<String, dynamic> toJson() => {
        'circulante': circulante,
        'fijo': fijo,
        'diferido': diferido,
      };
}
