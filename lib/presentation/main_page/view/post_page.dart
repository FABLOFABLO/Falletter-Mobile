import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/services/post_service.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final int maxLength = 200;
  bool _isLoading = false;

  bool get isFilled =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty;

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

  Future<void> _submitPost() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final accessToken = ref.read(accessTokenProvider);

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final postService = PostService(accessToken);
    final success = await postService.createPost(title, content);

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        Navigator.pop(context, {'modified': true});
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('게시물 등록 중 오류가 발생했습니다.')),
        );
      }
    }
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
                    const Spacer(),
                    CustomElevatedButton(
                      width: double.infinity,
                      onPressed: isFilled && !_isLoading ? _submitPost : null,
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: FalletterColor.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('글 등록하기'),
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
