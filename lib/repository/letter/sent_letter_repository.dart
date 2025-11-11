import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/models/sent_letter_model.dart';
import 'package:falletter/services/sent_letter_service.dart';

class SentLetterRepository {
  final SentLetterService _service;
  SentLetterRepository(this._service);

  Future<List<SentLetterModel>> fetchSentLetters() =>
      _service.fetchSentLetters();

  Future<SentLetterModel> fetchSentLetterDetail(int id) =>
      _service.fetchSentLetterDetail(id);
}

final sentLetterRepositoryProvider = Provider<SentLetterRepository>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰이 없습니다');
  return SentLetterRepository(SentLetterService(token));
});