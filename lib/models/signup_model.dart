class SignUpModel {
  final String email;
  final String password;
  final String schoolNumber;
  final String name;
  final String gender;

  SignUpModel({
    required this.email,
    required this.password,
    required this.schoolNumber,
    required this.name,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'school_number': schoolNumber,
    'name': name,
    'gender': gender,
  };
}