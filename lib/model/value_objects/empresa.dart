class Empresa {
  final String empresa;
  final int id;

  Empresa({required this.empresa, required this.id});

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(empresa: json['nombre'], id: json['id']);
  }

  Map<String, dynamic> toJson() => {
        'nombre': empresa,
        'id': id,
      };
}
