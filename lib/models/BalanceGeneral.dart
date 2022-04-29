import 'package:flutter_frontend_test/models/ActivoPasivo.dart';
import 'package:flutter_frontend_test/models/Capital.dart';
import 'dart:developer' as developer;

class BalanceGeneral {
  final ActivoPasivo activo;
  final ActivoPasivo pasivo;
  final Capital capital;

  BalanceGeneral(
      {required this.activo, required this.pasivo, required this.capital});

  factory BalanceGeneral.fromJson(Map<String, dynamic> json) {
    developer.log(json['activo']['circulante'].runtimeType.toString(),
        name: 'balanceGeneraltqm Tipo ');

    //List<String> hi = json['circulante'].cast(List<String>);
    developer.log(json['activo']['circulante'][0].runtimeType.toString(), name: 'listahIihihi');
    List<dynamic> lista = json['activo']['circulante'][0];
    List<String> strs = lista.map((e) => e.toString()).toList();


    developer.log(strs.runtimeType.toString(), name: 'listahI');

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
