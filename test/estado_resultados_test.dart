import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:flutter_frontend_test/model/value_objects/estado_resultados.dart';
import 'package:test/test.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'dart:convert';

void main() {
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  const stringEstadoResultados =
      '{"ingresos": [["servicios", "blaba", "bla"], ["total", "bla", "blabla"]],"egresos":  [["servicios", "blaba", "bla"], ["total", "bla", "blabla"]]}';

  final estadoResultadosJson = jsonDecode(stringEstadoResultados);

  group('Json a Value Objects', () {
    test('fromJson debería devolver tipo EstadoResultados', () {
      //Given
      var input = estadoResultadosJson;
      const expectedValue = 'EstadoResultados';
      //When
      var result = EstadoResultados.fromJson(input).runtimeType.toString();
      //Then
      expect(result, expectedValue);
    });
  });

  group('Value Object data in DataTable Widgets', () {
    test(
        'createRowsEstadoGeneral debería regresar un widget de tipo List<DataRow>',
        () {
      //Given
      var input = EstadoResultados.fromJson(estadoResultadosJson);
      const expectedValue = 'List<DataRow>';
      //When
      var result =
          convertidor.createRowsEstadoGeneral(input).runtimeType.toString();
      
      //Then
      expect(result, expectedValue);
    });
  });
}
