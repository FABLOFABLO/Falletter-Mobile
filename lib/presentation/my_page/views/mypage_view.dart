import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:falletter/presentation/my_page/components/item_box.dart';
import 'package:falletter/presentation/my_page/widget/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MypageView extends ConsumerWidget {
  final Gradient? gradient;

  const MypageView({
    super.key,
    this.gradient,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(currentUserNicknameProvider);
    final attendanceDays = ref.watch(currentUserAttendanceProvider);

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            _ProfileHeader(
              nickname: nickname,
              attendanceDays: attendanceDays,
            ),
            Row(
              children: [
                Expanded(
                  child: ItemBox(
                    item: SvgPicture.asset(
                      'assets/icon/letter.svg',
                      width: 36,
                      height: 25,
                    ),
                    itemKey: 'letter',
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ItemBox(
                    item: SvgPicture.asset(
                      'assets/icon/brick.svg',
                      width: 36,
                      height: 38,
                    ),
                    itemKey: 'brick',
                  ),
                ),
              ],
            ),
            TitleSection(
              title: '내역',
              items: ['보낸 레터', '받은 레터', '브릭 사용 내역'],
              onTaps: [() {}, () {}, () {}],
            ),

            TitleSection(
              title: '시스템',
              items: ['테마 설정'],
              onTaps: [() {}],
            ),

            TitleSection(
              title: '계정',
              items: ['로그아웃'],
              onTaps: [() {}],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String nickname;
  final int attendanceDays;

  const _ProfileHeader({
    required this.nickname,
    required this.attendanceDays,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            width: double.infinity,
            height: 84,
            color: FalletterColor.middleBlack,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: FalletterGradient.vertical(
                        FalletterColor.blueGradient,
                      ),
                      shape: BoxShape.circle,
                    ),
                    width: 52,
                    height: 52,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nickname,
                      style: FalletterTextStyle.title3,
                    ),
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
        ),
      ],
    );
  }
}
