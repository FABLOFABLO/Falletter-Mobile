import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/presentation/main_app.dart';
import 'package:falletter/presentation/splash/view/splash_page.dart';
import 'package:falletter/presentation/attendance_page/view/roulette_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final todayAttendanceCheckProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final lastAttendanceDate = prefs.getString('last_attendance_date');
  final today = DateTime.now().toIso8601String().split('T')[0];
  return lastAttendanceDate == today;
});

Future<void> markAttendanceComplete() async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split('T')[0];
  await prefs.setString('last_attendance_date', today);
}

class InitialPage extends ConsumerWidget {
  const InitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessToken = ref.watch(accessTokenProvider);

    if (accessToken == null || accessToken.isEmpty) {
      return const SplashPage();
    }

    final attendanceCheckAsync = ref.watch(todayAttendanceCheckProvider);

    return attendanceCheckAsync.when(
      data: (hasAttendedToday) {
        if (hasAttendedToday) {
          return const MainApp();
        }
        return const RoulettePage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        return const RoulettePage();
      },
    );
  }
}

class PostLoginPage extends ConsumerWidget {
  const PostLoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceCheckAsync = ref.watch(todayAttendanceCheckProvider);

    return attendanceCheckAsync.when(
      data: (hasAttendedToday) {
        if (hasAttendedToday) {
          return const MainApp();
        }
        return const RoulettePage();
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) {
        return const RoulettePage();
      },
    );
  }
}