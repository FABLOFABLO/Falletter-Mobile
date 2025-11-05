import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final itemCountProvider =
    StateNotifierProvider<itemCountNotifier, Map<String, int>>(
      (ref) => itemCountNotifier(),
    );

class itemCountNotifier extends StateNotifier<Map<String, int>> {
  itemCountNotifier() : super({});

  void setItemCount(String itemName, int count) {
    state = {...state, itemName: count};
  }

  void increment(String itemName) {
    final current = state[itemName] ?? 0;
    state = {...state, itemName: current + 1};
  }

  void decrement(String itemName) {
    final current = state[itemName] ?? 0;
    state = {...state, itemName: max(0, current - 1)};
  }
}
