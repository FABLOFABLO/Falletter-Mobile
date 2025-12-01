import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/header/header.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart' hide hintProvider;
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/hint_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/core/utils/name_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HintView extends ConsumerWidget {
  final String name;

  const HintView({super.key, required this.name});

  String _getHintTitle(int stage) {
    switch (stage) {
      case 1:
        return '브릭 사용으로 얻은 힌트';
      case 2:
        return '브릭 사용으로 얻은 두번째 힌트';
      case 3:
        return '브릭 사용으로 얻은 마지막 힌트';
      default:
        return '힌트 확인';
    }
  }

  Widget _buildConsonantsByStage(ThemeColors themeColors, int currentStage) {
    final decomposed = decomposeKorean(name);
    final randomized = [...decomposed]..shuffle();
    final int displayCount = currentStage;
    const double size = 100;
    const double hintSize = 90;

    if (currentStage == 1) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: FalletterColor.middleBlack,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: ShaderMask(
          shaderCallback:
              (bounds) => themeColors.primaryGradient.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            decomposed.isNotEmpty ? decomposed[0] : '',
            style: FalletterTextStyle.title1.copyWith(
              fontSize: hintSize,
              color: FalletterColor.white,
              height: 1.0,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        displayCount > decomposed.length ? decomposed.length : displayCount,
        (index) {
          final bool isPaddingRequired = index < displayCount - 1;
          final String char = randomized[index];

          final bool useGradient =
              (currentStage >= 3) || (index == currentStage - 1);

          Widget content =
              useGradient
                  ? ShaderMask(
                    shaderCallback:
                        (bounds) =>
                            themeColors.primaryGradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      char,
                      style: FalletterTextStyle.title1.copyWith(
                        fontSize: hintSize,
                        color: FalletterColor.white,
                        height: 1.0,
                      ),
                    ),
                  )
                  : Text(
                    char,
                    style: FalletterTextStyle.title1.copyWith(
                      fontSize: hintSize,
                      color: FalletterColor.gray700,
                      height: 1.0,
                    ),
                  );

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isPaddingRequired ? 8 : 0,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: FalletterColor.middleBlack,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: content,
            ),
          );
        },
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

    final bool isLastHint = hintStage >= 3;
    final bool isButtonEnabled = brickCount > 0 && !isLastHint;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
                    Text(
                      _getHintTitle(hintStage),
                      style: FalletterTextStyle.title2,
                    ),
                    Text(
                      '선택한 사람의 이름에 들어가는 초성입니다.',
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildConsonantsByStage(themeColors, hintStage),
                    const Spacer(),

                    if (!isLastHint) ...[
                      Text(
                        '더 궁금하다면?',
                        style: FalletterTextStyle.subTitle2,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: CustomElevatedButton(
                          onPressed:
                              isButtonEnabled
                                  ? () {
                                ref.read(itemCountProvider.notifier).decrement('brick');
                                ref.read(hintProvider.notifier).state++;
                                ref.read(brickUpdateProvider(-1));
                                  }
                                  : null,
                          gradient:
                              isButtonEnabled
                                  ? themeColors.button
                                  : FalletterGradient.horizontal([
                                    FalletterColor.gray700,
                                    FalletterColor.gray700,
                                  ]),
                          child: Text(
                            '브릭 사용으로 힌트 얻기',
                            style:
                                isButtonEnabled
                                    ? FalletterTextStyle.body1.copyWith(
                                      color: FalletterColor.black,
                                    )
                                    : FalletterTextStyle.body1.copyWith(
                                      color: FalletterColor.gray500,
                                    ),
                          ),
                        ),
                      ),
                    ],
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
