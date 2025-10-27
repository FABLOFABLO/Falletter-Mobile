import 'package:flutter_riverpod/flutter_riverpod.dart';

// 데이터 모델
class SentLetter {
  final String dear;
  final String recipientInfo;
  final String content;
  final DateTime? sentAt;

  SentLetter({
    required this.dear,
    required this.recipientInfo,
    required this.content,
    required this.sentAt,
  });
}

// Riverpod Provider (예시 데이터)
final sentLettersProvider = Provider<List<SentLetter>>((ref) {
  return [
    SentLetter(
      dear: '윤도영',
      recipientInfo: '윤도영',
      content: '안녕하세요! 잘 지내시죠?',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    SentLetter(
      dear: '윤도영',
      recipientInfo: '윤도영',
      content: '안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠?',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    SentLetter(
      dear: '서진수',
      recipientInfo: '서진수',
      content: '안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 다음에 한 번 봬요. 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 다음에 한 번 봬요. 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 다음에 한 번 봬요. 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 다음에 한 번 봬요. 안녕하세요! 잘 지내시죠? 그동안 별 일은 없으셨죠? 다음에 한 번 봬요. ',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    // 추가 데이터...
  ];
});
