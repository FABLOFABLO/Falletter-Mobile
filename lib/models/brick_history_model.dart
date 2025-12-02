class BrickHistoryModel {
  final String title;
  final String description;
  final int amount;
  final String type;
  final int? questionId;
  final int? targetUserId;
  final int? writerUserId;

  BrickHistoryModel({
    required this.title,
    required this.description,
    required this.amount,
    required this.type,
    this.questionId,
    this.targetUserId,
    this.writerUserId,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "amount": amount,
    "type": type,
    "question_id": questionId,
    "target_user_id": targetUserId,
    "writer_user_id": writerUserId,
  };
}

class BrickHistoryResponseModel {
  final int id;
  final String description;
  final String schoolNumber;
  final String gender;
  final String question;
  final String emoji;
  final int amount;
  final String type;
  final int questionId;
  final int targetUserId;
  final int writerUserId;
  final DateTime createdAt;

  BrickHistoryResponseModel({
    required this.id,
    required this.description,
    required this.schoolNumber,
    required this.gender,
    required this.question,
    required this.emoji,
    required this.amount,
    required this.type,
    required this.questionId,
    required this.targetUserId,
    required this.writerUserId,
    required this.createdAt,
  });

  factory BrickHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return BrickHistoryResponseModel(
      id: json['id'],
      description: json['description'],
      schoolNumber: json['school_number'],
      gender: json['gender'],
      question: json['question'],
      emoji: json['emoji'],
      amount: json['amount'],
      type: json['type'],
      questionId: json['question_id'],
      targetUserId: json['target_user_id'],
      writerUserId: json['writer_user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
