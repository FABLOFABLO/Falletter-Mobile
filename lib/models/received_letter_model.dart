class ReceivedLetterModel {
  final int id;
  final String content;
  final bool isDelivered;
  final bool isPassed;
  final int receptionId;
  final DateTime createdAt;

  ReceivedLetterModel({
    required this.id,
    required this.content,
    required this.isDelivered,
    required this.isPassed,
    required this.receptionId,
    required this.createdAt,
  });

  factory ReceivedLetterModel.fromJson(Map<String, dynamic> json) {
    return ReceivedLetterModel(
      id: json['id'],
      content: json['content'],
      isDelivered: json['is_delivered'],
      isPassed: json['is_passed'],
      receptionId: json['reception_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
