class Capital {
  final List<List<String>> capital;

  Capital({required this.capital});

  factory Capital.fromJson(Map<String, dynamic> json) {
    List<List<String>> capitalJson = [];

    for (int i = 0; i < json['capital'].length; i++) {
      //capitalJson.add(json['capital'][i].map((e) => e.toString()).toList());
      List<String> curList = [];
      curList.add(json['capital'][i][0].toString());
      curList.add(json['capital'][i][1].toString());
      capitalJson.add(curList);
    }


    return Capital(
      capital: capitalJson,
    );

  }

  Map<String, dynamic> toJson() => {
        'capital': capital,
      };
}
