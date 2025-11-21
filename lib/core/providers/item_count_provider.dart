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

  // 💡 [추가] 서버에서 가져온 브릭 개수로 초기 상태를 설정하는 함수
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

// 💡 [추가] 서버에서 브릭 개수를 가져오는 FutureProvider
final brickCountFutureProvider = FutureProvider<int>((ref) async {
  final service = ref.watch(brickServiceProvider);
  return service.fetchBrickCount();
});


// 💡 [수정] 서버 업데이트 성공 후, brickCountFutureProvider를 무효화하여 UI 동기화
final brickUpdateProvider =
FutureProvider.family<void, int>((ref, brickDelta) async {
  final service = ref.watch(brickServiceProvider);
  await service.updateBrickCount(brickUpdate: brickDelta);
  ref.invalidate(brickCountFutureProvider); // 💡 서버 성공 시 브릭 개수 새로고침
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