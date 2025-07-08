import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int maxLength = 200;

  bool get isFilled =>
      _titleController.text.trim().isNotEmpty &&
          _contentController.text.trim().isNotEmpty;

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  void _onChanged() {
    setState(() {});
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
      body: SafeArea(
        child: Column(
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
                      style: FalletterTextStyle.subTitle1,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        hintText: 'Placeholder',
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '내용을 입력해주세요',
                          style: FalletterTextStyle.subTitle1,
                        ),
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
                      decoration: const InputDecoration(counterText: ''),
                    ),
                    const SizedBox(height: 194),
                    CustomElevatedButton(
                      width: double.infinity,
                      onPressed: isFilled
                          ? () {
                        final post = {
                          'title': _titleController.text.trim(),
                          'content': _contentController.text.trim(),
                        };
                        Navigator.pop(context, post);
                      }
                          : null,
                      child: const Text('글 등록하기'),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}