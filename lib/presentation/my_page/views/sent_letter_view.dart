import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/components/modal/letter_modal.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/sent_letter_provider.dart';
import 'package:falletter/presentation/my_page/components/sent_letter_box.dart';
import 'package:falletter/repository/letter/sent_letter_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SentLetterView extends ConsumerWidget {
  const SentLetterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lettersAsync = ref.watch(sentLettersProvider);

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
              child: lettersAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),

                error: (error, stackTrace) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('오류 발생', style: FalletterTextStyle.subTitle1),
                        const SizedBox(height: 8),
                        Text(
                          '$error',
                          style: FalletterTextStyle.body3,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                data: (letters) {
                  if (letters.isEmpty) {
                    return Center(
                      child: Text(
                        '보낸 레터가 없습니다.',
                        style: FalletterTextStyle.body2,
                      ),
                    );
                  }

                  letters.sort((a, b) {
                    if (a.isDelivered && !b.isDelivered) return 1;
                    if (!a.isDelivered && b.isDelivered) return -1;
                    return b.createdAt.compareTo(a.createdAt);
                  });

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: letters.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final letter = letters[index];
                      final receiverInfoText = letter.receiverDisplayName;

                      return GestureDetector(
                        onTap: () async {
                          try {
                            final repo = ref.read(sentLetterRepositoryProvider);
                            final detail = await repo.fetchSentLetterDetail(letter.id);
                            if (!context.mounted) return;

                            showDialog(
                              context: context,
                              builder: (_) => LetterModal(
                                dear: receiverInfoText,
                                content: detail.content,
                                bottom: letter.isDelivered
                                    ? DateFormat('M월 d일 도착').format(detail.createdAt)
                                    : '전송중...',
                                onClose: () => Navigator.pop(context),
                              ),
                            );
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('레터를 불러올 수 없습니다: $e')),
                              );
                            }
                          }
                        },

                        child: SentLetterBox(
                          sentAt: letter.createdAt,
                          recipientInfo: receiverInfoText,
                          isDelivered: letter.isDelivered,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}