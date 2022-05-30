
class ConvertidorJson{

  static List<List<String>> jsonToList(json, key) {
    List<List<String>> completeList = [];

    for (int i = 0; i < json[key].length; i++) {
      //fijoJson.add(json['fijo'][i].map((e) => e.toString()).toList());
      List<String> curList = [];
      curList.add(json[key][i][0].toString());
      curList.add(json[key][i][1].toString());
      completeList.add(curList);
    }

    return completeList;
  }

}