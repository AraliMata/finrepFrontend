import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:test/test.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';
import 'dart:convert';

void main() {
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  
  const stringBalanceGeneral =
      '{ "activo": { "circulante": [["Bancos", 6181.41],["Clientes", 2]], "fijo": [["Uno", 1], ["dos", 2]], "diferido": [["jojo", 4],["jeje", 5]]}, "pasivo":{"circulante": [["Bancos", 6181.41],["Clientes", 2]],"fijo": [["Uno", 1], ["dos", 2]], "diferido": [["jojo", 4],["jeje", 5]]}, "capital": {"capital": [["jujuju", 18]]}}';
  
  final balanceGeneralJson = jsonDecode(stringBalanceGeneral);

  group('Convertidor estado de resultados', () {
    test('convertidor debería devolver el valor esperado de activo circulante',
        () {
      //Given
      var input = balanceGeneralJson['activo']!;
      var input2 = 'circulante';
      List<List<String>> expectedValue =  [
        ["Bancos", "6181.41"],
        ["Clientes", "2"]
      ];
      //When
      var result = ConvertidorJson.jsonToList(input, input2);
      //Then
      expect(result, expectedValue);
    });

    test('Convertidor debería devolver tipo List<List<String>>', () {
      //Given
      var input = balanceGeneralJson['activo']!;
      //When
      var result = ConvertidorJson.jsonToList(input, 'circulante')
          .runtimeType
          .toString();
      //Then
      expect(result, 'List<List<String>>');
    });
  });

  group('Json a Value Objects', () {
    test('fromJson debería devolver tipo BalanceGeneral', () {
      //Given
      var input = balanceGeneralJson;
      const expectedValue = "BalanceGeneral";
      //When
      var result = BalanceGeneral.fromJson(input).runtimeType.toString();
      //Then
      expect(result, expectedValue);
    });

  });

  group('Value Object data in DataTable Widgets', () {
    test(
        'createRowsEstadoGeneral debería regresar un widget de tipo List<DataRow>',
        () {
      //Given
      var input = BalanceGeneral.fromJson(balanceGeneralJson).activo;
      const expectedValue = 'List<DataRow>';
      //When
      var result = convertidor.createRowsBalanceGeneral(input).runtimeType.toString();
      
      //Then
      expect(result, expectedValue);
    });
  });
}
