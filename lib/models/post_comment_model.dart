DateTime parseServerTime(String dateStr) {
  if (!dateStr.endsWith('Z')) {
    dateStr = '${dateStr}Z';
  }
  return DateTime.parse(dateStr).toLocal();
}

class PostModel {
  final int id;
  final String title;
  final String content;
  final String authorName;
  final int authorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CommentModel> comments;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.authorName,
    required this.authorId,
    required this.createdAt,
    required this.updatedAt,
    required this.comments,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final commentsJson = json['comment'] as List? ?? [];
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      authorName: json['author']['name'],
      authorId: json['author']['user_id'] ?? json['author']['id'],
      createdAt: parseServerTime(json['created_at']),
      updatedAt: parseServerTime(json['updated_at']),
      comments: commentsJson.map((e) => CommentModel.fromJson(e)).toList(),
    );
  }

  PostModel copyWith({
    int? id,
    String? title,
    String? content,
    String? authorName,
    int? authorId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      authorId: authorId ?? this.authorId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }
}

class CommentModel {
  final int id;
  final int userId;
  final String username;
  final String comment;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.comment,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['comment_id'],
      userId: json['user']['user_id'],
      username: json['user']['name'],
      comment: json['comment'],
      createdAt: parseServerTime(json['created_at']),
    );
  }
}