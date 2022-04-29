import 'dart:developer' as developer;

class ActivoPasivo {
  final List<List<String>> circulante;
  final List<List<String>> fijo;
  final List<List<String>> diferido;

  ActivoPasivo(
      {required this.circulante, required this.fijo, required this.diferido});

  factory ActivoPasivo.fromJson(Map<String, dynamic> json) {
    developer.log(json['fijo'].runtimeType.toString(),
        name: 'ActivoPasivojuju');

    List<List<String>> circulanteJson = [];
    List<List<String>> fijoJson = [];
    List<List<String>> diferidoJson = [];

    developer.log(json['circulante'][0][0].toString(), name: 'Sí es string o ');
    for (int i = 0; i < json['circulante'].length; i++) {
      List<String> curList = [];
      curList.add(json['circulante'][i][0].toString());
      curList.add(json['circulante'][i][1].toString());
      circulanteJson.add(curList);
    }

    for (int i = 0; i < json['fijo'].length; i++) {
      //fijoJson.add(json['fijo'][i].map((e) => e.toString()).toList());
      List<String> curList = [];
      curList.add(json['fijo'][i][0].toString());
      curList.add(json['fijo'][i][1].toString());
      fijoJson.add(curList);
    }

    for (int i = 0; i < json['diferido'].length; i++) {
      //diferidoJson.add(json['diferido'][i].map((e) => e.toString()).toList());
      List<String> curList = [];
      curList.add(json['diferido'][i][0].toString());
      curList.add(json['diferido'][i][1].toString());
      diferidoJson.add(curList);
    }

    developer.log(diferidoJson.runtimeType.toString(),
        name: "ActivoPasivo ListString");

    return ActivoPasivo(
      circulante: circulanteJson,
      fijo: fijoJson,
      diferido: diferidoJson,
    );

    List<List<String>> hola = [
      ["HI"]
    ];
    return ActivoPasivo(
      circulante: hola,
      fijo: hola,
      diferido: hola,
    );
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
