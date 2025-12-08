import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/letter_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/modal/letter_modal.dart';
import 'package:falletter/core/components/text/gradient_text.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/presentation/main_app.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/presentation/attendance_page/widget/roulette.dart';
import 'package:falletter/models/received_letter_model.dart';
import 'package:falletter/services/received_letter_service.dart';
import 'package:falletter/core/providers/auth_token_provider.dart';

final backgroundOverlay = FalletterColor.black.withAlpha(204);

final lastShownLetterIdProvider = StateProvider<int?>((ref) => null);

class RouletteRewardPage extends ConsumerStatefulWidget {
  final RewardType type;
  final int amount;

  const RouletteRewardPage({
    super.key,
    required this.type,
    required this.amount,
  });

  @override
  ConsumerState<RouletteRewardPage> createState() => _RouletteRewardPageState();
}

class _RouletteRewardPageState extends ConsumerState<RouletteRewardPage> {
  bool _showCheckLetter = false;
  bool _isModalVisible = false;
  ReceivedLetterModel? _newLetter;
  String? _userName;
  bool _isUpdatingReward = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateRewardCount();
    });
  }

  Future<void> _updateRewardCount() async {
    if (_isUpdatingReward) return;
    _isUpdatingReward = true;

    try {
      if (widget.type == RewardType.brick) {
        await ref.read(brickUpdateNotifierProvider.notifier).updateBrick(widget.amount);
        ref.invalidate(userInfoProvider);
      } else {
        final letterService = ref.read(letterServiceProvider);
        await letterService.updateLetterCount(letterUpdate: widget.amount);
        ref.invalidate(userInfoProvider);
        for (int i = 0; i < widget.amount; i++) {
          ref.read(itemCountProvider.notifier).increment('letter');
        }
      }

      await Future.delayed(const Duration(seconds: 2));
      await _checkReceivedLetter();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('보상 지급에 실패했습니다. 다시 시도해주세요.')),
        );
      }
      await Future.delayed(const Duration(seconds: 2));
      await _checkReceivedLetter();
    }
  }

  Future<void> _checkReceivedLetter() async {
    try {
      final userInfo = ref.read(userInfoProvider).value;
      if (userInfo == null) {
        _goToMainPage();
        return;
      }

      _userName = userInfo['name'] as String?;

      final receivedLetterService = ReceivedLetterService();
      final accessToken = ref.read(accessTokenProvider);

      if (accessToken == null) {
        _goToMainPage();
        return;
      }

      final letters = await receivedLetterService.fetchReceivedLetters(accessToken);
      final lastShownId = ref.read(lastShownLetterIdProvider);

      ReceivedLetterModel? newLetter;
      if (letters.isNotEmpty) {
        final latestLetter = letters.first;
        if (lastShownId == null || latestLetter.id != lastShownId) {
          newLetter = latestLetter;
          ref.read(lastShownLetterIdProvider.notifier).state = latestLetter.id;
        }
      }

      if (newLetter != null) {
        setState(() {
          _newLetter = newLetter;
          _showCheckLetter = true;
        });
      } else {
        _goToMainPage();
      }
    } catch (e) {
      _goToMainPage();
    }
  }

  void _showLetterModal() {
    if (_newLetter != null) {
      setState(() => _isModalVisible = true);
    }
  }

  void _closeModal() {
    setState(() => _isModalVisible = false);
    Future.delayed(const Duration(milliseconds: 200), _goToMainPage);
  }

  void _goToMainPage() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainApp()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;

    final isBrick = widget.type == RewardType.brick;
    final rewardName = isBrick ? '브릭' : '레터';
    final iconPath = isBrick ? themeColors.brickSvg : themeColors.letterSvg;

    return Scaffold(
      backgroundColor: Colors.black.withAlpha(204),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _showCheckLetter && _newLetter != null && _userName != null
              ? Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: _showLetterModal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_userName님께\n누군가의 편지가 도착했어요',
                      style: FalletterTextStyle.body1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      themeColors.checkLetterSvg,
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "터치해서 열어보세요",
                      style: FalletterTextStyle.body3.copyWith(
                        color: FalletterColor.gray200,
                      ),
                    ),
                  ],
                ),
              ),
              if (_isModalVisible)
                AnimatedOpacity(
                  opacity: _isModalVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    color: Colors.black.withAlpha(204),
                    alignment: Alignment.center,
                    child: LetterModal(
                      dear: _userName ?? '회원',
                      content: _newLetter!.content,
                      bottom: '누군가 보냄',
                      onClose: _closeModal,
                    ),
                  ),
                ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('출석체크 보상', style: FalletterTextStyle.title3),
              GradientText(
                '$rewardName ${widget.amount}개 획득',
                style: FalletterTextStyle.title1,
                gradient: themeColors.text,
              ),
              const SizedBox(height: 32),
              SvgPicture.asset(
                iconPath,
                width: isBrick ? 200 : 150,
                height: isBrick ? 200 : 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}