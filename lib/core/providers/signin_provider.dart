import 'package:falletter/core/providers/auth_provider.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final signInStateProvider =
StateNotifierProvider<SignInNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  final authService = ref.read(authServiceProvider);
  return SignInNotifier(authService, ref);
});

class SignInNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AuthService _authService;
  final Ref _ref;

  SignInNotifier(this._authService, this._ref) : super(const AsyncData(null));

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      if (result != null && result['access_token'] != null) {
        _ref.read(accessTokenProvider.notifier).state = result['access_token'];
      }

      state = AsyncData(result);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  void reset() {
    state = const AsyncData(null);
  }
}