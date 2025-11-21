import 'package:falletter/core/components/modal/default_modal.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/receive_letter_provider.dart';
import 'package:falletter/core/providers/sent_letter_provider.dart';
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
import 'package:material_symbols_icons/symbols.dart';

class MypageView extends ConsumerWidget {
  final Gradient? gradient;

  const MypageView({super.key, this.gradient});

  Future<void> _refreshData(WidgetRef ref) async {
    ref.invalidate(userInfoProvider);
    ref.invalidate(receivedLettersProvider);
    ref.invalidate(sentLettersProvider);
    // 4. 브릭 사용 내역 새로고침
    // usedBricksProvider의 정의가 가정되어 있습니다.
    // ref.invalidate(usedBricksProvider);

    await ref.read(userInfoProvider.future).catchError((_) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;
    final userInfoAsync = ref.watch(userInfoProvider);

    void showLogoutConfirmDialog(BuildContext dialogContext) {
      showDialog(
        context: dialogContext,
        barrierDismissible: false,
        builder: (BuildContext context) => DefaultModal(
          title: '로그아웃',
          description:
          '기기 내 계정에서 로그아웃할 수 있어요.\n다음 이용 시에는 다시 로그인해야 합니다.\n정말 로그아웃하시겠어요?',
          leftText: '취소',
          rightText: '로그아웃',
          onLeftPressed: () => Navigator.of(context).pop(),
          onRightPressed: () async {
            Navigator.of(context).pop();

            // ref.invalidate(accessTokenProvider);
            ref.invalidate(userInfoProvider);

            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SplashPage()),
                    (route) => false,
              );
            }
          },
        ),
      );
    }

    return userInfoAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Container(
        color: Colors.white,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Symbols.error_outline,
                  color: FalletterColor.error,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  '데이터 로딩 오류 발생',
                  style: FalletterTextStyle.title3.copyWith(
                    color: FalletterColor.middleBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: FalletterTextStyle.body2.copyWith(
                    color: FalletterColor.gray700,
                  ),
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SplashPage()),
                          (route) => false,
                    );
                  },
                  child: const Text('로그인 화면으로'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (user) {
        final nickname = user['name'] ?? '유저';
        final attendanceDays = user['attendanceDays'] ?? 0;
        final letterCount = user['letterCount'] ?? 0;
        final brickCount = user['brickCount'] ?? 0;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(itemCountProvider.notifier).updateCounts(
            letterCount: letterCount,
            brickCount: brickCount,
          );
        });

        return RefreshIndicator(
          onRefresh: () => _refreshData(ref),
          color: FalletterColor.white,
          backgroundColor: FalletterColor.middleBlack,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          count: letterCount,
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
                          count: brickCount,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  TitleSection(
                    title: '내역',
                    items: ['보낸 레터', '받은 레터', '브릭 사용 내역'],
                    onTaps: [
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SentLetterView(),
                        ),
                      ),
                          () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReceiveLetterView(),
                        ),
                      ),
                          () => Navigator.push(
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
                          () => Navigator.push(
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
                    onTaps: [() => showLogoutConfirmDialog(context)],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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