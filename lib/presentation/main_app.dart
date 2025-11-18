import 'package:falletter/presentation/answer_page/view/answer_page.dart';
import 'package:falletter/presentation/my_page/views/mypage_view.dart';
import 'package:falletter/presentation/notice_page/views/notice_view.dart';
import 'package:flutter/material.dart';
import 'package:falletter/core/components/bottom_navigation_bar.dart';
import 'package:falletter/presentation/main_page/view/main_page.dart';
import 'package:falletter/presentation/letter_page/view/letter_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    5,
        (_) => GlobalKey<NavigatorState>(),
  );

  void _onTap(int index) {
    if (index == currentIndex) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentIndex = index);
    }
  }

  Widget _buildOffstageNavigator(int index, Widget page) {
    return Offstage(
      offstage: currentIndex != index,
      child: Navigator(
        key: navigatorKeys[index],
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (_) => page,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOffstageNavigator(0, const MainPage()),
          _buildOffstageNavigator(1, const LetterPage()),
          _buildOffstageNavigator(2, const AnswerPage()),
          _buildOffstageNavigator(3, const NoticePage()),
          _buildOffstageNavigator(4, const MypageView()),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
    );
  }
}