import 'package:falletter/core/constants/color.dart';
import 'package:falletter/core/theme/falletter_theme.dart';
import 'package:falletter/initial_page.dart';
import 'package:falletter/presentation/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: FalletterColor.black,
        inputDecorationTheme: inputDecorationTheme,
        textSelectionTheme: textSelectionTheme,
      ),
      home: InitialPage(),
    );
  }
}