import 'dart:convert';

class UserScore {
  final DateTime date;
  final int score;

  UserScore({
    required this.date,
    required this.score,
  });

  UserScore.fromJson(Map<String, dynamic> data)
      : this(
          score: data["score"],
          date: DateTime.parse(data["date"]),
        );

  Map<String, dynamic> toJson() => {
        "score": score,
        "date": date.toString(),
      };

  static String encode(List<UserScore> scores) {
    return jsonEncode(
      scores.map<Map<String, dynamic>>(
        (score) {
          return score.toJson();
        },
      ).toList(),
    );
  }

  //scores string will be json data
  static List<UserScore> decode(String scores) {
    if (scores.isNotEmpty || scores != "") {
      return (jsonDecode(scores) as List<dynamic>).map<UserScore>(
        (score) {
          return UserScore.fromJson(score);
        },
      ).toList();
    }
    return [];
  }
}
