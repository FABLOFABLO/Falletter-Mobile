import 'package:flutter_riverpod/flutter_riverpod.dart';

// 받은 레터 데이터 모델 예시
class ReceivedLetter {
  final String receiptientInfo;
  final DateTime receivedAt;
  final String content;

  ReceivedLetter({
    required this.receiptientInfo,
    required this.receivedAt,
    required this.content,
  });
}

// 더미 데이터
final List<ReceivedLetter> _initialReceivedLetters = [
  ReceivedLetter(
    receiptientInfo: '2114정지윤',
    receivedAt: DateTime.now().subtract(const Duration(days: 1)),
    content: '안녕하세요! 다름이 아니라 저번에 발표했던 자료에 대해서 질문이 있어서 연락드렸습니다. 안녕하세요! 다름이 아니라 저번에 발표했던 자료에 대해서 질문이 있어서 연락드렸습니다. 안녕하세요! 다름이 아니라 저번에 발표했던 자료에 대해서 질문이 있어서 연락드렸습니다. 안녕하세요! 다름이 아니라 저번에 발표했던 자료에 대해서 질문이 있어서 연락드렸습니다. ',
  ),
  ReceivedLetter(
    receiptientInfo: '2114정지윤',
    receivedAt: DateTime.now().subtract(const Duration(hours: 10)),
    content: '요즘 날씨가 많이 쌀쌀해졌는데, 감기 조심하세요! 요즘 날씨가 많이 쌀쌀해졌는데, 감기 조심하세요! 요즘 날씨가 많이 쌀쌀해졌는데, 감기 조심하세요! 요즘 날씨가 많이 쌀쌀해졌는데, 감기 조심하세요! ',
  ),
  ReceivedLetter(
    receiptientInfo: '2114정지윤',
    receivedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    content: '안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? 안녕하세요 잘 지내시요? ',
  ),
];

final receivedLettersProvider = StateProvider<List<ReceivedLetter>>((ref) {
  // 서버에서 데이터를 가져오거나 로컬 DB를 사용
  return _initialReceivedLetters;
});
