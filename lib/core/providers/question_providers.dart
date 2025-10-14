import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final totalQuestionsProvider = Provider<int>((ref) => 5);

enum AnswerState {
  answering,
  waiting,
}

final answerStateProvider = StateProvider<AnswerState>((ref) => AnswerState.answering);

final questionEmojisProvider = Provider<List<String>>((ref) => [
  '🎧',
  '🧭',
  '👀',
  '🌞',
  '💡',
]);

final questionsProvider = Provider<List<String>>((ref) => [
  '감수성이 풍부한 사람은 누구인가요?',
  '리더십이 뛰어난 사람은 누구인가요?',
  '분위기를 잘 읽는 사람은 누구인가요?',
  '항상 밝은 에너지를 주는 사람은?',
  '아이디어가 많은 사람은 누구인가요?',
]);

final allNamesProvider = Provider<List<String>>((ref) => [
  '김하늘', '오세훈', '홍길동', '유재석'
]);

final selectedIndexProvider = StateProvider<int?>((ref) => null);

final optionsProvider = Provider<List<String>>((ref) {
  final all = [...ref.watch(allNamesProvider)];
  all.shuffle();
  return all.take(4).toList();
});