class UserModel {
  final int id;
  final String email;
  final String name;
  final String schoolNumber;
  final String gender;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.schoolNumber,
    required this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      schoolNumber: json['schoolNumber'],
      gender: json['gender'],
    );
  }
}
