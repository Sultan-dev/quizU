class User {
  final String name;
  final String mobile;
  final String token;

  User({
    required this.name,
    required this.mobile,
    required this.token,
  });

  User.fromJson(Map<String, dynamic> data)
      : this(
          name: data["name"],
          mobile: data["mobile"],
          token: data["token"],
        );

  Map<String, dynamic> toJson() => {
        "name": name,
        "mobile": mobile,
        "token": token,
      };
}
