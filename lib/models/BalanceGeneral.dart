import 'package:flutter_frontend_test/models/ActivoPasivo.dart';
import 'package:flutter_frontend_test/models/Capital.dart';

class BalanceGeneral {
  final ActivoPasivo activo;
  final ActivoPasivo pasivo;
  final Capital capital;

  BalanceGeneral(
      {required this.activo, required this.pasivo, required this.capital});

  factory BalanceGeneral.fromJson(Map<String, dynamic> json) {
    ActivoPasivo activoJson = ActivoPasivo.fromJson(json['activo']);
    ActivoPasivo pasivoJson = ActivoPasivo.fromJson(json['pasivo']);
    Capital capitalJson = Capital.fromJson(json['capital']);

    return BalanceGeneral(
      activo: activoJson, //Convertir a ActivoPasivo
      pasivo: pasivoJson,
      capital: capitalJson,
    );
  }

  Map<String, dynamic> toJson() => {
        'activo': activo,
        'pasivo': pasivo,
        'capital': capital,
      };
}
