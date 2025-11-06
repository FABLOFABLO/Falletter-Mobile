import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupState {
  final String? gender;
  final String? schoolNumber;
  final String? email;
  final String? password;
  final String? name;

  SignupState({
    this.gender,
    this.schoolNumber,
    this.email,
    this.password,
    this.name,
  });

  SignupState copyWith({
    String? gender,
    String? schoolNumber,
    String? email,
    String? password,
    String? name,
  }) {
    return SignupState(
      gender: gender ?? this.gender,
      schoolNumber: schoolNumber ?? this.schoolNumber,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }
}

class SignUpNotifier extends StateNotifier<SignupState> {
  SignUpNotifier() : super(SignupState());

  void setGender(String gender) =>
      state = state.copyWith(gender: gender);

  void setSchoolNumber(String number) =>
      state = state.copyWith(schoolNumber: number);

  void setEmail(String email) =>
      state = state.copyWith(email: email);

  void setPassword(String pw) =>
      state = state.copyWith(password: pw);

  void setName(String name) =>
      state = state.copyWith(name: name);
}

final signUpProvider = StateNotifierProvider<SignUpNotifier, SignupState>((ref) {
  return SignUpNotifier();
});
    