import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';

class Capital {
  final List<List<String>> capital;

  Capital({required this.capital});

  factory Capital.fromJson(Map<String, dynamic> json) {
    List<List<String>> capitalJson = ConvertidorJson.jsonToList(json, 'capital');

    return Capital(
      capital: capitalJson,
    );

  }

  Map<String, dynamic> toJson() => {
        'capital': capital,
      };
}
