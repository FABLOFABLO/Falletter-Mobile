import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/models/student_model.dart';
import 'package:falletter/services/student_service.dart';

Future<List<StudentModel>> searchStudents({
  required WidgetRef ref,
  required String query,
}) async {
  if (query.trim().isEmpty) return [];

  final token = ref.read(accessTokenProvider);
  if (token == null) return [];

  final userInfo = await ref.read(userInfoProvider.future);
  final currentNumber = userInfo['schoolNumber'];
  final currentName = userInfo['name'];

  final service = StudentService(token);
  final students = await service.fetchStudents(
    currentUserSchoolNumber: currentNumber,
    currentUserName: currentName,
  );

  final lowerQuery = query.toLowerCase();
  return students.where((s) {
    return s.schoolNumber.toLowerCase().contains(lowerQuery) ||
        s.name.toLowerCase().contains(lowerQuery);
  }).toList();
}