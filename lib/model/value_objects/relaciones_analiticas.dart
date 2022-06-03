import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';
import 'dart:developer' as developer;

class RelacionesAnaliticas {
  List<dynamic> movimientos;
  List<dynamic> totalCuentas;
  List<dynamic> sumasIguales;

  RelacionesAnaliticas(
      {required this.movimientos,
      required this.totalCuentas,
      required this.sumasIguales});

  factory RelacionesAnaliticas.fromJson(Map<String, dynamic> json) {
    developer.log(json['movimientos'].runtimeType.toString(),
        name: 'ActivoPasivojuju');

    developer.log(json['movimientos'][0].length.toString(),name: "tipoMovimientosConvertido");

    return RelacionesAnaliticas(
        movimientos: json['movimientos'], 
        totalCuentas: json['totalCuentas'],
        sumasIguales: json['sumasIguales']);
  }

  Map<String, dynamic> toJson() => {
        'movimientos': movimientos,
        'totalCuentas': totalCuentas,
        'sumasIguales': sumasIguales
      };
}
