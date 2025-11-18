import 'dart:math';
import 'dart:ui';
import 'package:falletter/core/components/button/answer_button.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/hint_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/core/providers/question_providers.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/models/student_model.dart';
import 'package:falletter/presentation/notice_page/views/hint_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _hintConfirmModal(
  BuildContext context,
  WidgetRef ref,
  ThemeColors themeColors,
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
                        FalletterColor.gray200,
                        FalletterColor.gray200,
                      ]),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(hintProvider.notifier).state++;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HintView(),
                            ),
                          );
                        });
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
  final String schoolNumber;
  final String gender;
  final DateTime createdAt;

  const NoticeDetailView({
    super.key,
    required this.targetUserId,
    required this.title,
    required this.emoji,
    required this.schoolNumber,
    required this.gender,
    required this.createdAt,
  });

  Widget _buildNameButton(
    WidgetRef ref,
    ThemeColors themeColors,
    StudentModel student,
    int myId,
  ) {
    final isMe = student.id == myId;
    final showBorder = isMe;

    final button = AnswerButton(
      label: student.name,
      onPressed: () {},
      isSelected: false,
      showBorder: showBorder,
      borderGradient: showBorder ? themeColors.primaryGradient : null,
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
    final hintStage = ref.watch(hintProvider);
    final itemCounts = ref.watch(itemCountProvider);
    final myUser = ref.watch(currentUserInfoProvider);
    final allStudentsAsync = ref.watch(allStudentsProvider);

    if (myUser == null) {
      return const Scaffold(
        backgroundColor: FalletterColor.black,
        body: Center(
          child: CircularProgressIndicator(color: FalletterColor.white),
        ),
      );
    }

    final brickCount = itemCounts['brick'] ?? 0;
    final bool isButtonEnabled = brickCount > 0 && hintStage < 3;

    final Widget nameOptionsGrid = allStudentsAsync.when(
      data: (allStudents) {
        final List<StudentModel> options = [myUser];
        final otherStudents =
            allStudents.where((s) => s.id != myUser.id).toList();
        final random = Random();

        const requiredOthersCount = 3;

        final List<StudentModel> selectedOthers = [];
        if (otherStudents.isNotEmpty) {
          final shuffledOthers = [...otherStudents];
          shuffledOthers.shuffle(random);
          selectedOthers.addAll(shuffledOthers.take(requiredOthersCount));
        }

        while (selectedOthers.length < requiredOthersCount) {
          selectedOthers.add(
            StudentModel(
              id: -(selectedOthers.length + 1),
              name: '유저',
              schoolNumber: '',
            ),
          );
        }

        options.addAll(selectedOthers);
        options.shuffle(random);

        return SizedBox(
          width: double.infinity,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final student = options[index];
              return _buildNameButton(ref, themeColors, student, myUser.id);
            },
          ),
        );
      },
      loading:
          () => const Center(
            child: SizedBox(
              height: 80,
              child: CircularProgressIndicator(color: FalletterColor.white),
            ),
          ),
      error:
          (e, s) => const Center(
            child: Text(
              "학생 목록을 불러올 수 없습니다.",
              style: TextStyle(color: Colors.red),
            ),
          ),
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: Header(showBackButton: true)),
                  Row(
                    children: [
                      SvgPicture.asset(
                        themeColors.brickSvg,
                        width: 38,
                        height: 26,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '$brickCount개',
                        style: FalletterTextStyle.body1,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
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
              nameOptionsGrid,
              const Spacer(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed:
                      isButtonEnabled
                          ? () => _hintConfirmModal(context, ref, themeColors)
                          : null,
                  gradient: themeColors.button,
                  child: const Text('브릭 사용으로 힌트 얻기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
