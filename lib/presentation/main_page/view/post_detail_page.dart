import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/presentation/main_page/component/post_detail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:falletter/core/components/comment/comment_item.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/default_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/components/button/send_button.dart';
import 'package:falletter/presentation/main_page/view/post_edit_page.dart';
import 'package:falletter/core/providers/post_comment_provider.dart';
import 'package:falletter/core/providers/nickname_provider.dart';

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
  bool _isCommentModified = false;

  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _content = widget.content;
    timeago.setLocaleMessages('ko', timeago.KoMessages());

    Future.microtask(() async {
      await ref.read(postsProvider.notifier).fetchPostById(widget.postId);

      final posts = ref.read(postsProvider);
      final post = posts.firstWhere(
            (p) => p.id == widget.postId,
        orElse: () => posts.first,
      );
      final nicknameNotifier = ref.read(nicknameProvider.notifier);
      nicknameNotifier.getOrCreateNickname(post.id, post.authorName);

      for (var comment in post.comments) {
        nicknameNotifier.getOrCreateNickname(post.id, comment.username);
      }

      setState(() {});
    });

    _commentController.addListener(() {
      setState(() {
        isCommentFilled = _commentController.text.trim().isNotEmpty;
      });
    });
  }

  void _showDeleteConfirmDialog(int postId) {
    final notifier = ref.read(postsProvider.notifier);

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
          final success = await notifier.deletePost(postId);
          if (success && mounted) {
            _isDeleted = true;
            Navigator.of(context, rootNavigator: true).pop({'deleted': true});
          }
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
                _showDeleteConfirmDialog(widget.postId);
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
                final result = await Navigator.push<Map<String, String>>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PostEditPage(title: _title, content: _content),
                  ),
                );

                if (result != null && result.containsKey('content')) {
                  final newTitle = result['title'] ?? _title;
                  final newContent = result['content'] ?? _content;

                  setState(() {
                    _title = newTitle;
                    _content = newContent;
                    _isModified = true;
                  });

                  await ref
                      .read(postsProvider.notifier)
                      .updatePost(widget.postId, newTitle, newContent);
                  await ref.read(postsProvider.notifier).fetchPosts();
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
      Navigator.pop(context, {'deleted': true});
      return;
    }

    final result = <String, bool>{};
    if (_isModified) {
      result['modified'] = true;
    }
    if (_isCommentModified) {
      result['comment_modified'] = true;
    }

    if (result.isNotEmpty) {
      Navigator.pop(context, result);
    } else {
      Navigator.pop(context);
    }
  }

  void _showNotAuthorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '본인이 작성한 댓글만 삭제할 수 있습니다',
          style: FalletterTextStyle.body2.copyWith(
            color: FalletterColor.black,
          ),
        ),
        backgroundColor: FalletterColor.error,
        duration: const Duration(seconds: 2),
      ),
    );
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
    final postNickname = nicknameNotifier.getOrCreateNickname(
      post.id,
      post.authorName,
    );

    // 현재 로그인한 사용자 정보 가져오기
    final userInfoAsync = ref.watch(userInfoProvider);
    final currentUserName = userInfoAsync.maybeWhen(
      data: (data) => data['name'] as String?,
      orElse: () => null,
    );

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
                  nickname: postNickname,
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
                    final commentNickname = nicknameNotifier
                        .getOrCreateNickname(post.id, comment.username);

                    // 현재 사용자가 댓글 작성자인지 확인
                    final isMyComment = currentUserName != null &&
                        comment.username == currentUserName;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CommentItem(
                        nickname: commentNickname,
                        time: timeago.format(
                          comment.createdAt.toLocal(),
                          locale: 'ko',
                        ),
                        text: comment.comment,
                        isAuthor: isMyComment,
                        onDelete: isMyComment
                            ? () async {
                          // 내 댓글이면 삭제 진행
                          print("=== Attempting to delete comment ${comment.id}");
                          final success = await notifier.deleteComment(
                            post.id,
                            comment.id,
                          );
                          print("=== Delete success: $success");

                          if (success) {
                            _isCommentModified = true;
                            setState(() {});
                          }
                        }
                            : () {
                          // 내 댓글이 아니면 스낵바 표시
                          _showNotAuthorSnackBar();
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

                        final success = await notifier.addComment(
                          widget.postId,
                          text,
                        );
                        if (success) {
                          _commentController.clear();
                          _isCommentModified = true;

                          // 새 댓글의 닉네임 생성
                          final posts = ref.read(postsProvider);
                          final updatedPost = posts.firstWhere(
                                (p) => p.id == widget.postId,
                            orElse: () => posts.first,
                          );

                          if (updatedPost.comments.isNotEmpty) {
                            final newComment = updatedPost.comments.last;
                            nicknameNotifier.getOrCreateNickname(
                              widget.postId,
                              newComment.username,
                            );
                          }

                          setState(() {});
                        }
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