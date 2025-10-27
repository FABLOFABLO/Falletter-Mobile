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
      content: '와 진짜 너무 보고 싶은데 진짜 보지를 못하니까 미쳐버릴것 같아요...ㅠㅠ 지금 당장 네덜란드로 튀어가고 싶은데, 지금 당장이라도 너무 보고 싶어요ㅠ 확실히 몸이 멀어지니 마음도 멀어지는 것 같지만, 언젠가는 만나게 될 날이 있겠죠ㅠ',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    SentLetter(
      dear: '서진수',
      recipientInfo: '서진수',
      content: '와 진짜 주민규가 슈팅 연습하다가 맞은 애기한테 끝나고 유니폼을 줬는데, 나도 서진수 공에 맞아서 서진수 유니폼 받고 싶다... 아니 음 근데 생일선물을 이미 줘서 선물 주기엔 너무 썡뚱맞은 타이밍인가 싶지만, 대전에서 수고 많았다고 주고 싶은데 어떤 선물을 주는게 서진수 선수가 호불호 없이 쓸 수 있을까.. 모루 꽃다발은 먼지 쌓이면 약간 골칫거리에 짐만 될 것 같고, 그렇다고 쿠키나 그런걸 해주자니 집에 있는 재료를 쓰기에 엄마 눈치 개보이는데',
      sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    // 추가 데이터...
  ];
});
