import 'package:dio/dio.dart';
import 'package:falletter/models/student_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StateProvider<int>((ref) => 1);
final currentUserNicknameProvider = StateProvider<String>((ref) => '유저');

final userInfoProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.read(userServiceProvider);
  final accessToken = ref.watch(accessTokenProvider);

  if (accessToken == null) {
    throw Exception('토큰이 없습니다. 로그인 후 이용해주세요.');
  }

  try {
    final results = await Future.wait([
      service.getUserInfo(accessToken),
      service.getLetterCount(accessToken),
      service.getBrickCount(accessToken),
    ]);

    final userData = results[0] as Map<String, dynamic>;
    final letterCount = results[1] as int;
    final brickCount = results[2] as int;

    return {
      'name': userData['name'],
      'schoolNumber': userData['schoolNumber'],
      'email': userData['email'],
      'gender': userData['gender'],
      'profileImage': userData['profileImage'],
      'letterCount': letterCount,
      'brickCount': brickCount,
      'attendanceDays': 7, // 임시값
    };
  } on DioException catch (e) {
    throw Exception('유저 정보 조회 실패: ${e.response?.statusCode}');
  } catch (e) {
    throw Exception('알 수 없는 오류: $e');
  }
});

final currentUserInfoProvider = Provider<StudentModel?>((ref) {
  final userInfoAsync = ref.watch(userInfoProvider);

  return userInfoAsync.maybeWhen(
    data: (data) => StudentModel(
      id: data['id'],
      schoolNumber: data['schoolNumber'],
      name: data['name'],
    ),
    orElse: () => null,
  );
});
