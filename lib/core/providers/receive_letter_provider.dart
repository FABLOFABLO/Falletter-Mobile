import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/repository/letter/received_letter_repository.dart';
import 'package:falletter/services/received_letter_service.dart';

final receivedLetterServiceProvider = Provider<ReceivedLetterService>((ref) {
  return ReceivedLetterService();
});

final receivedLetterRepositoryProvider =
Provider<ReceivedLetterRepository>((ref) {
  final service = ref.watch(receivedLetterServiceProvider);
  return ReceivedLetterRepository(service);
});

final receivedLettersProvider =
FutureProvider<List<ReceivedLetterModel>>((ref) async {
  final token = ref.watch(accessTokenProvider);

  if (token == null) {
    throw Exception('토큰이 없습니다. 로그인 후 다시 시도해주세요.');
  }

  final repo = ref.watch(receivedLetterRepositoryProvider);
  return await repo.getReceivedLetters(token);
});
