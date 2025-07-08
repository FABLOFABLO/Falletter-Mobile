import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:falletter/core/components/bottom_navigation_bar.dart';
import 'package:falletter/presentation/main_page/view/main_page.dart';
import 'package:falletter/presentation/main_page/view/post_page.dart';
import 'package:falletter/presentation/main_page/view/post_edit_page.dart';
import 'package:falletter/presentation/letter_page/view/letter_page.dart';

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    6,
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
          _buildOffstageNavigator(2, const Placeholder(child: Text('답변'))),
          _buildOffstageNavigator(3, const Placeholder(child: Text('알림'))),
          _buildOffstageNavigator(4, const Placeholder(child: Text('마이페이지'))),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: _onTap,
      ),
    );
  }
}