class RelacionesAnaliticas {
  List<List<dynamic>> movimientos;
  List<List<dynamic>> totalCuentas;
  List<List<dynamic>> sumasIguales;

  RelacionesAnaliticas(
      {required this.movimientos,
      required this.totalCuentas,
      required this.sumasIguales});

  factory RelacionesAnaliticas.fromJson(Map<String, dynamic> json) {
    return RelacionesAnaliticas(
        movimientos: json['movimientos'], //Convertir a ActivoPasivo
        totalCuentas: json['totalCuentas'],
        sumasIguales: json['sumasIguales']);
  }

  Map<String, dynamic> toJson() => {
        'movimientos': movimientos,
        'totalCuentas': totalCuentas,
        'sumasIguales': sumasIguales
      };
}
