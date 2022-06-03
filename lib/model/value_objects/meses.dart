import 'dart:developer' as developer;
class Meses {
  final List<String> months;

  Meses({required this.months});

  factory Meses.fromJson(Map<String, dynamic> json) {

    developer.log(json['meses'].runtimeType.toString(), name:"meses");
    Map<int, String> monthNumber = {
    1: "Enero",
    2: "Febrero",
    3: "Marzo",
    4: "Abril",
    5: "Mayo",
    6: "Junio",
    7: "Julio",
    8: "Agosto",
    9: "Septiembre",
    10: "Octubre",
    11: "Noviembre",
    12: "Diciembre"
  };
    List<String> monthsN = [];

    for (int i = 0; i < json['meses'].length; i++) {
      int idx = json['meses'][i];
      monthsN.add(monthNumber[idx] ?? "Junio");
    }

    return Meses(months: monthsN);
  }

  Map<String, dynamic> toJson() => {
        'meses': months,
      };
}
