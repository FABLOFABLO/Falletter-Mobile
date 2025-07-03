import 'package:falletter/core/components/bottom_navigation_bar.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class PostEditPage extends StatefulWidget {
  final String title;
  final String content;

  const PostEditPage({super.key, required this.title, required this.content});

  @override
  State<PostEditPage> createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  late TextEditingController _contentController;
  bool isButtonEnabled = false;
  final int maxLength = 200;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.content);

    isButtonEnabled = _contentController.text.trim().isNotEmpty;

    _contentController.addListener(() {
      setState(() {
        isButtonEnabled = _contentController.text.trim().isNotEmpty;
      });
    });
  }

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(showBackButton: true),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 46),
                    Text(
                      '제목을 입력해주세요',
                      style: FalletterTextStyle.subTitle1.copyWith(
                        color: FalletterColor.gray500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      style: FalletterTextStyle.placeholder.copyWith(color: FalletterColor.gray700),
                      controller: TextEditingController(text: widget.title),
                      decoration: InputDecoration(
                        enabled: false,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('내용을 입력해주세요', style: FalletterTextStyle.subTitle1),
                        Row(
                          children: [
                            Text(
                              '${_contentController.text.length}',
                              style: FalletterTextStyle.body2.copyWith(
                                color: FalletterColor.white,
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
                    CustomTextFormField(
                      controller: _contentController,
                      maxLines: 7,
                      maxLength: maxLength,
                      decoration: InputDecoration(
                        hintText: '내용을 입력해주세요',
                        filled: true,
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 194),
                    CustomElevatedButton(
                      width: double.infinity,
                      onPressed: isButtonEnabled ? _submit : null,
                      child: const Text('수정하기'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    Navigator.pop(context, _contentController.text.trim());
  }
}
