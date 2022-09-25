//this model for top 10 scores from the API
class PlayerScore {
  final String name;
  final int score;

  PlayerScore({
    required this.name,
    required this.score,
  });

  PlayerScore.fromJson(Map<String, dynamic> data)
      : this(
          name: data["name"] ?? "Unknown",
          score: data["score"] ?? 0,
        );
}
