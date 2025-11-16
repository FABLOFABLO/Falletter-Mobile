import 'dart:async';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/letter_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/receive_letter_provider.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/presentation/my_page/components/received_letter_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReceiveLetterView extends ConsumerStatefulWidget {
  const ReceiveLetterView({super.key});

  @override
  ConsumerState<ReceiveLetterView> createState() => _ReceiveLetterViewState();
}

class _ReceiveLetterViewState extends ConsumerState<ReceiveLetterView> {
  Timer? _autoRefreshTimer;

  @override
  void initState() {
    super.initState();
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  void _setupAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      ref.refresh(receivedLettersProvider);
    });
  }

  Future<void> _refreshLetters() async {
    ref.refresh(receivedLettersProvider);
  }

  void _showLetterModal(BuildContext context, ReceivedLetterModel letter) {
    final userInfoAsync = ref.read(userInfoProvider);

    String myName = '나';

    userInfoAsync.whenData((data) {
      if (data['name'] != null) {
        myName = data['name'] as String;
      }
    });

    final arrivedAt = DateFormat('M월 d일 도착').format(letter.createdAt);

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => LetterModal(
        dear: "$myName에게",
        content: letter.content,
        bottom: arrivedAt,
        onClose: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lettersAsync = ref.watch(receivedLettersProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('내가 받은 레터', style: FalletterTextStyle.title2),
            ),
            Expanded(
              child: lettersAsync.when(
                data: (letters) {
                  if (letters.isEmpty) {
                    return Center(
                      child: Text(
                        '받은 레터가 없습니다.',
                        style: FalletterTextStyle.body2,
                      ),
                    );
                  }

                  letters.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  return RefreshIndicator(
                    onRefresh: _refreshLetters,
                    backgroundColor: FalletterColor.middleBlack,
                    color: FalletterColor.white,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      itemCount: letters.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final letter = letters[index];
                        final preview = letter.content.length > 35
                            ? '${letter.content.substring(0, 35)}...'
                            : letter.content;

                        final arrivedAt =
                        DateFormat('M월 d일 도착').format(letter.createdAt);

                        return GestureDetector(
                          onTap: () => _showLetterModal(context, letter),
                          child: ReceivedLetterBox(
                            arrivedAt: arrivedAt,
                            preview: preview,
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    '오류 발생: ${err.toString()}',
                    style: FalletterTextStyle.body2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}