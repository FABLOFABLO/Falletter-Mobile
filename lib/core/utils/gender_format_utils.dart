String genderFormat(String schoolNumber, String gender) {
  if (schoolNumber.isEmpty) return "알 수 없음";

  final grade = schoolNumber[0];
  final genderKorean = gender == "FEMALE" ? "여학생" : "남학생";

  return "${grade}학년 $genderKorean의 선택";
}
