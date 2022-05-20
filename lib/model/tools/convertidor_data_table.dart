import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ConvertidorDataTable {
  DataRow createRow(datos) {
    List<DataCell> celdas = [];

    for (int i = 0; i < datos.length; i++) {
      //developer.log(datos[i], name:"celda");
      celdas.add(DataCell(Text(datos[i])));
    }

    DataRow renglon = DataRow(cells: celdas);

    return renglon;
  }

  List<DataRow> createRowsGroup(data) {
    List<DataRow> grupoRenglones = [];

    for (int i = 0; i < data.length; i++) {
      DataRow curRow = createRow(data[i]);
      //developer.log(data[i][0], name:"renglon");
      grupoRenglones.add(curRow);
    }

    return grupoRenglones;
  }

  List<DataRow> createRowsBalanceGeneral(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CIRCULANTE', ' ']));
    renglones + createRowsGroup(datos.circulante);

    renglones.add(createRow(['FIJO', ' ']));
    renglones + createRowsGroup(datos.fijo);

    renglones.add(createRow(['DIFERIDO', ' ']));
    renglones + createRowsGroup(datos.diferido);


    developer.log(renglones.runtimeType.toString(), name:"renglon");
    return renglones;
  }

  List<DataRow> createRowsBalanceGeneralCapital(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['CAPITAL', ' ']));
    renglones + createRowsGroup(datos.capital);

    return renglones;
  }

  List<DataRow> createRowsEstadoGeneral(datos) {
    List<DataRow> renglones = [];

    renglones.add(createRow(['Ingresos', ' ']));
    renglones + createRowsGroup(datos.ingresos);

    renglones.add(createRow(['Egresos', ' ']));
    renglones + createRowsGroup(datos.egresos);

    //renglones.add(createRow(['Utilidad (o Pérdida)', ' ']));
    //renglones + createRowsGroup(datos.utilidad);

    return renglones;
  }
}
