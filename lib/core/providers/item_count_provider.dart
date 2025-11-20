import 'dart:math';
import 'package:falletter/core/providers/auth_token_provider.dart';
import 'package:falletter/models/brick_history_model.dart';
import 'package:falletter/services/brick_service.dart';
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

final hintProvider = StateProvider<int>((ref) => 0);

void resetHintStage(WidgetRef ref) {
  ref.read(hintProvider.notifier).state = 0;
}

void increaseHintStage(WidgetRef ref) {
  ref.read(hintProvider.notifier).state++;
}

final brickServiceProvider = Provider<BrickHistoryService>((ref) {
  final accessToken = ref.watch(accessTokenProvider);
  return BrickHistoryService(accessToken!);
});

final brickUpdateProvider =
FutureProvider.family<void, int>((ref, brickDelta) async {
  final service = ref.watch(brickServiceProvider);
  await service.updateBrickCount(brickUpdate: brickDelta);
  ref.invalidate(itemCountProvider);
});

final brickHistorySaveProvider =
FutureProvider.family<void, BrickHistoryModel>((ref, model) async {
  final service = ref.watch(brickServiceProvider);
  await service.createBrickHistory(model);
});

final brickHistoryProvider = FutureProvider<List<BrickHistoryResponseModel>>((ref) async {
  final service = ref.watch(brickServiceProvider);
  return service.fetchHistory();
});

final selectedHintsProvider = StateProvider<List<String>>((ref) => []);