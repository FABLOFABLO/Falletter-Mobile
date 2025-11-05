import 'dart:math';
import 'package:falletter/core/providers/roulette_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/presentation/attendance_page/view/roulette_reward_page.dart';
import 'package:falletter/presentation/attendance_page/widget/roulette_pointer.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum RewardType { brick, letter }

class Reward {
  final RewardType type;
  final int amount;

  const Reward(this.type, this.amount);
}

class RouletteWheel extends ConsumerStatefulWidget {
  const RouletteWheel({super.key});

  @override
  ConsumerState<RouletteWheel> createState() => _RouletteWheelState();
}

class _RouletteWheelState extends ConsumerState<RouletteWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isSpinning = false;
  int selectedIndex = 0;

  final List<Reward> rewards = const [
    Reward(RewardType.brick, 1),
    Reward(RewardType.letter, 1),
    Reward(RewardType.brick, 2),
    Reward(RewardType.letter, 2),
    Reward(RewardType.brick, 2),
    Reward(RewardType.letter, 1),
    Reward(RewardType.letter, 2),
    Reward(RewardType.brick, 1),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void spinRoulette() {
    if (isSpinning) return;
    setState(() => isSpinning = true);

    final targetIndex = _getRandomIndex();
    final totalRotation = _calculateRotation(targetIndex);

    _animateRoulette(totalRotation, targetIndex);
  }

  int _getRandomIndex() {
    final random = Random();
    return random.nextInt(rewards.length);
  }

  double _calculateRotation(int targetIndex) {
    final random = Random();
    final spins = 5 + random.nextDouble() * 2;
    final sectionAngle = 360.0 / rewards.length;
    final targetAngle = targetIndex * sectionAngle;
    return (spins * 360) + (360 - targetAngle) + (sectionAngle / 2);
  }

  void _animateRoulette(double totalRotation, int targetIndex) {
    _animation = Tween<double>(begin: 0, end: totalRotation).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward(from: 0).then((_) {
      setState(() {
        isSpinning = false;
        selectedIndex = targetIndex;
      });
      _applyReward();
    });
  }

  void _applyReward() {
    final reward = rewards[selectedIndex];
    final type = reward.type;
    final amount = reward.amount;

    if (type == RewardType.brick) {
      ref.read(brickCountProvider.notifier).state += amount;
    } else {
      ref.read(letterCountProvider.notifier).state += amount;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => RouletteRewardPage(
              type: type,
              amount: amount,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = ref.watch(themeProvider);
    final themeColors = appThemeColors[selectedTheme]!;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 320,
          height: 320,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return Transform.rotate(
                angle: _animation.value * pi / 180,
                child: CustomPaint(
                  size: const Size(320, 320),
                  painter: _RoulettePainter(
                    count: rewards.length,
                    themeColors: themeColors,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 4,
          child: CustomPaint(
            size: const Size(20, 40),
            painter: PointerPainter(),
          ),
        ),
        GestureDetector(
          onTap: isSpinning ? null : spinRoulette,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: themeColors.button,
            ),
            child: Center(
              child: Text(
                'GO',
                style: FalletterTextStyle.title1.copyWith(
                  color: FalletterColor.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoulettePainter extends CustomPainter {
  final int count;
  final ThemeColors themeColors;

  _RoulettePainter({required this.count, required this.themeColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    final sweep = 2 * pi / count;
    final colors = [FalletterColor.gray800, FalletterColor.gray900];

    for (int i = 0; i < count; i++) {
      final paint =
          Paint()
            ..color = colors[i % colors.length]
            ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        i * sweep - pi / 2,
        sweep,
        true,
        paint,
      );
    }

    final border =
        Paint()
          ..color = FalletterColor.gray200
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;
    canvas.drawCircle(center, radius, border);
  }

  @override
  bool shouldRepaint(covariant _RoulettePainter oldDelegate) => false;
}
