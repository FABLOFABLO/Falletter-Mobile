import 'package:flutter_riverpod/flutter_riverpod.dart';

class RewardState {
  final int bricks;
  final int letters;
  final List<String> receivedLetters;

  RewardState({
    required this.bricks,
    required this.letters,
    required this.receivedLetters,
  });

  RewardState copyWith({
    int? bricks,
    int? letters,
    List<String>? receivedLetters,
  }) {
    return RewardState(
      bricks: bricks ?? this.bricks,
      letters: letters ?? this.letters,
      receivedLetters: receivedLetters ?? this.receivedLetters,
    );
  }
}

class RewardNotifier extends StateNotifier<RewardState> {
  RewardNotifier()
      : super(RewardState(bricks: 0, letters: 0, receivedLetters: [])) {
    loadFromServer();
  }

  Future<void> loadFromServer() async {
    await Future.delayed(const Duration(seconds: 1));

    /// 실제 서버 요청으로 변경 예정
    final serverData = {
      'letters': 2,
      'bricks': 3,
      'receivedLetters': ['안녕하세요', '너무 피곤해요'],
    };
    state = RewardState(
      bricks: serverData['bricks'] as int,
      letters: serverData['letters'] as int,
      receivedLetters: List<String>.from(serverData['receivedLetters'] as List<dynamic>),
    );
  }

  void addLetters(int count) {
    state = state.copyWith(letters: state.letters + count);
  }

  void addBricks(int count) {
    state = state.copyWith(bricks: state.bricks + count);
  }

  void addReceivedLetter(String letter) {
    state = state.copyWith(
      receivedLetters: [...state.receivedLetters, letter],
    );
  }
}

final rewardProvider =
StateNotifierProvider<RewardNotifier, RewardState>((ref) {
  return RewardNotifier();
});
