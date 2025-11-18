DateTime parseServerTime(String dateStr) {
  return DateTime.parse(dateStr);
}

class ChosenAnswerModel {
  final int id;
  final String schoolNumber;
  final String gender;
  final String question;
  final String emoji;
  final int questionId;
  final int targetUserId;
  final int writerUserId;
  final DateTime createdAt;
  final String name;

  ChosenAnswerModel({
    required this.id,
    required this.schoolNumber,
    required this.gender,
    required this.question,
    required this.emoji,
    required this.questionId,
    required this.targetUserId,
    required this.writerUserId,
    required this.createdAt,
    required this.name,
  });

  factory ChosenAnswerModel.fromJson(Map<String, dynamic> json) {
    return ChosenAnswerModel(
      id: json["id"],
      schoolNumber: json["school_number"],
      gender: json["gender"],
      question: json["question"],
      emoji: json["emoji"],
      questionId: json["question_id"],
      targetUserId: json["target_user_id"],
      writerUserId: json["writer_user_id"],
      name: json['name'],
      createdAt: parseServerTime(json["created_at"]),
    );
  }
}