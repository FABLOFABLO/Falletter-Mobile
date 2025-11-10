class StudentModel {
  final int id;
  final String schoolNumber;
  final String name;

  StudentModel({
    required this.id,
    required this.schoolNumber,
    required this.name,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      schoolNumber: json['school_number'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_number': schoolNumber,
      'name': name,
    };
  }

  String get displayText => '$schoolNumber $name';
}