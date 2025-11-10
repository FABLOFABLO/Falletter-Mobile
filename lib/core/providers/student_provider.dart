import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/student_model.dart';
import 'package:falletter/services/student_service.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';

final studentServiceProvider = Provider<StudentService?>((ref) {
  final accessToken = ref.watch(accessTokenProvider);
  if (accessToken == null) return null;
  return StudentService(accessToken);
});

final studentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  final service = ref.watch(studentServiceProvider);
  if (service == null) return [];

  try {
    final students = await service.fetchStudents();
    return students;
  } catch (e) {
    return [];
  }
});