import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProgress {
  final Set<int> unlockedCategoryIds;
  final int totalXP;

  UserProgress({required this.unlockedCategoryIds, this.totalXP = 150});

  UserProgress copyWith({Set<int>? unlockedCategoryIds, int? totalXP}) {
    return UserProgress(
      unlockedCategoryIds: unlockedCategoryIds ?? this.unlockedCategoryIds,
      totalXP: totalXP ?? this.totalXP,
    );
  }
}

class ProgressNotifier extends StateNotifier<UserProgress> {
  ProgressNotifier() : super(UserProgress(unlockedCategoryIds: {1}));

  void unlockCategory(int id) {
    state = state.copyWith(
      unlockedCategoryIds: {...state.unlockedCategoryIds, id},
    );
  }

  void addXP(int xp) {
    state = state.copyWith(totalXP: state.totalXP + xp);
  }

  bool isUnlocked(int id) => state.unlockedCategoryIds.contains(id);
}

final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((
  ref,
) {
  return ProgressNotifier();
});
