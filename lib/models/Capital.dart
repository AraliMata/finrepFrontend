class Capital {
  final List<List<String>> capital;

  Capital(
      {required this.capital});

  factory Capital.fromJson(Map<String, dynamic> json) {
    return Capital(
      capital: json['capital'],
    );
  }

  Map<String, dynamic> toJson() => {
        'capital': capital,
      };
}
