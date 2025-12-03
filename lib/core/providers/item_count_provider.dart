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

  void initializeBrickCount(int brickCount) {
    state = {...state, 'brick': brickCount};
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

final brickCountFutureProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(brickServiceProvider);
  return service.fetchBrickCount();
});

class BrickUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  BrickUpdateNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> updateBrickWithHistory({
    required int delta,
    required BrickHistoryModel historyModel,
  }) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(brickServiceProvider);
      await service.updateBrickCount(brickUpdate: delta);
      await service.createBrickHistory(historyModel);
      if (delta < 0) {
        ref.read(itemCountProvider.notifier).decrement('brick');
      } else {
        ref.read(itemCountProvider.notifier).increment('brick');
      }

      ref.invalidate(brickCountFutureProvider);

      ref.invalidate(brickHistoryProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  Future<void> updateBrick(int delta) async {
    state = const AsyncValue.loading();

    try {
      final service = ref.read(brickServiceProvider);
      await service.updateBrickCount(brickUpdate: delta);

      if (delta < 0) {
        ref.read(itemCountProvider.notifier).decrement('brick');
      } else {
        ref.read(itemCountProvider.notifier).increment('brick');
      }

      ref.invalidate(brickCountFutureProvider);

      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
}

final brickUpdateNotifierProvider =
    StateNotifierProvider<BrickUpdateNotifier, AsyncValue<void>>((ref) {
      return BrickUpdateNotifier(ref);
    });

final brickHistoryProvider = FutureProvider<List<BrickHistoryResponseModel>>((
  ref,
) async {
  final service = ref.watch(brickServiceProvider);
  return service.fetchHistory();
});

final selectedHintsProvider = StateProvider<List<String>>((ref) => []);

final randomizedConsonantsProvider = StateProvider.family<List<String>, String>(
  (ref, questionId) => [],
);

void initializeHintsForQuestion(
  WidgetRef ref,
  String questionId,
  String name,
  Function decomposeKorean,
) {
  final decomposed = decomposeKorean(name) as List<String>;
  final randomized = [...decomposed]..shuffle();
  ref.read(randomizedConsonantsProvider(questionId).notifier).state =
      randomized;
}
