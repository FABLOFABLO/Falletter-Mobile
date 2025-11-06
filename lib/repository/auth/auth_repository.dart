import 'package:falletter/models/signup_model.dart';
import 'package:falletter/services/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<String> signUp(SignUpModel model) async {
    return await _service.signUp(
      email: model.email,
      password: model.password,
      schoolNumber: model.schoolNumber,
      name: model.name,
      gender: model.gender,
    );
  }
}