import 'package:flutter_riverpod/legacy.dart';

final currentUserIdProvider = StateProvider<int>((ref) => 1);

final currentUserNicknameProvider = StateProvider<String>((ref) => '유저');