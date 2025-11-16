import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/services/received_letter_service.dart';

class ReceivedLetterRepository {
  final ReceivedLetterService service;

  ReceivedLetterRepository(this.service);

  Future<List<ReceivedLetterModel>> getReceivedLetters(String token) async {
    return await service.fetchReceivedLetters(token);
  }
}