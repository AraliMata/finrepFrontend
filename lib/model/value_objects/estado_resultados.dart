import 'package:flutter_frontend_test/model/value_objects/activo_pasivo.dart';
import 'package:flutter_frontend_test/model/value_objects/capital.dart';
import 'dart:developer' as developer;

class EstadoResultados {
  List<dynamic> ingresos;
  List<dynamic>  egresos;

  EstadoResultados(
      {required this.ingresos, required this.egresos});

  factory EstadoResultados.fromJson(Map<String, dynamic> json) {
    return EstadoResultados(
      ingresos: json['ingresos'], //Convertir a ActivoPasivo
      egresos: json['egresos'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ingresos': ingresos,
        'egresos': egresos,
      };
}
