import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/hint_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HintView extends ConsumerWidget {
  const HintView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;
    final itemCounts = ref.watch(itemCountProvider);
    final hintStage = ref.watch(hintProvider);

    final brickCount = itemCounts['brick'] ?? 0;
    final bool isButtonEnabled = brickCount > 0 && hintStage < 3;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ⛔ Header는 padding 없이 맨 위
            Header(
              showBackButton: true,
              rightWidget: Row(
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
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 69),
                    Text('브릭 사용으로 얻은 힌트', style: FalletterTextStyle.title2),
                    Text(
                      '선택한 사람의 이름에 들어가는 초성입니다.',
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray400,
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: FalletterColor.middleBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) {
                            return themeColors.primaryGradient
                                .createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            'ㅎ',
                            style: FalletterTextStyle.title1.copyWith(
                              fontSize: 90,
                              color: FalletterColor.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      '더 궁금하다면?',
                      style: FalletterTextStyle.subTitle2,
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: CustomElevatedButton(
                        onPressed: isButtonEnabled
                            ? () {
                          ref.read(hintProvider.notifier).state++;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HintView(),
                            ),
                          );
                        }
                            : null,
                        gradient: themeColors.button,
                        child: const Text('브릭 사용으로 힌트 얻기'),
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
