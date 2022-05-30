
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
