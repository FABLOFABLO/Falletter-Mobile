import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/core/providers/letter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/letter_model.dart';
import 'package:falletter/services/letter_service.dart';

class LetterRepository {
  final LetterService _service;

  LetterRepository(this._service);

  Future<String> sendLetter({
    required int receptionId,
    required String content,
  }) async {
    final letter = LetterModel(content: content, reception: receptionId);
    return await _service.sendLetter(letter);
  }

  Future<void> updateLetterCount({required int letterUpdate}) async {
    await _service.updateLetterCount(letterUpdate: letterUpdate);
  }
}

final letterRepositoryProvider = Provider<LetterRepository>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰 없음');
  final service = LetterService(token);
  return LetterRepository(service);
});
