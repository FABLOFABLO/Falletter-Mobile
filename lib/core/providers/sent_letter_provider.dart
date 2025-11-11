import 'package:falletter/repository/letter/sent_letter_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/sent_letter_model.dart';
import 'package:falletter/core/providers/student_provider.dart';

class SentLetterViewModel extends SentLetterModel {
  final String receiverDisplayName;

  SentLetterViewModel({
    required super.id,
    required super.content,
    required super.receptionId,
    required super.senderId,
    required super.isDelivered,
    required super.createdAt,
    required this.receiverDisplayName,
  });
}

final sentLettersProvider = FutureProvider<List<SentLetterViewModel>>((ref) async {
  try {
    final sentLetterRepo = ref.watch(sentLetterRepositoryProvider);
    final sentLetters = await sentLetterRepo.fetchSentLetters();
    final studentsAsync = ref.watch(studentsProvider);
    final students = studentsAsync.maybeWhen(
      data: (list) {
        return list;
      },
      orElse: () {
        return [];
      },
    );

    final studentMap = {for (var s in students) s.id: s};
    final viewModels = sentLetters.map((letter) {
      final student = studentMap[letter.receptionId];
      return SentLetterViewModel(
        id: letter.id,
        content: letter.content,
        receptionId: letter.receptionId,
        senderId: letter.senderId,
        isDelivered: letter.isDelivered,
        createdAt: letter.createdAt,
        receiverDisplayName: student?.displayText ?? '알 수 없음 (${letter.receptionId})',
      );
    }).toList();

    return viewModels;
  } catch (e) {
    rethrow;
  }
});