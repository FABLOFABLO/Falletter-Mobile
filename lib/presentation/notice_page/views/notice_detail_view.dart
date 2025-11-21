import 'dart:math';
import 'dart:ui';
import 'package:falletter/core/providers/item_count_provider.dart'
    hide hintProvider;
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/hint_provider.dart';
import 'package:falletter/presentation/notice_page/views/hint_view.dart'
    hide itemCountProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falletter/core/components/button/answer_button.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/theme/theme_colors.dart';

class StudentModel {
  final int id;
  final String name;
  final String schoolNumber;

  StudentModel({
    required this.id,
    required this.name,
    required this.schoolNumber,
  });
}

void hintConfirmModal(
  BuildContext context,
  WidgetRef ref,
  ThemeColors themeColors,
  String title,
  String name,
) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: FalletterColor.middleBlack.withAlpha(204),
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation1, animation2) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '브릭 1개로 힌트를 보실건가요?',
                style: FalletterTextStyle.body1.copyWith(
                  color: FalletterColor.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    themeColors.brickSvg,
                    width: 202,
                    height: 212,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 20,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: FalletterColor.gray100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '-1',
                          style: FalletterTextStyle.title2.copyWith(
                            color: FalletterColor.gray900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '브릭 1개가 차감됩니다.',
                style: FalletterTextStyle.body3.copyWith(
                  color: FalletterColor.gray200,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      gradient: FalletterGradient.horizontal([
                        FalletterColor.gray700,
                        FalletterColor.gray700,
                      ]),
                      child: Text(
                        '취소',
                        style: FalletterTextStyle.body1.copyWith(
                          color: FalletterColor.gray500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () {
                        ref.read(itemCountProvider.notifier).decrement('brick');

                        // 2) 힌트 단계 증가
                        ref.read(hintProvider.notifier).state++;

                        // 3) 서버 브릭 감소(-1)
                        ref.read(brickUpdateProvider(-1));
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HintView(name: name),
                          ),
                        );
                      },
                      gradient: themeColors.primaryGradient,
                      child: const Text('힌트보기'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class NoticeDetailView extends ConsumerWidget {
  final int targetUserId;
  final String title;
  final String emoji;
  final String name;

  const NoticeDetailView({
    super.key,
    required this.targetUserId,
    required this.title,
    required this.emoji,
    required this.name,
  });

  Widget _buildNameButton(
    ThemeColors themeColors,
    StudentModel student,
    bool isMe,
  ) {
    final button = AnswerButton(
      label: student.name,
      onPressed: () {},
      isSelected: false,
      showBorder: isMe,
      borderGradient: isMe ? themeColors.primaryGradient : null,
    );

    if (isMe) return button;

    return ClipRect(
      child: Stack(
        alignment: Alignment.center,
        children: [
          button,
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: FalletterColor.middleBlack.withAlpha(100),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;

    final itemCounts = ref.watch(itemCountProvider);
    final hintStage = ref.watch(hintProvider);
    final brickCount = itemCounts['brick'] ?? 0;

    final bool canGetNextHint = hintStage < 3 && brickCount > 0;

    final myStudent = StudentModel(id: 1, name: "나", schoolNumber: "001");
    final allStudents = [
      myStudent,
      StudentModel(id: 2, name: "학생1", schoolNumber: "002"),
      StudentModel(id: 3, name: "학생2", schoolNumber: "003"),
      StudentModel(id: 4, name: "학생3", schoolNumber: "004"),
    ];

    final options = [...allStudents]..shuffle(Random());

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              showBackButton: true,
              rightWidget: Row(
                children: [
                  SvgPicture.asset(themeColors.brickSvg, width: 38, height: 26),
                  const SizedBox(width: 12),
                  Text("$brickCount개", style: FalletterTextStyle.body1),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        color: FalletterColor.middleBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 90),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      title,
                      style: FalletterTextStyle.title2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.5,
                            ),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final student = options[index];
                          final isMe = student.id == myStudent.id;
                          return _buildNameButton(themeColors, student, isMe);
                        },
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed:
                            canGetNextHint
                                ? () => hintConfirmModal(
                                  context,
                                  ref,
                                  themeColors,
                                  title,
                                  name,
                                )
                                : null,
                        gradient:
                            canGetNextHint
                                ? themeColors.primaryGradient
                                : FalletterGradient.horizontal([
                                  FalletterColor.gray700,
                                  FalletterColor.gray700,
                                ]),
                        child: Text(
                          brickCount == 0
                              ? '브릭이 부족합니다'
                              : hintStage == 0
                              ? '브릭 사용으로 힌트 얻기'
                              : hintStage < 3
                              ? '브릭 사용으로 다음 힌트 얻기'
                              : '모든 힌트 확인 완료',
                          style: FalletterTextStyle.body1.copyWith(
                            color:
                                canGetNextHint
                                    ? FalletterColor.black
                                    : FalletterColor.gray500,
                          ),
                        ),
                      ),
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
}
