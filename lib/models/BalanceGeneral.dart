import 'package:flutter_frontend_test/models/ActivoPasivo.dart';

class BalanceGeneral {
  final List<ActivoPasivo> activo;
  final List<ActivoPasivo> pasivo;
  final List<List<String>> capital;

  BalanceGeneral(
      {required this.activo, required this.pasivo, required this.capital});

  factory BalanceGeneral.fromJson(Map<String, dynamic> json) {
    return BalanceGeneral(
      activo: json['activo'], //Convertir a ActivoPasivo
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
