import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final signUpStateProvider =
    StateNotifierProvider<SignUpNotifier, AsyncValue<String?>>((ref) {
      final authService = ref.read(authServiceProvider);
      return SignUpNotifier(authService);
    });

class SignUpNotifier extends StateNotifier<AsyncValue<String?>> {
  final AuthService _authService;

  SignUpNotifier(this._authService) : super(const AsyncData(null));

  Future<void> signUp({
    required String email,
    required String password,
    required String schoolNumber,
    required String name,
    required String gender,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        schoolNumber: schoolNumber,
        name: name,
        gender: gender,
      );
      state = AsyncData(result);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
