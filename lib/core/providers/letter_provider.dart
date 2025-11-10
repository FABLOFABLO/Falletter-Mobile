import 'package:falletter/models/letter_model.dart';
import 'package:falletter/services/letter_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_token_provider.dart';

final letterServiceProvider = Provider<LetterService>((ref) {
  final token = ref.watch(accessTokenProvider);
  if (token == null) throw Exception('토큰이 없습니다.');
  return LetterService(token);
});

final sendLetterProvider = FutureProvider.family<String, LetterModel>((
  ref,
  letter,
) async {
  final service = ref.read(letterServiceProvider);
  if (service == null) throw Exception('로그인 토큰이 없습니다.');
  return await service.sendLetter(letter);
});
