class User {
  final String name;
  final String phoneNumber;
  final List<dynamic> scores;

  User({
    required this.name,
    required this.phoneNumber,
    required this.scores,
  });

  User.fromJson(Map<String, dynamic> data)
      : this(
          name: data["name"],
          phoneNumber: data["phoneNumber"],
          scores: data["scores"],
        );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "scores": scores,
      };
}
