// letter 모델 (임시)
import 'package:flutter_riverpod/legacy.dart';

class Letter {
  final String senderId;
  final String receiverId;
  final String title;
  final String content;
  final DateTime time;

  Letter({
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.content,
    required this.time,
  });
}

class LetterState {
  final int availableLetter;
  final List<Letter> sentLetters;
  final List<Letter> receivedLetters;

  LetterState({
    required this.availableLetter,
    required this.sentLetters,
    required this.receivedLetters,
  });

  LetterState copyWith({
    int? availableLetter,
    List<Letter>? sentLetters,
    List<Letter>? receivedLetters,
  }) {
    return LetterState(
      availableLetter: availableLetter ?? this.availableLetter,
      sentLetters: sentLetters ?? this.sentLetters,
      receivedLetters: receivedLetters ?? this.receivedLetters,
    );
  }
}

class LetterNotifier extends StateNotifier<LetterState> {
  LetterNotifier()
    : super(
        LetterState(
          availableLetter: 3, // 임시 개수 (실제 서버에서 받아오기)
          sentLetters: [],
          receivedLetters: [],
        ),
      );

  Future<void> fetchLetterFromServer() async {
    /// TODO: 실제 서버 호출로 변경
    await Future.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(availableLetter: 3);
  }

  void sendLetter({
    required String senderId,
    required String receiverId,
    required String title,
    required String content,
  }) {
    if (state.availableLetter <= 0) return;

    final newLetter = Letter(
      senderId: senderId,
      receiverId: receiverId,
      title: title,
      content: content,
      time: DateTime.now(),
    );

    final updatedLetter = [...state.sentLetters, newLetter];
    state = state.copyWith(
      availableLetter: state.availableLetter - 1,
      sentLetters: updatedLetter,
    );
  }

  void receiveLetter(Letter letter) {
    final updateReceived = [...state.receivedLetters, letter];
    state = state.copyWith(receivedLetters: updateReceived);
  }
}

final letterProvider = StateNotifierProvider<LetterNotifier, LetterState>(
  (ref) => LetterNotifier(),
);
