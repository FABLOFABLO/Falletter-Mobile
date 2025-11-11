import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/models/student_model.dart';

class StudentSearchDropdown extends StatelessWidget {
  final List<StudentModel> students;
  final String query;
  final bool isSearching;
  final Function(StudentModel) onSelect;

  const StudentSearchDropdown({
    super.key,
    required this.students,
    required this.query,
    required this.isSearching,
    required this.onSelect,
  });

  List<TextSpan> _highlightText(String text, String query) {
    final spans = <TextSpan>[];
    final lower = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    int start = 0;

    while (start < text.length) {
      final index = lower.indexOf(lowerQuery, start);
      if (index == -1) {
        spans.add(TextSpan(
          text: text.substring(start),
          style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray400),
        ));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray400),
        ));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.white),
      ));
      start = index + query.length;
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (students.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '검색 결과가 없습니다',
          style: FalletterTextStyle.body2.copyWith(color: FalletterColor.gray400),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: students.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final student = students[index];
        final text = '${student.schoolNumber} ${student.name}';
        return InkWell(
          onTap: () => onSelect(student),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: RichText(
              text: TextSpan(children: _highlightText(text, query)),
            ),
          ),
        );
      },
    );
  }
}