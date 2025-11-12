import 'package:falletter/core/components/comment/comment_item.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/default_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/components/button/send_button.dart';
import 'package:falletter/presentation/main_page/component/post_detail.dart';
import 'package:falletter/presentation/main_page/view/post_edit_page.dart';
import 'package:falletter/core/providers/post_comment_provider.dart';
import 'package:falletter/core/providers/nickname_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostDetailPage extends ConsumerStatefulWidget {
  final int postId;
  final String title;
  final String content;
  final String nickname;
  final DateTime time;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.title,
    required this.content,
    required this.nickname,
    required this.time,
  });

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  bool isCommentFilled = false;
  bool _isModified = false;
  bool _isDeleted = false;

  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _content = widget.content;
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    _commentController.addListener(() {
      setState(() {
        isCommentFilled = _commentController.text.trim().isNotEmpty;
      });
    });
  }

  void _showDeleteConfirmDialog(BuildContext context, int postId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DefaultModal(
        title: '게시물 삭제',
        description: '게시물이 영구 삭제됩니다.\n정말 삭제하시겠어요?',
        leftText: '취소',
        rightText: '삭제',
        onLeftPressed: () => Navigator.of(ctx).pop(),
        onRightPressed: () async {
          Navigator.of(ctx).pop();
          final notifier = ref.read(postsProvider.notifier);
          await notifier.deletePost(postId);
          setState(() => _isDeleted = true);
          if (mounted) Navigator.pop(context, {'deleted': true});
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
                _showDeleteConfirmDialog(context, widget.postId);
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
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostEditPage(title: _title, content: _content),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _content = result;
                    _isModified = true;
                  });
                  final notifier = ref.read(postsProvider.notifier);
                  await notifier.updatePost(widget.postId, _title, _content);
                  ref.invalidate(postsProvider);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleBackNavigation() {
    if (_isDeleted) {
      Navigator.pop(context);
      return;
    }
    if (_isModified) {
      Navigator.pop(context, {'title': _title, 'content': _content});
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(postsProvider.notifier);
    final posts = ref.watch(postsProvider);
    final post = posts.firstWhere(
          (p) => p.id == widget.postId,
      orElse: () => posts.first,
    );

    final nicknameNotifier = ref.read(nicknameProvider.notifier);
    final postNickname = nicknameNotifier.getOrCreateNickname(post.id, post.authorName);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBackNavigation();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Header(showBackButton: true, onBack: _handleBackNavigation),
              Padding(
                padding: const EdgeInsets.all(20),
                child: PostHeaderCard(
                  nickname: postNickname, // 글 작성자 닉네임
                  time: timeago.format(widget.time.toLocal(), locale: 'ko'),
                  title: _title,
                  content: _content,
                  onMorePressed: _showActionDialog,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    final comment = post.comments[index];

                    final commentNickname =
                    nicknameNotifier.getOrCreateNickname(post.id, comment.username);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CommentItem(
                        nickname: commentNickname,
                        time: timeago.format(comment.createdAt.toLocal(), locale: 'ko'),
                        text: comment.comment,
                        isAuthor: false,
                        onDelete: () async {
                          await notifier.deleteComment(post.id, comment.id);
                          ref.invalidate(postsProvider);
                        },
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: '댓글을 입력하세요',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SendButton(
                      isEnabled: isCommentFilled,
                      onPressed: () async {
                        final text = _commentController.text.trim();
                        if (text.isEmpty) return;
                        await notifier.addComment(widget.postId, text);
                        _commentController.clear();
                        ref.invalidate(postsProvider);
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