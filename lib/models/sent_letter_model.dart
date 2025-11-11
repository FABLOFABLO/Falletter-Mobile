class SentLetterModel {
  final int id;
  final String content;
  final int receptionId;
  final int senderId;
  final bool isDelivered;
  final DateTime createdAt;

  SentLetterModel({
    required this.id,
    required this.content,
    required this.receptionId,
    required this.senderId,
    required this.isDelivered,
    required this.createdAt,
  });

  factory SentLetterModel.fromJson(Map<String, dynamic> json) {
    try {
      return SentLetterModel(
        id: json['id'],
        content: json['content'],
        receptionId: json['reception_id'],
        senderId: json['sender_id'],
        isDelivered: json['is_delivered'] ?? false,
        createdAt: DateTime.parse(json['created_at']),
      );
    } catch (e) {
      rethrow;
    }
  }
}