import 'dart:developer' as developer;

class ConvertidorJson{

  static List<List<dynamic>> jsonToList(json, key) {
    List<List<dynamic>> completeList = [];

    for (int i = 0; i < json[key].length; i++) {
      //fijoJson.add(json['fijo'][i].map((e) => e.toString()).toList());
      List<dynamic> curList = [];
      curList.add(json[key][i][0]);
      curList.add(json[key][i][1]);
      completeList.add(curList);
    }

    return completeList;
  }


  static List<List<dynamic>> jsonToListDynamic(json, key) {
    List<List<dynamic>> completeList = [];

    developer.log(json[key].toString(),
        name: 'Aquí');

    for (int i = 0; i < json[key].length; i++) {
      //fijoJson.add(json['fijo'][i].map((e) => e.toString()).toList());
      List<String> curList = [];
      curList.add(json[key][i][0].toString());
      curList.add(json[key][i][1].toString());
      completeList.add(curList);
    }

    developer.log(completeList.toString(),
        name: 'Aquí2');

    return completeList;
  }

}