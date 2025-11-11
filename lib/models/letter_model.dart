class LetterModel {
  final String content;
  final int reception;

  LetterModel({
    required this.content,
    required this.reception,
  });

  Map<String, dynamic> toJson() {
    return {
      'content' : content,
      'reception' : reception,
    };
  }

  factory LetterModel.fromJson(Map<String, dynamic> json) {
    return LetterModel(
      content: json['content'],
      reception: json['reception'],
    );
  }
}
