class ActivoPasivo {
  final List<List<String>> circulante;
  final List<List<String>> fijo;
  final List<List<String>> diferido;

  ActivoPasivo(
      {required this.circulante, required this.fijo, required this.diferido});

  factory ActivoPasivo.fromJson(Map<String, dynamic> json) {
    return ActivoPasivo(
      circulante: json['circulante'],
      fijo: json['fijo'],
      diferido: json['diferido'],
    );
  }

  Map<String, dynamic> toJson() => {
        'circulante': circulante,
        'fijo': fijo,
        'diferido': diferido,
      };
}
