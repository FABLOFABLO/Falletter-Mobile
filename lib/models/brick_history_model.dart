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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      if (questionId != null) 'question_id': questionId,
      if (targetUserId != null) 'target_user_id': targetUserId,
      if (writerUserId != null) 'writer_user_id': writerUserId,
    };
  }
}

class BrickHistoryResponseModel {
  final int id;
  final String description;
  final int amount;
  final String type;
  final String? question;
  final int? questionId;
  final int? targetUserId;
  final int? writerUserId;
  final String? gender;
  final String? schoolNumber;
  final DateTime createdAt;

  BrickHistoryResponseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    this.question,
    this.questionId,
    this.targetUserId,
    this.writerUserId,
    this.gender,
    this.schoolNumber,
    required this.createdAt,
  });

  factory BrickHistoryResponseModel.fromJson(Map<String, dynamic> json) {

    try {
      final model = BrickHistoryResponseModel(
        id: json['id'] as int,
        description: json['description'] as String,
        amount: json['amount'] as int,
        type: json['type'] as String,
        question: json['question'] as String?,
        questionId: json['question_id'] as int?,
        targetUserId: json['target_user_id'] as int?,
        writerUserId: json['writer_user_id'] as int?,
        gender: json['gender'] as String?,
        schoolNumber: json['school_number'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
      return model;
    } catch (e) {
      rethrow;
    }
  }

  BrickHistoryResponseModel copyWith({
    int? id,
    String? description,
    int? amount,
    String? type,
    String? question,
    int? questionId,
    int? targetUserId,
    int? writerUserId,
    String? gender,
    String? schoolNumber,
    DateTime? createdAt,
  }) {
    return BrickHistoryResponseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      question: question ?? this.question,
      questionId: questionId ?? this.questionId,
      targetUserId: targetUserId ?? this.targetUserId,
      writerUserId: writerUserId ?? this.writerUserId,
      gender: gender ?? this.gender,
      schoolNumber: schoolNumber ?? this.schoolNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'type': type,
      'question': question,
      'question_id': questionId,
      'target_user_id': targetUserId,
      'writer_user_id': writerUserId,
      'gender': gender,
      'school_number': schoolNumber,
      'created_at': createdAt.toIso8601String(),
    };
  }
}