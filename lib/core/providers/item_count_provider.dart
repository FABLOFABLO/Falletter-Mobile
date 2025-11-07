import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemCountProvider =
StateNotifierProvider<ItemCountNotifier, Map<String, int>>(
      (ref) => ItemCountNotifier(),
);

class ItemCountNotifier extends StateNotifier<Map<String, int>> {
  ItemCountNotifier() : super({});

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

  void updateCounts({required int letterCount, required int brickCount}) {
    state = {
      'letter': letterCount,
      'brick': brickCount,
    };
  }

  void reset() {
    state = {};
  }
}