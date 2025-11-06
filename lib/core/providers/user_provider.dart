import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/services/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

final userInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(userServiceProvider);
  final data = await service.getUserInfo();

  return {
    'id': data['id'],
    'name': data['name'],
    'schoolNumber': data['schoolNumber'],
    'email': data['email'],
    'gender': data['gender'],
    'profileImage': data['profileImage'],
    // 서버에서 아직 미구현이라면 임시값
    'attendanceDays': 7,
    'letterCount': 0,
    'brickCount': 0,
  };
});