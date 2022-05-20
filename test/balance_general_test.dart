import 'package:flutter_frontend_test/model/tools/convertidor_data_table.dart';
import 'package:flutter_frontend_test/model/value_objects/balance_general.dart';
import 'package:test/test.dart';
import 'package:flutter_frontend_test/model/tools/convertidor_json_to.dart';
import 'dart:convert';

void main() {
  ConvertidorDataTable convertidor = ConvertidorDataTable();
  
  const stringBalanceGeneral =
      '{"activo": {"circulante": [["", 0], ["Bancos", 6181.41], ["Clientes", 176780.11], ["Deudores Diversos", 95334.37], ["IVA Acreditable", 42540.61], ["Total CIRCULANTE", 320836.5]], "fijo": [["", 0], ["Depreciaci�n Acumulada de Mob y Eq. oficina", -2025.0], ["Mobiliario y Equipo de oficina", 14212.06], ["Total FIJO", 12187.06]], "diferido": [["", 0], ["Impuestos Anticipados", 14434.0], ["Total DIFERIDO", 14434.0], [["SUMA DEL ACTIVO"], 347457.56]]}, "pasivo": {"circulante": [["", 0], ["ACREEDORES DIVERSOS", -343.21], ["DOCUMENTOS POR PAGAR", 95162.67], ["IMPUESTOS POR PAGAR", 78376.81], ["Total CIRCULANTE", 173196.27]], "fijo": [["", 0], ["Total FIJO", 0]], "diferido": [["", 0], ["Total DIFERIDO", 0], [["SUMA DEL PASIVO"], 173196.27]]}, "capital": {"capital": [["", 0], ["Capital Social", 100000.0], ["Resultado Ejercicios Anteriores", -41370.48], ["Total CAPITAL", 58629.52], ["SUMA DEL CAPITAL", 117259.04], ["SUMA DEL PASIVO Y CAPITAL", 231825.79]]}}';
  
  final balanceGeneralJson = jsonDecode(stringBalanceGeneral);

  group('Convertidor estado de resultados', () {
    test('convertidor debería devolver el valor esperado de activo circulante',
        () {
      //Given
      var input = balanceGeneralJson['activo']!;
      var input2 = 'circulante';
      List<List<String>> expectedValue =  [
        ["Bancos", "6181.41"],
        ["Clientes", "176780.11"]
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
