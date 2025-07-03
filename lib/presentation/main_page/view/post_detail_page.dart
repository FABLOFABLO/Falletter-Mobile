import 'package:falletter/core/components/comment/comment_item.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/header/post_detail.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/components/button/send_button.dart';
import 'package:falletter/core/components/modal/default_modal.dart';
import 'package:falletter/presentation/main_page/view/post_edit_page.dart';

class PostDetailPage extends StatefulWidget {
  final String title;
  final String content;
  final String nickname;
  final String time;

  const PostDetailPage({
    super.key,
    required this.title,
    required this.content,
    required this.nickname,
    required this.time,
  });

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isCommentFilled = false;

  late String _title;
  late String _content;
  bool _isModified = false;
  bool _isDeleted = false;

  final int currentUserId = 1;

  List<Map<String, dynamic>> comments = [
    {
      'id': 2,
      'userId': 2,
      'nickname': '다람쥐통',
      'time': '25분 전',
      'text': '저도 들었어요!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _content = widget.content;

    _commentController.addListener(() {
      setState(() {
        isCommentFilled = _commentController.text.trim().isNotEmpty;
      });
    });
  }

  void _showDeleteConfirmDialog(BuildContext dialogContext) {
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) => DefaultModal(
        title: '게시물 삭제',
        description: '게시물이 영구 삭제됩니다.\n정말 삭제하시겠어요?',
        leftText: '취소',
        rightText: '삭제',
        onLeftPressed: () => Navigator.of(context).pop(),
        onRightPressed: () {
          Navigator.of(context).pop();
          setState(() {
            _isDeleted = true;
          });
          Navigator.pop(context, {'deleted': true});
        },
      ),
    );
  }

  void _showActionDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: FalletterColor.middleBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Center(
                child: Text(
                  '삭제',
                  style: FalletterTextStyle.button.copyWith(
                    color: FalletterColor.error,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmDialog(context);
              },
            ),
            const Divider(height: 1, color: FalletterColor.gray900),
            ListTile(
              title: Center(
                child: Text(
                  '수정',
                  style: FalletterTextStyle.button.copyWith(
                    color: FalletterColor.gray50,
                  ),
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                await Future.delayed(Duration.zero);

                if (!mounted) return;

                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostEditPage(title: _title, content: _content),
                  ),
                );

                if (result != null && mounted) {
                  setState(() {
                    _content = result;
                    _isModified = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleBackNavigation() {
    if (_isDeleted) {
      Navigator.pop(context);
      return;
    }
    if (_isModified) {
      Navigator.pop(context, {
        'title': _title,
        'content': _content,
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Header(
                showBackButton: true,
                onBack: _handleBackNavigation,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PostHeaderCard(
                  nickname: widget.nickname,
                  time: widget.time,
                  title: _title,
                  content: _content,
                  onMorePressed: _showActionDialog,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final isAuthor = comment['userId'] == currentUserId;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CommentItem(
                        nickname: comment['nickname'],
                        time: comment['time'],
                        text: comment['text'],
                        isAuthor: isAuthor,
                        onDelete: isAuthor
                            ? () => setState(() => comments.removeAt(index))
                            : null,
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: FalletterColor.gray900, width: 1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _commentController,
                        decoration: const InputDecoration(hintText: 'Placeholder'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SendButton(
                      isEnabled: isCommentFilled,
                      onPressed: () {
                        final text = _commentController.text.trim();
                        if (text.isEmpty) return;

                        setState(() {
                          comments.add({
                            'id': comments.length + 1,
                            'userId': currentUserId,
                            'nickname': 'Nickname',
                            'time': 'Time',
                            'text': text,
                          });
                          _commentController.clear();
                          isCommentFilled = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}