import 'package:flutter_frontend_test/models/ActivoPasivo.dart';
import 'package:flutter_frontend_test/models/Capital.dart';

class BalanceGeneral {
  final ActivoPasivo activo;
  final ActivoPasivo pasivo;
  final Capital capital;

  BalanceGeneral(
      {required this.activo, required this.pasivo, required this.capital});

  factory BalanceGeneral.fromJson(Map<String, dynamic> json) {
    ActivoPasivo activoJson =  ActivoPasivo.fromJson()
    return BalanceGeneral(

      activo: json['activo'],
      pasivo: json['pasivo'],
      capital: json['capital'],
    );
  }

  Map<String, dynamic> toJson() => {
        'activo': activo,
        'pasivo': pasivo,
        'capital': capital,
      };
}
