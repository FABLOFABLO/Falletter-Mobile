import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserIdProvider = StateProvider<int>((ref) => 1);
final currentUserNicknameProvider = StateProvider<String>((ref) => '유저');

final currentUserAttendanceProvider = StateProvider<int>((ref) => 0);