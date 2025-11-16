import 'dart:math';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/services/question_service.dart';
import 'package:falletter/services/student_service.dart';
import 'package:falletter/models/question_model.dart';
import 'package:falletter/models/student_model.dart';

final questionServiceProvider = Provider<QuestionService>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  return QuestionService(token);
});

final studentServiceProvider = Provider<StudentService>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  return StudentService(token);
});

final allQuestionsProvider = FutureProvider<List<QuestionModel>>((ref) async {
  final service = ref.read(questionServiceProvider);
  try {
    return await service.fetchQuestions();
  } catch (e) {
    return [];
  }
});

final allStudentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  final service = ref.read(studentServiceProvider);
  final userInfoAsync = ref.watch(userInfoProvider);

  return userInfoAsync.maybeWhen(
    data: (userInfo) async {
      try {
        final currentUserSchoolNumber = userInfo['schoolNumber'] as String?;
        final currentUserName = userInfo['name'] as String?;

        return await service.fetchStudents(
          currentUserSchoolNumber: currentUserSchoolNumber,
          currentUserName: currentUserName,
        );
      } catch (e) {
        return [];
      }
    },
    orElse: () async => [],
  );
});

final selectedQuestionsProvider = Provider<List<QuestionModel>>((ref) {
  final allQuestionsAsync = ref.watch(allQuestionsProvider);

  return allQuestionsAsync.maybeWhen(
    data: (questions) {
      if (questions.isEmpty) return [];

      final shuffled = [...questions];
      shuffled.shuffle(Random());
      return shuffled.take(5).toList();
    },
    orElse: () => [],
  );
});

final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);
final totalQuestionsProvider = Provider<int>((ref) => 5);
enum AnswerState {
  answering,
  waiting,
}

final answerStateProvider = StateProvider<AnswerState>((ref) => AnswerState.answering);
final selectedIndexProvider = StateProvider<int?>((ref) => null);
final currentQuestionOptionsProvider = Provider<List<StudentModel>>((ref) {
  final currentIndex = ref.watch(currentQuestionIndexProvider);
  final allStudentsAsync = ref.watch(allStudentsProvider);

  return allStudentsAsync.maybeWhen(
    data: (students) {
      if (students.isEmpty) {
        return List.generate(
          4,
              (index) => StudentModel(
            id: -1 - index,
            name: '유저',
            schoolNumber: '',
          ),
        );
      }

      final shuffled = [...students];
      final seed = currentIndex * 1000;
      shuffled.shuffle(Random(seed));

      final selected = <StudentModel>[];
      for (int i = 0; i < 4; i++) {
        if (i < shuffled.length) {
          selected.add(shuffled[i]);
        } else {
          selected.add(StudentModel(
            id: -1 - i,
            name: '유저',
            schoolNumber: '',
          ));
        }
      }

      return selected;
    },
    orElse: () => [],
  );
});

final submitAnswerProvider = Provider<Future<void> Function(int questionId, int targetUserId)>((ref) {
  return (questionId, targetUserId) async {
    final service = ref.read(questionServiceProvider);
    try {
      await service.submitSelectedStudent(
        questionId: questionId,
        targetUserId: targetUserId,
      );
    } catch (e) {
      rethrow;
    }
  };
});