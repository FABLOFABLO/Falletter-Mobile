import 'package:falletter/presentation/letter_page/widget/student_search_dropdown.dart';
import 'package:falletter/repository/letter/letter_repository.dart';
import 'package:falletter/repository/user/user_find_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:falletter/core/components/button/elevated_button.dart';
import 'package:falletter/core/components/text_form_field/text_form_field.dart';
import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/constants/text_style.dart';
import 'package:falletter/core/providers/item_count_provider.dart';
import 'package:falletter/core/providers/theme_provider.dart';
import 'package:falletter/core/theme/theme_colors.dart';
import 'package:falletter/models/student_model.dart';
import 'package:lottie/lottie.dart';

class LetterPage extends ConsumerStatefulWidget {
  const LetterPage({super.key});

  @override
  ConsumerState<LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends ConsumerState<LetterPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  List<StudentModel> _students = [];
  StudentModel? _selectedStudent;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _hideDropdown();
    _titleController.dispose();
    _contentController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showDropdown(BuildContext context) {
    _hideDropdown();
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (_) => Positioned(
        width: size.width - 40,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 60),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: FalletterColor.middleBlack,
            child: StudentSearchDropdown(
              students: _students,
              query: _titleController.text.trim(),
              isSearching: _isSearching,
              onSelect: (student) {
                setState(() {
                  _selectedStudent = student;
                  _titleController.text = '${student.schoolNumber} ${student.name}';
                });
                _hideDropdown();
                FocusScope.of(context).unfocus();
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Future<void> _onSearch(String query) async {
    setState(() => _isSearching = true);
    final result = await searchStudents(ref: ref, query: query);
    if (!mounted) return;

    setState(() {
      _students = result;
      _isSearching = false;
    });

    result.isEmpty ? _hideDropdown() : _showDropdown(context);
  }

  void _showSubmissionOverlay(ThemeColors themeColors, String receiver) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(204),
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$receiver에게\n레터를 전송할게요.',
                  style: FalletterTextStyle.body1,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Lottie.asset(
                  themeColors.sendLetterLottie,
                  width: 200,
                  height: 131,
                  fit: BoxFit.cover,
                  repeat: false,
                  onLoaded: (composition) {
                    Future.delayed(composition.duration, () {
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      } else {
                        Navigator.of(dialogContext, rootNavigator: true).pop();
                      }
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  '레터는 지금부터 12시간 후에 도착합니다.',
                  style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray200),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    final themeColors = appThemeColors[theme]!;
    final letterCount = ref.watch(itemCountProvider)['letter'] ?? 0;
    final isEnabled = letterCount > 0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 48, bottom: 44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(themeColors.letterSvg, width: 38, height: 26),
                  const SizedBox(width: 12),
                  Text(
                    '$letterCount개',
                    style: FalletterTextStyle.body1.copyWith(color: FalletterColor.white),
                  ),
                ],
              ),
            ),
            Text(
              '누구에게 보내시나요?',
              style: FalletterTextStyle.subTitle1.copyWith(color: FalletterColor.white),
            ),
            const SizedBox(height: 16),
            CompositedTransformTarget(
              link: _layerLink,
              child: CustomTextFormField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                onChanged: (v) => _onSearch(v),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '레터를 작성해주세요',
                  style: FalletterTextStyle.subTitle1.copyWith(color: FalletterColor.white),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${_contentController.text.length}',
                        style: FalletterTextStyle.body3,
                      ),
                      TextSpan(
                        text: '/200',
                        style: FalletterTextStyle.body3.copyWith(color: FalletterColor.gray400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            CustomTextFormField(
              controller: _contentController,
              maxLines: 7,
              maxLength: 200,
              decoration: InputDecoration(counterText: ''),
            ),
            const Spacer(),
            CustomElevatedButton(
              width: double.infinity,
              onPressed: (isEnabled &&
                  _selectedStudent != null &&
                  _contentController.text.trim().isNotEmpty)
                  ? () async {
                final repository = ref.read(letterRepositoryProvider);
                final student = _selectedStudent!;
                final content = _contentController.text.trim();

                try {
                  await repository.sendLetter(
                      receptionId: student.id, content: content);

                  await repository.updateLetterCount(letterUpdate: 1);

                  ref.read(itemCountProvider.notifier).decrement('letter');

                  _showSubmissionOverlay(
                      themeColors, '${student.schoolNumber} ${student.name}');

                  setState(() {
                    _selectedStudent = null;
                    _titleController.clear();
                    _contentController.clear();
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('레터 전송 실패: $e')),
                  );
                }
              }
                  : null,
              child: const Text('레터 전송하기'),
            ),
          ],
        ),
      ),
    );
  }
}