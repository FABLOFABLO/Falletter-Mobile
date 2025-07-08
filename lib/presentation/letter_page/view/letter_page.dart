import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';

class LetterPage extends StatefulWidget {
  const LetterPage({super.key});

  @override
  State<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<LetterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int maxLength = 200;

  int currentIndex = 1;

  bool get isTitleValid {
    final text = _titleController.text.trim();
    if (text.isEmpty) return false;

    final parts = text.split(' ');
    if (parts.length < 2) return false;

    final studentId = parts[0];
    final name = parts.sublist(1).join(' ');

    if (studentId.length != 4) return false;
    if (!RegExp(r'^\d{4}$').hasMatch(studentId)) return false;

    if (name.isEmpty) return false;
    if (!RegExp(r'^[가-힣\s]+$').hasMatch(name)) return false;

    return true;
  }

  bool get isContentValid => _contentController.text.trim().isNotEmpty;
  bool get isFormValid => isTitleValid && isContentValid;
bool get isEnabled => _titleController.text.isNotEmpty || _contentController.text.isNotEmpty;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icon/letter.svg',
                    width: 38,
                    height: 26,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEnabled ? '1개' : '0개',
                    style: FalletterTextStyle.body1.copyWith(
                      color: isEnabled ? FalletterColor.white : FalletterColor.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '누구에게 보내시나요?',
              style: FalletterTextStyle.subTitle1.copyWith(
                color: isEnabled ? FalletterColor.white : FalletterColor.gray500,
              ),
            ),
            const SizedBox(height: 16),
            IgnorePointer(
              ignoring: !isEnabled,
              child: CustomTextFormField(
                controller: _titleController,
                decoration: InputDecoration(enabled: isEnabled),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '레터를 작성해주세요',
                  style: FalletterTextStyle.subTitle1.copyWith(
                    color: isEnabled ? FalletterColor.white : FalletterColor.gray500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_contentController.text.length}',
                      style: FalletterTextStyle.body2.copyWith(
                        color: isEnabled ? FalletterColor.white : FalletterColor.gray500,
                      ),
                    ),
                    Text(
                      '/$maxLength',
                      style: FalletterTextStyle.body2.copyWith(
                        color: FalletterColor.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            IgnorePointer(
              ignoring: !isEnabled,
              child: CustomTextFormField(
                controller: _contentController,
                maxLines: 7,
                maxLength: maxLength,
                decoration: InputDecoration(enabled: isEnabled,counterText: ''),
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
              width: double.infinity,
              onPressed: isFormValid
                  ? () {
                print('레터 전송됨');
              }
                  : null,
              child: const Text('레터 전송하기'),
            ),
          ],
        ),
      ),
    );
  }
}