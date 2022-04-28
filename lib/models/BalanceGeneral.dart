class BalanceGeneral {
  final List<List<String>> activo;
  final List<List<String>> pasivo;
  final List<List<String>> capital;

  BalanceGeneral(
      {required this.activo, required this.pasivo, required this.capital});

  factory BalanceGeneral.fromJson(Map<String, dynamic> json) {
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
