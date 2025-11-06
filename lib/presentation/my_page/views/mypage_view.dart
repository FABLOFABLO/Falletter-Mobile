import 'package:falletter/core/components/modal/default_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/my_page/components/item_box.dart';
import 'package:falletter/presentation/my_page/views/reveive_letter_view.dart';
import 'package:falletter/presentation/my_page/views/sent_letter_view.dart';
import 'package:falletter/presentation/my_page/views/theme_view.dart';
import 'package:falletter/presentation/my_page/views/used_brick_view.dart';
import 'package:falletter/presentation/my_page/widget/title_section.dart';
import 'package:falletter/presentation/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageView extends ConsumerWidget {
  final Gradient? gradient;

  const MypageView({super.key, this.gradient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;
    final userInfoAsync = ref.watch(userInfoProvider);
    final userService = ref.read(userServiceProvider);

    void _showLogoutConfirmDialog(BuildContext dialogContext) {
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            DefaultModal(
              title: '로그아웃',
              description:
              '기기내 계정에서 로그아웃 할 수 있어요.\n다음 이용 시에는 다시 로그인 해야합니다.\n정말 로그아웃하시겠어요?',
              leftText: '취소',
              rightText: '로그아웃',
              onLeftPressed: () => Navigator.of(context).pop(),
              onRightPressed: () async {
                Navigator.of(context).pop();

                try {
                  await userService.logout();
                  ref.invalidate(userInfoProvider);

                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SplashPage()),
                          (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('로그아웃 실패: $e')),
                    );
                  }
                }
              },
            ),
      );
    }

    return userInfoAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('에러 발생: $error')),
      data: (user) {
        final nickname = user['name'] ?? '유저';
        final attendanceDays = user['attendanceDays'] ?? 0;

        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                _ProfileHeader(
                  nickname: nickname,
                  attendanceDays: attendanceDays,
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: ItemBox(
                        item: SvgPicture.asset(
                          themeColors.letterSvg,
                          width: 36,
                          height: 25,
                        ),
                        itemKey: 'letter',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ItemBox(
                        item: SvgPicture.asset(
                          themeColors.brickSvg,
                          width: 36,
                          height: 38,
                        ),
                        itemKey: 'brick',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                TitleSection(
                  title: '내역',
                  items: ['보낸 레터', '받은 레터', '브릭 사용 내역'],
                  onTaps: [
                        () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SentLetterView(),
                          ),
                        ),
                        () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReceiveLetterView(),
                          ),
                        ),
                        () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsedBrickView(),
                          ),
                        ),
                  ],
                ),
                TitleSection(
                  title: '시스템',
                  items: ['테마 설정'],
                  onTaps: [
                        () =>
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ThemeView(),
                          ),
                        ),
                  ],
                ),
                TitleSection(
                  title: '계정',
                  items: ['로그아웃'],
                  onTaps: [() => _showLogoutConfirmDialog(context)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  final String nickname;
  final int attendanceDays;

  const _ProfileHeader({
    required this.nickname,
    required this.attendanceDays,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        width: double.infinity,
        height: 84,
        decoration: BoxDecoration(
          color: FalletterColor.middleBlack,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: themeColors.profile,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nickname, style: FalletterTextStyle.title3),
                Text(
                  '$attendanceDays일 연속 출석중',
                  style: FalletterTextStyle.body3.copyWith(
                    color: FalletterColor.gray400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
