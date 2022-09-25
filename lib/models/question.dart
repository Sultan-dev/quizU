class Question {
  final String question;
  final List<String> answers;
  final int id;
  final String correct;

  Question({
    required this.question,
    required this.answers,
    required this.correct,
    required this.id,
  });
}
