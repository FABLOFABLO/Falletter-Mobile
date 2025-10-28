import 'dart:async';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/letter_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/receive_letter_provider.dart';
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
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      ref.refresh(receivedLettersProvider);
    });
  }

  Future<void> _refreshLetters() async {
    /// 서버 연동 시, 실제로 새로운 레터 존재 여부를 확인 후 refresh 실행
    ref.refresh(receivedLettersProvider);
  }

  void _showLetterModal(BuildContext context, ReceivedLetter letter) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => LetterModal(
        dear: '${letter.receiptientInfo}에게',
        content: letter.content,
        bottom: '누군가 보냄',
        onClose: () {
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final letters = ref.watch(receivedLettersProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                '내가 받은 레터',
                style: FalletterTextStyle.title2,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: FalletterColor.middleBlack,
                color: FalletterColor.white,
                onRefresh: _refreshLetters,
                child: ListView.separated(
                  itemCount: letters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final letter = letters[index];
                    final preview = letter.content.length > 35
                        ? '${letter.content.substring(0, 35)}...'
                        : letter.content;
                    final arrivedAt =
                    DateFormat('M월 d일 도착').format(letter.receivedAt);

                    return GestureDetector(
                      onTap: () => _showLetterModal(context, letter),
                      child: ReceivedLetterBox(
                        arrivedAt: arrivedAt,
                        preview: preview,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}