import 'dart:async';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/letter_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/sent_letter_provider.dart';
import 'package:falletter/core/utils/sent_time_utils.dart';
import 'package:falletter/presentation/my_page/components/sent_letter_box.dart'; // ✅ SentLetterBox로 통일
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SentLetterView extends ConsumerStatefulWidget {
  const SentLetterView({super.key});

  @override
  ConsumerState<SentLetterView> createState() => _SentLetterViewState();
}

class _SentLetterViewState extends ConsumerState<SentLetterView> {
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
      ref.refresh(sentLettersProvider);
    });
  }

  Future<void> _refreshLetters() async {
    ref.refresh(sentLettersProvider);
  }

  void _showLetterModal(SentLetter letter) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (dialogContext) => LetterModal(
            dear: letter.dear,
            content: letter.content,
            bottom: formatSentTime(letter.sentAt),
            onClose: () {
              Navigator.of(dialogContext).pop();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final letters = ref.watch(sentLettersProvider);

    final sendingLetters = letters.where((e) => e.sentAt == null).toList();
    final sentLetters =
        letters.where((e) => e.sentAt != null).toList()
          ..sort((a, b) => a.sentAt!.compareTo(b.sentAt!));

    final sortedLetters = [...sendingLetters, ...sentLetters];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(showBackButton: true),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('내가 보낸 레터', style: FalletterTextStyle.title2),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: FalletterColor.middleBlack,
                color: FalletterColor.white,
                onRefresh: _refreshLetters,
                child: ListView.separated(
                  itemCount: sortedLetters.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final letter = sortedLetters[index];
                    return GestureDetector(
                      onTap: () => _showLetterModal(letter),
                      child: SentLetterBox(
                        sentAt: letter.sentAt,
                        recipientInfo: letter.recipientInfo,
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
