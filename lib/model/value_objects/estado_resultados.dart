import 'package:flutter_frontend_test/model/value_objects/activo_pasivo.dart';
import 'package:flutter_frontend_test/model/value_objects/capital.dart';
import 'dart:developer' as developer;

class EstadoResultados {
  var ingresos = [];
  var egresos = [];
  var utilidadPerdida = [];

  EstadoResultados(
      {required this.ingresos, required this.egresos, required this.utilidadPerdida});

  factory EstadoResultados.fromJson(Map<String, dynamic> json) {
    return EstadoResultados(
      ingresos: json['ingresos'], //Convertir a ActivoPasivo
      egresos: json['egresos'],
      utilidadPerdida: json['utilidad'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ingresos': ingresos,
        'egresos': egresos,
        'utilidad': utilidadPerdida,
      };
}
