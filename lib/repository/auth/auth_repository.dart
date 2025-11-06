import 'package:falletter/core/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/models/signup_model.dart';
import 'package:falletter/services/auth_service.dart';

class AuthRepository {
  final AuthService _service;

  AuthRepository(this._service);

  Future<String> signUp(SignUpModel model) async {
    return await _service.signUp(
      email: model.email,
      password: model.password,
      schoolNumber: model.schoolNumber,
      name: model.name,
      gender: model.gender,
    );
  }

  Future<String> sendVerificationCode(String email) async {
    return await _service.sendVerificationCode(email);
  }

  Future<String> verifyCodeMatch(String email, String code) async {
    return await _service.verifyCodeMatch(email: email, code: code);
  }

  Future<dynamic> login(String email, String password) async {
    return await _service.login(email: email, password: password);
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.read(authServiceProvider);
  return AuthRepository(service);
});
