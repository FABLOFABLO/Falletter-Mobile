import 'package:falletter/core/providers/letter_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';

class LetterPage extends ConsumerStatefulWidget {
  const LetterPage({super.key});

  @override
  ConsumerState<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends ConsumerState<LetterPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int maxLength = 200;

  bool get isTitleValid {
    final text = _titleController.text.trim();
    if (text.isEmpty) return false;
    final parts = text.split(' ');
    if (parts.length != 2) return false;

    final studentId = parts[0];
    final name = parts[1];
    if (studentId.length != 4) return false;
    if (!RegExp(r'^\d{4}$').hasMatch(studentId)) return false;
    if (name.isEmpty) return false;
    if (!RegExp(r'^[가-힣]+$').hasMatch(name)) return false;

    return true;
  }

  bool get isContentValid => _contentController.text.trim().isNotEmpty;

  bool get isFormValid => isTitleValid && isContentValid;

  String get senderInfo {
    final text = _titleController.text.trim();
    if (text.isEmpty) return '';
    final parts = text.split(' ');
    if (parts.length != 2) return '';
    final studentId = parts[0];
    final name = parts[1];
    return '$studentId $name';
  }

  void _showSubmissionOverlay(ThemeColors themeColors) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$senderInfo에게\n레터를 전송할게요.',
                  style: FalletterTextStyle.body1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  themeColors.sendLetterLottie,
                  width: 200,
                  height: 131,
                  fit: BoxFit.cover,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (mounted) Navigator.of(context).pop();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  '레터는 지금부터 12시간 후에 도착합니다.',
                  style: FalletterTextStyle.body3.copyWith(
                    color: FalletterColor.gray200,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitLetter() async {
    if (!isFormValid) return;

    final letterState = ref.read(letterProvider.notifier);
    final selectedTheme = ref.read(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    if (letterState.state.availableLetter <= 0) return;

    letterState.sendLetter(
      senderId: 'me', // 실제 사용자 id로 변경 예정
      receiverId: _titleController.text.trim(),
      title: senderInfo,
      content: _contentController.text.trim(),
    );

    _showSubmissionOverlay(themeColors);

    _titleController.clear();
    _contentController.clear();
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
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;
    final letterState = ref.watch(letterProvider);

    final isEnabled = letterState.availableLetter > 0;

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
                    themeColors.letterSvg,
                    width: 38,
                    height: 26,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${letterState.availableLetter}개',
                    style: FalletterTextStyle.body1.copyWith(
                      color:
                          letterState.availableLetter > 0
                              ? FalletterColor.white
                              : FalletterColor.gray500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '누구에게 보내시나요?',
              style: FalletterTextStyle.subTitle1.copyWith(
                color:
                    isEnabled ? FalletterColor.white : FalletterColor.gray500,
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
                    color:
                        isEnabled
                            ? FalletterColor.white
                            : FalletterColor.gray500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${_contentController.text.length}',
                      style: FalletterTextStyle.body2.copyWith(
                        color:
                            isEnabled
                                ? FalletterColor.white
                                : FalletterColor.gray500,
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
                decoration: const InputDecoration(
                  counterText: '',
                ),
              ),
            ),
            const Spacer(),
            CustomElevatedButton(
              width: double.infinity,
              onPressed: (isFormValid && isEnabled) ? _submitLetter : null,
              child: const Text('레터 전송하기'),
            ),
          ],
        ),
      ),
    );
  }
}
